#!/usr/bin/env bash
set -euo pipefail

echo "==> Re-locking upstream contributor-network"
uv lock --upgrade-package contributor-network

NEW_SHA="$(scripts/extract-upstream-sha.py)"
OLD_SHA="$(cat .upstream-ref)"

if [ "$NEW_SHA" = "$OLD_SHA" ]; then
  echo "==> No upstream change ($NEW_SHA). Nothing to do."
  exit 0
fi

echo "==> Bumping .upstream-ref: $OLD_SHA -> $NEW_SHA"
echo "$NEW_SHA" > .upstream-ref

echo "==> Compare URL: https://github.com/developmentseed/contributor-network/compare/${OLD_SHA}...${NEW_SHA}"
git diff .upstream-ref uv.lock
echo "==> Review the diff, then commit and open a PR."
