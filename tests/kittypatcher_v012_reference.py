"""Reference model of released KittyPatcher v0.1.2 (bundled scripts/*.py).

Copied verbatim in behavior from escape_twine_tags, proc_replacement_old/new and
patch_html_file in the release asset (ZIP SHA256 b105af5a…71d6d8). Only used by
tests to reproduce the patcher locally. CI runs the real EXE on Windows.
"""
import html
import re


def escape_twine_tags(content):
    new_content = re.sub(r'<<(.*?)>>', r'&lt;&lt;\1&gt;&gt;', content)
    if new_content == content:
        return content
    new_content = html.escape(new_content)
    new_content = new_content.replace('&amp;lt;', '&lt;')
    new_content = new_content.replace('&amp;gt;', '&gt;')
    new_content = new_content.replace('&#x27;', '&#39;')
    modified = new_content
    for pattern in (r'(&lt;[^&]*?tw-passage)(data[^&]*?&gt;)',
                    r'(&lt;tw-passagedata[^&]*?)(?=&gt;)()'):
        for m in re.finditer(pattern, new_content, flags=re.DOTALL):
            modified = modified.replace(m.group(0), html.unescape(m.group(1)) + html.unescape(m.group(2)))
    return modified


def load(mod_texts):
    """mod_texts: iterable of file contents (only files ending in lowercase .mod)."""
    mod_dict = {}
    for text in mod_texts:
        text = text.replace("\r\n", "\n")
        for sep, w in (("~~", "~"), ("Replace:", "With:")):
            for block in text.split(sep):
                block = escape_twine_tags(block)
                if w in block:
                    old, new = block.split(w, 1)
                    mod_dict[old.strip()] = new.strip()
    return mod_dict


def patch(game, mod_texts):
    applied, failed = [], []
    for old, new in load(mod_texts).items():
        pattern = rf'({re.escape(old).replace(chr(92) + "n", chr(92) + "s*")})'
        if re.search(pattern, game):
            game = re.sub(pattern, new, game)
            applied.append(old)
        else:
            failed.append(old)
    return game, applied, failed
