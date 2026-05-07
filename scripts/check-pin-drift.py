#!/usr/bin/env python3
"""Verify that .upstream-ref and uv.lock reference the same upstream SHA.
Exits 0 on match, 1 on drift."""

import subprocess
import sys
from pathlib import Path


def main() -> int:
    pin_path = Path(".upstream-ref")
    if not pin_path.exists():
        print(".upstream-ref is missing", file=sys.stderr)
        return 1
    pin_sha = pin_path.read_text().strip()

    result = subprocess.run(
        [sys.executable, "scripts/extract-upstream-sha.py"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        return result.returncode
    lock_sha = result.stdout.strip()

    if pin_sha != lock_sha:
        print(
            f"PIN DRIFT: .upstream-ref={pin_sha} uv.lock={lock_sha}",
            file=sys.stderr,
        )
        return 1
    print(f"OK: .upstream-ref and uv.lock both at {pin_sha}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
