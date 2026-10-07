import collections
import html
import os
import re
from pathlib import Path

GAME = Path("CourseOfTemptation.html")
MODS = Path("work/mods")
REPORT = Path("work/StructuredPatchReport.md")

original = GAME.read_text(encoding="utf-8-sig")


def escape_twine_tags(content):
    converted = re.sub(r'<<(.*?)>>', r'&lt;&lt;\1&gt;&gt;', content)

    if converted == content:
        return content

    converted = html.escape(converted)
    converted = (
        converted.replace("&amp;lt;", "&lt;")
        .replace("&amp;gt;", "&gt;")
        .replace("&#x27;", "&#39;")
    )

    def unescape_match(match):
        return (
            html.unescape(match.group(1))
            + html.unescape(match.group(2))
        )

    modified = converted

    for match in re.finditer(
        r"(&lt;[^&]*?tw-passage)(data[^&]*?&gt;)",
        converted,
        flags=re.DOTALL,
    ):
        modified = modified.replace(
            match.group(0), unescape_match(match)
        )

    for match in re.finditer(
        r"(&lt;tw-passagedata[^&]*?)(?=&gt;)",
        converted,
        flags=re.DOTALL,
    ):
        modified = modified.replace(
            match.group(0), html.unescape(match.group(1))
        )

    return modified


def parse(text):
    parsed = []

    for segment in text.split("~~"):
        segment = escape_twine_tags(segment)
        if "~" in segment:
            old, new = segment.split("~", 1)
            parsed.append((old.strip(), new.strip()))

    for segment in text.split("Replace:"):
        segment = escape_twine_tags(segment)
        if "With:" in segment:
            old, new = segment.split("With:", 1)
            parsed.append((old.strip(), new.strip()))

    return parsed


def short(text):
    text = re.sub(r"\s+", " ", text)
    return text[:150] + ("..." if len(text) > 150 else "")


def clean(text):
    return text.replace("|", r"\|").replace("`", "'")


files = []
entries = []
unsupported = []

for root, dirs, names in os.walk(MODS):
    dirs.sort()
    if Path(root) == MODS:
        dirs[:] = [name for name in dirs if name.lower() != "logs"]

    for name in sorted(names):
        if not name.lower().endswith(".mod"):
            continue

        path = Path(root) / name
        relative = path.relative_to(MODS).as_posix()
        text = path.read_text(encoding="utf-8-sig")
        files.append(relative)

        if re.search(r"^Add Passage:", text, re.M) or "<e>" in text:
            unsupported.append(relative)

        for old, new in parse(text):
            entries.append((relative, old, new))

merged = collections.OrderedDict()
owners = collections.defaultdict(set)
parsed_counts = collections.Counter()

for name, old, new in entries:
    merged[old] = (name, new)
    owners[old].add(name)
    parsed_counts[name] += 1

replayed = original
rows = []

for old, (name, new) in merged.items():
    if not old:
        rows.append((name, old, "ERROR", "Empty search target"))
        continue

    pattern = "(" + re.escape(old).replace(r"\n", r"\s*") + ")"

    if re.search(pattern, replayed):
        try:
            replayed = re.sub(pattern, new, replayed)
            detail = (
                "Replacement includes syntax outside this replay parser"
                if "Add Passage:" in new or "<e>" in new
                else ""
            )
            rows.append((name, old, "applied", detail))
        except Exception as exc:
            rows.append((name, old, "ERROR", str(exc)))
    elif re.search(pattern, original):
        rows.append((
            name, old, "conflict",
            "Present in original, changed before this replay turn",
        ))
    else:
        rows.append((
            name, old, "missing",
            "Not matched by diagnostic replay",
        ))

made = failed = None
log_path = MODS / "logs" / "ModPatchLog.txt"

if log_path.is_file():
    log = log_path.read_text(encoding="utf-8", errors="replace")
    match = re.search(r"Total replacements made: (\d+)", log)
    if match:
        made = int(match.group(1))
    match = re.search(r"Total replacements failed: (\d+)", log)
    if match:
        failed = int(match.group(1))

applied = sum(row[2] == "applied" for row in rows)
not_applied = len(rows) - applied

versions = sorted(set(re.findall(
    r'Config\.saves\.version\s*(?:=|to)\s*'
    r'["\'](v[^"\'\s<>]+)["\']',
    html.unescape(original),
)))

report = [
    "# Patch report",
    "",
    f"- Merge Run ID: {os.environ.get('MERGE_RUN_ID', 'unknown')}",
    f"- Patcher release tag: {os.environ.get('PATCHER_RELEASE_TAG', 'unknown')}",
    f"- Game version: {', '.join(versions) or 'not found'}",
    f"- Mod files read: {len(files)}",
    f"- Parsed entries: {len(entries)}; distinct targets: {len(merged)}",
    f"- Replay: {applied} applied, {not_applied} not applied",
    f"- Patcher log: {made if made is not None else 'unknown'} made, "
    f"{failed if failed is not None else 'unknown'} failed",
    "",
    "## Limitations",
    "",
    "- This is a diagnostic replay, not verification of the patcher EXE.",
    "- Replay rules are inherited from the earlier KittyPatcher v0.1.2 diagnostic.",
    "- Directory and filename order are deterministic here; patcher order is unverified.",
    "- Equal totals do not prove identical per-target results.",
    "- Duplicate-target winners below are replay winners only.",
    "- The replacement-string handling can produce replay errors.",
    "- Counts describe targets, not successfully installed whole mods.",
    "- Gameplay is not verified.",
    "",
]

if (made, failed) == (applied, not_applied):
    report.extend(["Patcher log totals match replay totals.", ""])
else:
    report.extend([
        "WARNING: Patcher totals are unavailable or differ from replay.",
        "",
    ])

per_mod = collections.defaultdict(collections.Counter)

for name, old, status, detail in rows:
    per_mod[name][status] += 1

report.extend([
    "## Per mod",
    "",
    "| Mod | Parsed entries | Surviving targets | Applied | Not applied |",
    "|---|---:|---:|---:|---:|",
])

for name in sorted(files):
    counts = per_mod[name]
    surviving = sum(counts.values())
    report.append(
        f"| {clean(name)} | {parsed_counts[name]} | {surviving} | "
        f"{counts['applied']} | {surviving - counts['applied']} |"
    )

for status, title in (
    ("missing", "Targets missing during replay"),
    ("conflict", "Targets changed before their replay turn"),
    ("ERROR", "Replay errors"),
):
    selected = [row for row in rows if row[2] == status]
    if selected:
        report.extend(["", f"## {title} ({len(selected)})", ""])
        for name, old, state, detail in selected:
            report.append(
                f"- {clean(name)}: `{clean(short(old))}` — {clean(detail)}"
            )

shared = [
    (old, names) for old, names in owners.items()
    if len(names) > 1
]

report.extend(["", f"## Shared targets across mods ({len(shared)})", ""])

if shared:
    for old, names in shared:
        report.append(
            f"- `{clean(short(old))}` — "
            f"{', '.join(clean(name) for name in sorted(names))}; "
            f"replay winner: {clean(merged[old][0])}"
        )
else:
    report.append("- None in parsed entries.")

if unsupported:
    report.extend(["", "## Syntax outside the replay parser", ""])
    report.extend(f"- {clean(name)}" for name in unsupported)

if made is not None and failed is not None:
    badge = (
        f"Partially patched diagnostic build: {made} targets applied, "
        f"{failed} failed. Gameplay unverified."
        if failed
        else f"Patcher reports {made} targets applied, 0 failed. "
        "Gameplay unverified."
    )
else:
    badge = (
        f"Diagnostic build: replay {applied} applied, "
        f"{not_applied} not applied; patcher totals unavailable."
    )

REPORT.write_text("\n".join(report) + "\n", encoding="utf-8")

output_path = os.environ.get("GITHUB_OUTPUT")
if output_path:
    with open(output_path, "a", encoding="utf-8") as output:
        output.write(f"badge={badge}\n")

summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
if summary_path:
    with open(summary_path, "a", encoding="utf-8") as output:
        output.write(
            "# Patch Results\n\n"
            f"- Replay: {applied} applied, {not_applied} not applied.\n"
            f"- Patcher log: {made} made, {failed} failed.\n"
            "- Review StructuredPatchReport.md and raw logs.\n"
            "- Gameplay remains unverified.\n\n"
        )

print(
    f"Report written: replay {applied}/{not_applied}; "
    f"patcher totals {made}/{failed}."
)
