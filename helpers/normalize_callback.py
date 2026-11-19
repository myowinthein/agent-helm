"""Fixed git-filter-repo callback body; pass this file to --commit-callback.

Reads only the approved UTF-8 message map named by HELM_NORMALIZE_MAP. The
workflow owns approval, private-path checks, graph selection and verification.
This file is a callback body, not a standalone command or consumer template.
"""

import json
import os
import re

global _helm_normalize_map
if "_helm_normalize_map" not in globals():
    def unique(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError("Duplicate replacement identity")
            result[key] = value
        return result

    try:
        with open(os.environ["HELM_NORMALIZE_MAP"], "rb") as stream:
            raw = stream.read(32 * 1024 * 1024 + 1)
        if len(raw) > 32 * 1024 * 1024:
            raise ValueError("Replacement map exceeds the size limit")
        replacements = json.loads(raw.decode("utf-8"), object_pairs_hook=unique)
        if not isinstance(replacements, dict) or len(replacements) > 100_000:
            raise ValueError("Invalid replacement map")
        if any(not re.fullmatch(r"[0-9a-f]{40}|[0-9a-f]{64}", key)
               or not isinstance(value, str) or "\0" in value
               for key, value in replacements.items()):
            raise ValueError("Invalid replacement entry")
        _helm_normalize_map = {key.encode("ascii"): value.encode("utf-8")
                               for key, value in replacements.items()}
    except (OSError, ValueError, KeyError, RecursionError):
        raise ValueError("Cannot load the approved UTF-8 normalize message map; preserve recovery and stop") from None

replacement = _helm_normalize_map.get(commit.original_id)
if replacement is not None:
    commit.message = replacement
