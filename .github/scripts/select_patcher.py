"""Resolve, download, verify and unpack the KittyPatcher release for one build.

The latest release is resolved exactly once (`resolve`). Every later step
reads the recorded selection.json, downloading by asset ID, never by "latest".

Subcommands:
  resolve  --repo OWNER/REPO --out DIR          query releases/latest once
  download --selection DIR/selection.json       fetch the recorded asset by ID
  verify   --selection ... [--approve-sha256 H] digest + layout + EXE choice

No version, tag or filename is hard-coded. Selection rules:
  * Release asset: exactly one asset whose name matches ASSET_PATTERN.
  * Executable: ZIP members matching EXE_PATTERN. Identical copies (same
    SHA256) are collapsed and the shallowest path wins. Two or more
    *different* executables -> ambiguous -> fail.
"""
import argparse
import hashlib
import json
import os
import re
import sys
import urllib.request
import zipfile
from pathlib import Path, PurePosixPath

ASSET_PATTERN = re.compile(r"^KittyPatcher.*\.zip$", re.I)
EXE_PATTERN = re.compile(r"^KittyPatcher[^/]*\.exe$", re.I)
API = os.environ.get("GITHUB_API_URL", "https://api.github.com").rstrip("/")


class SelectionError(Exception):
    pass


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


# ---------- pure selection logic (unit-tested) ----------

def select_asset(release):
    if not isinstance(release, dict) or "id" not in release:
        raise SelectionError("No latest release found.")
    if release.get("draft") or release.get("prerelease"):
        raise SelectionError("Latest release is a draft or prerelease; refusing it.")
    assets = release.get("assets") or []
    hits = [a for a in assets if ASSET_PATTERN.match(a.get("name", ""))]
    if not hits:
        raise SelectionError(
            f"Release {release.get('tag_name')!r} has no asset matching "
            f"{ASSET_PATTERN.pattern}. Assets: {[a.get('name') for a in assets]}")
    if len(hits) > 1:
        raise SelectionError(
            f"Release {release.get('tag_name')!r} has {len(hits)} KittyPatcher ZIPs "
            f"{[a['name'] for a in hits]}; selection is ambiguous.")
    a = hits[0]
    digest = a.get("digest")
    published = None
    if isinstance(digest, str) and digest.lower().startswith("sha256:"):
        published = digest.split(":", 1)[1].lower()
        if not re.fullmatch(r"[0-9a-f]{64}", published):
            raise SelectionError(f"Published digest is malformed: {digest!r}")
    return {
        "schema_version": 1,
        "release_id": release["id"],
        "tag_name": release.get("tag_name"),
        "release_name": release.get("name"),
        "published_at": release.get("published_at"),
        "target_commitish": release.get("target_commitish"),
        "asset_id": a["id"],
        "asset_name": a["name"],
        "asset_size": a.get("size"),
        "asset_updated_at": a.get("updated_at"),
        "published_sha256": published,
    }


def verify_digest(selection, actual_sha256, approved_sha256=""):
    actual = actual_sha256.lower()
    if selection.get("asset_size") is not None and selection.get("_downloaded_size") not in (
            None, selection["asset_size"]):
        raise SelectionError("Downloaded size differs from the release asset size.")
    pub = selection.get("published_sha256")
    if pub:
        if actual != pub:
            raise SelectionError(
                f"Checksum mismatch: published {pub}, downloaded {actual}. Refusing to run it.")
        return "verified-against-published-digest"
    approved = (approved_sha256 or "").strip().lower()
    if not approved:
        raise SelectionError(
            "The release asset has no published SHA256 digest. Stopping for explicit "
            f"approval: re-run with approve_unverified_patcher_sha256={actual} "
            "if you have independently confirmed this file.")
    if approved != actual:
        raise SelectionError(
            f"Approved SHA256 {approved} does not match downloaded {actual}.")
    return "owner-approved-without-published-digest"


def select_executable(zip_path):
    with zipfile.ZipFile(zip_path) as z:
        bad = z.testzip()
        if bad:
            raise SelectionError(f"Patcher ZIP CRC failure at {bad}.")
        cands = {}
        for info in z.infolist():
            name = info.filename.replace("\\", "/")
            p = PurePosixPath(name)
            if p.is_absolute() or ".." in p.parts or (p.parts and ":" in p.parts[0]):
                raise SelectionError(f"Unsafe path in patcher ZIP: {name}")
            if info.is_dir() or "__MACOSX" in p.parts:
                continue
            if EXE_PATTERN.match(p.name):
                h = hashlib.sha256(z.read(info)).hexdigest()
                cands.setdefault(h, []).append(name)
    if not cands:
        raise SelectionError(f"No executable matching {EXE_PATTERN.pattern} in the patcher ZIP.")
    if len(cands) > 1:
        raise SelectionError(
            "Patcher ZIP contains different KittyPatcher executables: "
            + "; ".join(f"{h[:12]}: {v}" for h, v in cands.items())
            + ". Selection is ambiguous.")
    (h, names), = cands.items()
    chosen = sorted(names, key=lambda n: (len(PurePosixPath(n).parts), n))[0]
    return {"exe_member": chosen, "exe_sha256": h, "identical_copies": sorted(names)}


# ---------- I/O (workflow only) ----------

def _api_get(url, token, accept="application/vnd.github+json"):
    req = urllib.request.Request(url, headers={"Accept": accept,
                                               "X-GitHub-Api-Version": "2022-11-28"})
    if token:
        # not forwarded on redirect to the storage host
        req.add_unredirected_header("Authorization", f"Bearer {token}")
    return urllib.request.urlopen(req, timeout=120)


def cmd_resolve(a):
    out = Path(a.out)
    out.mkdir(parents=True, exist_ok=True)
    with _api_get(f"{API}/repos/{a.repo}/releases/latest", os.environ.get("GH_TOKEN")) as r:
        release = json.load(r)
    (out / "latest-release.json").write_text(json.dumps(release, indent=2), encoding="utf-8")
    sel = select_asset(release)
    sel["repository"] = a.repo
    (out / "selection.json").write_text(json.dumps(sel, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(sel, indent=2))


def cmd_download(a):
    sel_path = Path(a.selection)
    sel = json.loads(sel_path.read_text(encoding="utf-8"))
    dest = sel_path.parent / "asset.zip"
    url = f"{API}/repos/{sel['repository']}/releases/assets/{sel['asset_id']}"
    with _api_get(url, os.environ.get("GH_TOKEN"), "application/octet-stream") as r, \
            open(dest, "wb") as f:
        while chunk := r.read(1 << 20):
            f.write(chunk)
    print(f"Downloaded asset {sel['asset_id']} ({dest.stat().st_size} bytes)")


def cmd_verify(a):
    sel_path = Path(a.selection)
    sel = json.loads(sel_path.read_text(encoding="utf-8"))
    zpath = sel_path.parent / "asset.zip"
    sel["_downloaded_size"] = zpath.stat().st_size
    actual = sha256_file(zpath)
    status = verify_digest(sel, actual, a.approve_sha256)
    exe = select_executable(zpath)
    exe_dir = sel_path.parent / "exe"
    exe_dir.mkdir(exist_ok=True)
    with zipfile.ZipFile(zpath) as z:
        data = z.read(exe["exe_member"])
    exe_path = exe_dir / PurePosixPath(exe["exe_member"]).name
    exe_path.write_bytes(data)
    if sha256_file(exe_path) != exe["exe_sha256"]:
        raise SelectionError("Extracted executable hash changed.")
    baselines = json.loads(Path(a.baselines).read_text(encoding="utf-8"))
    known = [b["label"] for b in baselines["patchers"]
             if b["zip_sha256"] == actual and b["exe_sha256"] == exe["exe_sha256"]]
    sel.pop("_downloaded_size")
    sel.update({
        "zip_sha256": actual,
        "zip_verification": status,
        **exe,
        "exe_path": str(exe_path).replace("\\", "/"),
        "matches_historical_baseline": known,
    })
    sel_path.write_text(json.dumps(sel, indent=2) + "\n", encoding="utf-8")
    md = ["# Patcher selection", "",
          "- Selection: latest release, resolved once for this build",
          f"- Repository: {sel['repository']}",
          f"- Release: {sel['release_name']!r} (id {sel['release_id']}, tag {sel['tag_name']}, published {sel['published_at']})",
          f"- Asset: {sel['asset_name']} (id {sel['asset_id']}, {sel['asset_size']} bytes)",
          f"- ZIP SHA256: {actual} ({status})",
          f"- Executable: {exe['exe_member']} SHA256 {exe['exe_sha256']}",
          f"- Identical copies collapsed: {exe['identical_copies']}",
          f"- Historical baseline match: {known or 'none (new patcher version)'}", ""]
    (sel_path.parent / "PatcherSelection.md").write_text("\n".join(md), encoding="utf-8")
    print(json.dumps(sel, indent=2))
    gh_env = os.environ.get("GITHUB_ENV")
    if gh_env:
        with open(gh_env, "a", encoding="utf-8") as f:
            f.write(f"PATCHER_RELEASE_TAG={sel['tag_name']}\n")


def main(argv=None):
    ap = argparse.ArgumentParser()
    sp = ap.add_subparsers(dest="cmd", required=True)
    r = sp.add_parser("resolve"); r.add_argument("--repo", required=True); r.add_argument("--out", required=True)
    d = sp.add_parser("download"); d.add_argument("--selection", required=True)
    v = sp.add_parser("verify"); v.add_argument("--selection", required=True)
    v.add_argument("--approve-sha256", default="")
    v.add_argument("--baselines", default=".github/patcher-baselines.json")
    a = ap.parse_args(argv)
    try:
        {"resolve": cmd_resolve, "download": cmd_download, "verify": cmd_verify}[a.cmd](a)
    except SelectionError as e:
        print(f"::error::{e}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
