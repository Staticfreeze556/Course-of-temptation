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
    """Return (text, number of Replace: blocks converted)."""
    if "With:" not in text:
        return text, 0
    blocks = text.split("Replace:")
    converted = [kittypatcher_escape(b) for b in blocks]
    count = sum(a != b for a, b in zip(blocks, converted))
    return "Replace:".join(converted), count
