#!/usr/bin/env bash
# Hyper OS — build AUR-only packages into the local repo used at build time.
# pacman.conf on the build host references this repo as "[hyper]".
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$ROOT/localrepo"
TMP="$(mktemp -d /tmp/opencode/aurXXXXXX)"
PKGS=(calamares paru quickshell-git matugen-bin)

trap 'rm -rf "$TMP"' EXIT

mkdir -p "$REPO"

for p in "${PKGS[@]}"; do
    d="$TMP/$p"
    echo "==> staging $p"
    git clone --quiet --depth 1 "https://aur.archlinux.org/$p.git" "$d"
    ( cd "$d" && makepkg -fs --noconfirm )
    cp "$d"/*.pkg.tar.zst "$REPO/"
done

repo-add -q "$REPO/hyper.db.tar.gz" "$REPO"/*.pkg.tar.zst

echo "local repository ready at $REPO"