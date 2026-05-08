#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REF="$(cat .upstream-ref)"
CACHE_DIR=".upstream-cache"
ROOT="$(pwd)"

echo "==> Syncing upstream@${UPSTREAM_REF} into ${CACHE_DIR}"
rm -rf "$CACHE_DIR"
npx --yes degit "developmentseed/contributor-network#${UPSTREAM_REF}" "$CACHE_DIR"

echo "==> Overlaying NASA-specific files"
cp config.toml "$CACHE_DIR/config.toml"
rm -rf "$CACHE_DIR/public/data"
cp -r public/data "$CACHE_DIR/public/data"
[ -f public/img/site-image.jpg ] && cp public/img/site-image.jpg "$CACHE_DIR/public/img/site-image.jpg"
[ -f public/img/favicon.png ]    && cp public/img/favicon.png    "$CACHE_DIR/public/img/favicon.png"

echo "==> Regenerating config.json and index.html from our config.toml"
( cd "$CACHE_DIR" && uv --project "$ROOT" run contributor-network build --directory public/data )

echo "==> Building frontend"
( cd "$CACHE_DIR" && npm ci && npm run build )

echo "==> Surfacing dist/ at repo root"
rm -rf dist
cp -r "$CACHE_DIR/dist" dist

echo "==> Build complete: dist/"
