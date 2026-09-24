#!/usr/bin/env bash
# Hyper OS — one-shot image build.
#   1. render SVG branding to raster assets
#   2. stage the dotfiles into /etc/skel
#   3. build AUR-only packages into the local repo
#   4. mkarchiso
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

./scripts/make-assets.sh
./scripts/get-dotfiles.sh
./scripts/stage-aur.sh

sudo rm -rf work out
sudo mkarchiso -v -w "$ROOT/work" -o "$ROOT/out" profile

echo "ISO ready:"; ls -lh out/*.iso