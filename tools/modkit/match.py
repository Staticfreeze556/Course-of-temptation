"""Exact-match classification against the original game. Report only.

Categories match .github/scripts/inspect_mods.py. The whitespace category is
diagnostic: it never causes a block to be treated as applicable.
"""
import re
from collections import defaultdict

ONE = "One exact original match"
MULTI = "Multiple exact original matches"
WS = "Possible whitespace-only difference"
NONE = "No exact match in original HTML"
EMPTY = "Empty search target"


def classify_blocks(blocks, game_text):
    squashed = re.sub(r"\s+", "", game_text)
    results = []
    by_target = defaultdict(list)
    for b in blocks:
        by_target[b.find].append(b.mod)
        if not b.find:
            results.append((b, EMPTY, 0))
            continue
        n = game_text.count(b.find)
        if n == 1:
            cat = ONE
        elif n > 1:
            cat = MULTI
        else:
            t = re.sub(r"\s+", "", b.find)
            cat = WS if t and t in squashed else NONE
        results.append((b, cat, n))
    shared = {t: sorted(set(m)) for t, m in by_target.items() if len(set(m)) > 1}
    return results, shared
