#!/usr/bin/env bash
# Hyper OS — render vector branding into the raster assets the profile needs.
# Run from the repo root before mkarchiso.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
B="$ROOT/branding"
A="$ROOT/profile/airootfs"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT

svg() { # svg width height out
    rsvg-convert -w "$2" -h "$3" -o "$4" "$1"
}

# --- Calamares branding ---
D="$A/etc/calamares/branding/hyper-os"
mkdir -p "$D"
svg "$B/bolt.svg"        256 256 "$D/bolt.png"
svg "$B/logo.svg"        560 160 "$D/logo.png"
svg "$B/splash.svg"      960 540 "$D/welcome.png"
svg "$B/splash.svg"      800 520 "$D/wallpaper.png"

# --- Live wallpaper for hyper-switch ---
D="$A/usr/share/hyper/wallpapers"
mkdir -p "$D"
svg "$B/wallpapers/bolt-dark.svg" 1920 1080 "$D/bolt-dark.png"

# --- SDDM theme (sddm only searches /usr/share/sddm/themes) ---
D="$A/usr/share/sddm/themes/hyper-bolt"
mkdir -p "$D"
svg "$B/bolt.svg" 400 400 "$D/logo.png"
svg "$B/wallpapers/bolt-dark.svg" 1920 1080 "$T/sddm-wallpaper.png"
convert "$T/sddm-wallpaper.png" -quality 88 "$D/wallpaper.jpg"

# --- GRUB theme for the installed system ---
D="$A/usr/share/grub/themes/hyper-os"
mkdir -p "$D"
svg "$B/wallpapers/bolt-dark.svg" 1920 1080 "$T/grub-desktop.png"
convert "$T/grub-desktop.png" -depth 8 PNG24:"$D/desktop.png"

# --- SYSLINUX splash ---
svg "$B/splash.svg" 640 480 "$ROOT/profile/syslinux/splash.png"

echo "assets ready"