"""Behavior canary for whichever KittyPatcher the build selected.

  prepare DIR   write a synthetic game + mods into DIR (nothing from Mods.zip)
  check   DIR --out REPORT.json [--accept-findings]

The executable runs on the canary first. Required checks must pass or the
build stops. Profile checks compare against the *intended* literal behavior.
Any deviation is a finding, and the build stops before the real patch unless
the owner explicitly accepts findings, which labels the build diagnostic.
"""
import argparse
import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from kitty_escape import pre_escape_replace_blocks  # noqa: E402

GAME = """<html><body>
<p>CANARY_KITTY_A</p>
<p>CANARY_RW_B</p>
<p>CANARY_UNTOUCHED_C</p>
<p>&lt;&lt;set _x to &quot;CANARY_ENTITY_D&quot;&gt;&gt;</p>
<p>CANARY_BACKSLASH_E</p>
<p>CANARY_MULTI_F</p><p>CANARY_MULTI_F</p>
<p>CANARY_UPPER_G</p>
<p>&lt;&lt;set _label to &quot;CANARY_MIX_H&quot;&gt;&gt;</p>
<p>&lt;&lt;set _label to &quot;CANARY_MIX_I&quot;&gt;&gt;</p>
</body></html>
"""

MODS = {
    # required
    "canary_required_kitty.mod": "CANARY_KITTY_A~CANARY_KITTY_A_DONE~~CANARY_MISSING_Z~SHOULD_NOT_APPEAR",
    "canary_required_rw.mod": "Replace:\nCANARY_RW_B\nWith:\nCANARY_RW_B_DONE\n",
    # Entities and a raw <<macro>> in the SAME block. KittyPatcher v0.1.2
    # double-escapes the entities (&quot; -> &amp;quot;) and the block fails.
    # Required: the merger's pre-escaped form (kitty_escape) applies.
    # Profile: the unconverted form, recorded so a fixed patcher is visible.
    "canary_required_mixed_preescaped.mod": pre_escape_replace_blocks(
        "Replace:\n&lt;&lt;set _label to &quot;CANARY_MIX_H&quot;&gt;&gt;\n"
        "With:\n&lt;&lt;set _label to &quot;CANARY_MIX_H_DONE&quot;&gt;&gt;\n<<set _probe to 1>>\n")[0],
    "canary_profile_mixed_raw.mod": (
        "Replace:\n&lt;&lt;set _label to &quot;CANARY_MIX_I&quot;&gt;&gt;\n"
        "With:\n&lt;&lt;set _label to &quot;CANARY_MIX_I_DONE&quot;&gt;&gt;\n<<set _probe to 2>>\n"),
    # profile
    "canary_profile_entity.mod": (
        "Replace:\n&lt;&lt;set _x to &quot;CANARY_ENTITY_D&quot;&gt;&gt;\n"
        "With:\n&lt;&lt;set _x to &quot;CANARY_ENTITY_D_DONE&quot;&gt;&gt;\n"
        "Replace:\nNO_SUCH_TEXT_FOR_RAW_MACRO\nWith:\n<<set _y to 1>>\n"),
    "canary_profile_backslash.mod": "CANARY_BACKSLASH_E~CANARY_BACKSLASH_E_DONE \\n \\1 \\\\ end",
    "canary_profile_multi.mod": "CANARY_MULTI_F~CANARY_MULTI_F_DONE",
    "canary_profile_upper.Mod": "CANARY_UPPER_G~CANARY_UPPER_G_DONE",
}


def sha(b):
    return hashlib.sha256(b).hexdigest()


def prepare(d):
    d = Path(d)
    (d / "mods").mkdir(parents=True, exist_ok=True)
    (d / "CourseOfTemptation.html").write_bytes(GAME.encode())
    for n, t in MODS.items():
        (d / "mods" / n).write_bytes(t.encode())
    manifest = {n: sha(t.encode()) for n, t in MODS.items()}
    (d / "canary-inputs.json").write_text(json.dumps(manifest, indent=2))
    print(f"Canary prepared in {d}")


def evaluate(output_text, mods_dir):
    out = output_text.replace("\r\n", "\n")
    req, prof = {}, {}
    req["kitty exact replacement applied"] = "CANARY_KITTY_A_DONE" in out
    req["replace/with exact replacement applied"] = "CANARY_RW_B_DONE" in out
    req["missing target inserts nothing"] = "SHOULD_NOT_APPEAR" not in out
    req["untouched text preserved"] = "<p>CANARY_UNTOUCHED_C</p>" in out
    req["mixed entity + raw macro block applies after merger pre-escape"] = (
        "CANARY_MIX_H_DONE" in out and "&amp;quot;" not in out)
    inputs = json.loads((mods_dir.parent / "canary-inputs.json").read_text())
    req["canary mod files unchanged"] = all(
        (mods_dir / n).is_file() and sha((mods_dir / n).read_bytes()) == h
        for n, h in inputs.items())
    prof["entity target in file with raw <<macro>> applied (intended: yes)"] = (
        "CANARY_ENTITY_D_DONE" in out, True)
    want = "CANARY_BACKSLASH_E_DONE \\n \\1 \\\\ end"
    prof["backslashes in replacement kept literally (intended: yes)"] = (want in out, True)
    multi = out.count("CANARY_MULTI_F_DONE")
    prof["multi-match target: replaced occurrences (recorded only)"] = (multi, None)
    prof["uppercase .Mod file loaded (recorded only)"] = ("CANARY_UPPER_G_DONE" in out, None)
    prof["mixed entity + raw macro block applied without pre-escape (recorded only)"] = (
        "CANARY_MIX_I_DONE" in out, None)
    prof["output uses CRLF (recorded only)"] = ("\r\n" in output_text, None)
    findings = [k for k, (got, intended) in prof.items()
                if intended is not None and got != intended]
    return req, prof, findings


def check(d, out_path, accept):
    d = Path(d)
    html = d / "CourseOfTemptation.html"
    if not html.is_file():
        print("::error::Canary output HTML missing.")
        return 1
    raw = html.read_bytes()
    req, prof, findings = evaluate(raw.decode("utf-8", "replace"), d / "mods")
    failed = [k for k, v in req.items() if not v]
    report = {
        "canary_output_sha256": sha(raw),
        "required": req,
        "profile": {k: {"observed": v[0], "intended": v[1]} for k, v in prof.items()},
        "findings": findings,
        "required_failed": failed,
        "findings_accepted": bool(accept and findings),
        "build_label": (
            "blocked" if failed or (findings and not accept)
            else "diagnostic: patcher behavior findings accepted" if findings
            else "normal"),
    }
    Path(out_path).write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2))
    if failed:
        print(f"::error::Patcher failed required canary checks: {failed}")
        return 1
    if findings and not accept:
        print("::error::Patcher behavior differs from intended literal patching: "
              f"{findings}. Review PatcherCanary.json; re-run with "
              "accept_patcher_behavior_findings=true to produce a diagnostic build.")
        return 1
    return 0


def main(argv=None):
    ap = argparse.ArgumentParser()
    sp = ap.add_subparsers(dest="cmd", required=True)
    p = sp.add_parser("prepare"); p.add_argument("dir")
    c = sp.add_parser("check"); c.add_argument("dir"); c.add_argument("--out", required=True)
    c.add_argument("--accept-findings", default="false")
    a = ap.parse_args(argv)
    if a.cmd == "prepare":
        prepare(a.dir); return 0
    return check(a.dir, a.out, str(a.accept_findings).lower() == "true")


if __name__ == "__main__":
    sys.exit(main())
