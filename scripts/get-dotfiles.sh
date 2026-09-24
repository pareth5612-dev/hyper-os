#!/usr/bin/env bash
# Hyper OS — fetch and stage dotfiles into /etc/skel.
# The installed system is a copy of the live root, so dotfiles shipped
# here become the default for every new user (including the live user).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
A="$ROOT/profile/airootfs"
SKEL="$A/etc/skel"

URL="https://github.com/ilyamiro/imperative-dots"

if [ ! -d "$SKEL/.git" ]; then
    rm -rf "$SKEL"
    git clone --depth 1 "$URL" "$SKEL"
fi

rm -rf "$SKEL/.git"
rm -f "$SKEL/install.sh" "$SKEL/updates.json"

# Hyper OS additions to the dots' autostart chain (idempotent)
CONF="$SKEL/.config/hypr/config/autostart.conf"
if [ -f "$CONF" ] && ! grep -q "hyper-install-launcher" "$CONF"; then
    cat >> "$CONF" <<'EOF'

# --- Hyper OS (appended by get-dotfiles.sh) ---
exec-once = /usr/local/bin/hyper-install-launcher
EOF
fi

# Attribution copy lives in /usr/share/doc instead of the user home
mkdir -p "$A/usr/share/doc/hyper"
cp "$SKEL/README.md" "$A/usr/share/doc/hyper/dotfiles-README.md"
rm -f "$SKEL/README.md"

echo "dotfiles staged into $SKEL"