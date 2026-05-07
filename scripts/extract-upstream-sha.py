#!/usr/bin/env python3
"""Extract the resolved git SHA for the upstream contributor-network package
from uv.lock. Prints the SHA to stdout."""

import sys
import tomllib
from pathlib import Path
from urllib.parse import urlparse


def main() -> int:
    lock_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("uv.lock")
    with open(lock_path, "rb") as f:
        lock = tomllib.load(f)
    for package in lock.get("package", []):
        if package.get("name") != "contributor-network":
            continue
        source = package.get("source", {})
        git_url = source.get("git")
        if not git_url:
            print(
                f"contributor-network in {lock_path} has no git source",
                file=sys.stderr,
            )
            return 1
        fragment = urlparse(git_url).fragment
        if not fragment:
            print(
                f"contributor-network git URL has no SHA fragment: {git_url}",
                file=sys.stderr,
            )
            return 1
        print(fragment)
        return 0
    print(f"contributor-network not found in {lock_path}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
