"""Pre-escape mod blocks the way KittyPatcher intends, without its entity bug.

KittyPatcher v0.1.2 (escape_twine_tags) HTML-escapes a whole Replace:/With:
block, search text included, when the block contains a raw <<macro>>. Entities
already present (&quot;, &lt;, &#39;...) become &amp;quot; etc., so the search
text no longer matches the game, and the patcher still exits 0.

kittypatcher_escape() mirrors the patcher's conversion, then restores those
double-escaped entities. The result contains no raw <<...>>, so the patcher's
own conversion leaves it unchanged. Used by merge_mods.py and patcher_canary.py.
"""
import html
import re
RAW_MACRO = re.compile(r"<<(.*?)>>")
DOUBLE_ESCAPED_ENTITY = re.compile(
    r"&amp;((?:[A-Za-z][A-Za-z0-9]*|#[0-9]+|#[xX][0-9A-Fa-f]+);)"
)


def kittypatcher_escape(block):
    new = RAW_MACRO.sub(r"&lt;&lt;\1&gt;&gt;", block)
    if new == block:
        return block
    new = html.escape(new)
    new = DOUBLE_ESCAPED_ENTITY.sub(r"&\1", new)
    new = new.replace("&#x27;", "&#39;")

    def unescape(match):
        return html.unescape(match.group(1)) + html.unescape(match.group(2))

    out = new
    for pattern in (
        r"(&lt;[^&]*?tw-passage)(data[^&]*?&gt;)",
        r"(&lt;tw-passagedata[^&]*?)(?=&gt;)()",
    ):
        for match in re.finditer(pattern, new, flags=re.DOTALL):
            out = out.replace(match.group(0), unescape(match))
    return out


def pre_escape_replace_blocks(text):
    """Return (text, number of Replace: blocks converted).

    Own-line <e> markers are applied first (inner content escaped, markers
    removed); any raw <<macro>> left over gets the patcher's conversion.
    """
    if "With:" not in text:
        return text, 0
    blocks = text.split("Replace:")
    converted = [kittypatcher_escape(apply_e_markers(b)) for b in blocks]
    count = sum(a != b for a, b in zip(blocks, converted))
    return "Replace:".join(converted), count


# --- Add Passage: sections and <e> markers -----------------------------------
# Semantics follow the public newer KittyPatcher.py
# (github.com/GrasSlimeGaming/course-of-temptation, pre_proc and
# escape_html_between_tags). That file is a third-party copy, not the release
# the owner uploads:
#   * "Add Passage:" at line start begins a section that runs to the next line
#     starting with Replace:, Add Passage: or Add Javascript: (or end of file);
#     its passages are inserted just before </tw-storydata>.
#   * Lines between a line "<e>" and a line "</e>" are HTML-escaped; the marker
#     lines are removed.
# One extension, approved by the owner and labeled as inferred: a leftover
# "r:" / "w:" pair inside a section is treated as Replace:/With:.

STORY_END = "</tw-storydata>"
SECTION = re.compile(
    r"^Add Passage:[ \t]*\n(.*?)(?=^Replace:|^Add Passage:|^Add Javascript:|\Z)",
    re.S | re.M,
)
PASSAGE = re.compile(r"<tw-passagedata ([^<>]*)>(.*?)</tw-passagedata>", re.S)
ATTR = re.compile(r'(\w+)="([^"<>&]*)"')
SHORT_RW = re.compile(r"\A\s*^r:[ \t]*\n(.*?)^w:[ \t]*\n(.*?)\s*\Z", re.S | re.M)


class ModFormatError(ValueError):
    pass


def escape_text(text):
    """html.escape without double-escaping existing entities (game uses &#39;)."""
    out = DOUBLE_ESCAPED_ENTITY.sub(r"&\1", html.escape(text))
    return out.replace("&#x27;", "&#39;")


def apply_e_markers(text):
    """Escape content between own-line <e> and </e>; drop the marker lines."""
    if "<e>" not in text and "</e>" not in text:
        return text
    out, buf, inside = [], [], False
    for line in text.split("\n"):
        s = line.strip()
        if s == "<e>":
            if inside:
                raise ModFormatError("Nested <e> marker.")
            inside = True
        elif s == "</e>":
            if not inside:
                raise ModFormatError("</e> without matching <e>.")
            out.append(escape_text("\n".join(buf)))
            buf, inside = [], False
        elif "<e>" in line or "</e>" in line:
            raise ModFormatError(f"Inline <e> marker is not supported: {line.strip()[:80]!r}")
        elif inside:
            buf.append(line)
        else:
            out.append(line)
    if inside:
        raise ModFormatError("Unclosed <e> marker.")
    return "\n".join(out)


def extract_add_passages(text):
    """Return (text without sections, passages, inferred Replace/With blocks)."""
    passages, inferred, pieces, last = [], [], [], 0
    if "Add Javascript:" in text:
        raise ModFormatError("Add Javascript: is not supported.")
    for sec in SECTION.finditer(text):
        body = sec.group(1)
        for m in PASSAGE.finditer(body):
            attrs = dict(ATTR.findall(m.group(1)))
            if not {"pid", "name", "tags"} <= attrs.keys() or ATTR.sub("", m.group(1)).strip():
                raise ModFormatError(f"Unparseable passage header: {m.group(1)[:80]!r}")
            raw_outside = re.sub(r"^<e>$.*?^</e>$", "", m.group(2), flags=re.S | re.M)
            if re.search(r"[<>]", raw_outside):
                raise ModFormatError(f"Raw markup outside <e> in passage {attrs['name']!r}.")
            passages.append({**attrs, "header": m.group(1),
                             "body": apply_e_markers(m.group(2))})
        leftover = PASSAGE.sub("", body)
        replacement = ""
        if leftover.strip():
            rw = SHORT_RW.match(leftover)
            if not rw:
                raise ModFormatError(f"Unrecognized text in Add Passage section: {leftover.strip()[:80]!r}")
            inferred.append(rw.group(1).strip())
            replacement = f"\nReplace:\n{rw.group(1).strip()}\nWith:\n{rw.group(2).strip()}\n"
        pieces += [text[last:sec.start()], replacement]
        last = sec.end()
    pieces.append(text[last:])
    return "".join(pieces), passages, inferred


def passage_block(passages):
    """One Replace:/With: block inserting the passages before </tw-storydata>."""
    tags = "".join(f'<tw-passagedata {p["header"]}>{p["body"]}</tw-passagedata>' for p in passages)
    return f"\nReplace:\n{STORY_END}\nWith:\n{tags}{STORY_END}\n"


def validate_passages(passages, game):
    errors = []
    names = re.findall(r'<tw-passagedata [^>]*name="([^"]*)"', game)
    pids = re.findall(r'<tw-passagedata pid="(\d+)"', game)
    seen_n, seen_p = set(), set()
    for p in passages:
        if p["name"] in seen_n or p["name"] in names:
            errors.append(f"Passage name conflict: {p['name']!r}")
        if p["pid"] in seen_p or p["pid"] in pids:
            errors.append(f"Passage id conflict: {p['pid']} ({p['name']!r})")
        seen_n.add(p["name"]); seen_p.add(p["pid"])
        if "\\" in p["body"] or "\\" in p["header"]:
            errors.append(f"Backslash in passage {p['name']!r} (patcher would alter it).")
        if "<" in p["body"] or RAW_MACRO.search(p["header"]):
            errors.append(f"Unescaped markup in passage {p['name']!r}.")
    if game.count(STORY_END) != 1:
        errors.append(f"{STORY_END} must occur exactly once in the game.")
    return errors


def passage_references(body):
    """Passage names referenced by an (escaped) added passage body."""
    t = html.unescape(body)
    refs = set(re.findall(r'<<include "([^"]+)"', t))
    refs |= set(re.findall(r'Dialog\.setup\("([^"]+)"', t))
    refs |= set(re.findall(r'Story\.get\("([^"]+)"', t))
    for group in re.findall(r"_dialogs to \[([^\]]*)\]", t):
        refs |= set(re.findall(r'"([^"]+)"', group))
    for link in re.findall(r"\[\[([^\]]+)\]\]", t):
        refs.add(link.split("|")[-1].split("->")[-1].strip())
    return refs
