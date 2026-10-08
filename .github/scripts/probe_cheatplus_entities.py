import argparse
import hashlib
import json
import shutil
import subprocess
from pathlib import Path

TARGET = '&lt;&lt;set _label to &quot;Watch TV&quot;&gt;&gt;'
RESULT = '&lt;&lt;set _label to &quot;ENTITY_PROBE_DONE&quot;&gt;&gt;'
CASES = {
    "escaped_only": f"Replace:\n{TARGET}\nWith:\n{RESULT}\n",
    "raw_macro_same_block": f"Replace:\n{TARGET}\nWith:\n{RESULT}\n<<set _probe to 1>>\n",
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def prepare(root, name):
    folder = root / name
    (folder / "mods").mkdir(parents=True, exist_ok=False)
    (folder / "CourseOfTemptation.html").write_bytes(
        ("<html><body>" + TARGET + "<p>UNTOUCHED</p></body></html>").encode()
    )
    mod = folder / "mods" / "probe.mod"
    mod.write_bytes(CASES[name].encode())
    return folder, digest(mod)


def evaluate(folder, original_mod_hash):
    output = (folder / "CourseOfTemptation.html").read_text(encoding="utf-8-sig")
    logs = sorted((folder / "mods" / "logs").glob("*.txt"))
    return {
        "replacement_marker_present": "ENTITY_PROBE_DONE" in output,
        "untouched_marker_preserved": "<p>UNTOUCHED</p>" in output,
        "mod_unchanged": digest(folder / "mods" / "probe.mod") == original_mod_hash,
        "output_sha256": digest(folder / "CourseOfTemptation.html"),
        "log_paths": [str(p) for p in logs],
        "double_escaped_quote_in_logs": any(
            "&amp;quot;" in p.read_text(encoding="utf-8-sig", errors="replace")
            for p in logs
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--selection", required=True)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()
    selection = json.loads(Path(args.selection).read_text(encoding="utf-8"))
    if selection.get("zip_verification") != "verified-against-published-digest":
        raise SystemExit("Probe requires a published-digest-verified patcher.")
    executable = Path(selection["exe_path"]).resolve()
    if digest(executable) != selection["exe_sha256"]:
        raise SystemExit("Patcher executable identity changed.")
    root = Path(args.out).resolve()
    root.mkdir(parents=True, exist_ok=False)
    report = {"diagnostic_only": True, "selection": selection, "cases": {}}
    for name in CASES:
        folder, original_hash = prepare(root, name)
        copied = folder / executable.name
        shutil.copyfile(executable, copied)
        try:
            if digest(copied) != selection["exe_sha256"]:
                raise ValueError("Copied executable identity changed.")
            result = subprocess.run(
                [str(copied)], cwd=folder, input=b"\n",
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=120,
            )
            (folder / "console.txt").write_bytes(result.stdout)
            case = evaluate(folder, original_hash)
            case["exit_code"] = result.returncode
            report["cases"][name] = case
        except Exception as exc:
            report["cases"][name] = {"error": f"{type(exc).__name__}: {exc}"}
        finally:
            copied.unlink(missing_ok=True)
    (root / "EntityProbe.json").write_text(json.dumps(report, indent=2) + "\n")
    required = ("replacement_marker_present", "untouched_marker_preserved", "mod_unchanged")
    if any(c.get("exit_code") != 0 or not all(c.get(k) for k in required)
           for c in report["cases"].values()):
        raise SystemExit("Entity probe findings: inspect EntityProbe.json and logs.")


if __name__ == "__main__":
    main()
