"""Read-only Helm helpers. See prompts/shared/ledger-helper.md before use."""

import json
from pathlib import Path
import sys

sys.dont_write_bytecode = True


def main():
    if sys.version_info < (3, 11):
        print(json.dumps({"interface_version": 1, "error": {"kind": "runtime_unavailable",
                                                         "message": "Python 3.11 or newer is required"}}), file=sys.stderr)
        return 3
    # -I excludes the script directory; add only the trusted installed bundle.
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    try:
        from helm_lib.ledger import run
    except Exception:
        print(json.dumps({"interface_version": 1, "error": {"kind": "internal_error",
                                                         "message": "Cannot load bundled helper; repair the package"}}), file=sys.stderr)
        return 7
    return run(sys.argv[1:])


if __name__ == "__main__":
    sys.exit(main())
