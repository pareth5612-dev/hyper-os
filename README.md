# Hyper OS

A lightning-fast, Arch-based desktop that works the minute it boots.
Hyprland, curated configuration and a real installer — no assembly required.

## What you get

- **Hyprland** with Ilyas Miro's [imperative-dots](https://github.com/ilyamiro/imperative-dots)
  pre-installed for every new user (shell, kitty, neovim, quickshell, matugen,
  cava — the whole config set).
- **A real installer.** Graphical (Calamares) and manual/CLI modes on the same
  live medium. Installation happens offline: the live system is copied onto the
  target disk, then a normal GRUB boot is set up.
- **GPU detection at install time.** The installer detects nvidia/amd/intel and
  writes the correct d3d backend environment; optional driver install is offered
  on first boot (`hyper-setup`).
- **Software profiles.** Pick Standard/Gaming/Development with `hyper-setup`
  (installed prompts on first boot). Packages come from the official repos,
  nothing is locked in. The installer stays lean and fully offline.
- **First-boot wizard** (`hyper-firstboot`) that asks once whether you want the
  optional bits finished off, then gets out of the way.
- **`hyper-switch`** to swap wallpaper and theme, **`hyper-fetch`** for the
  fastfetch branding, and `paru` + `opencode` ship in the box.
- Every Arch logo replaced by the bolt. Search the image for "Arch" and you'll
  only find the system name underneath.

## Building the ISO

```sh
./scripts/make-assets.sh     # SVG branding -> PNG/JPEG assets
./scripts/get-dotfiles.sh    # clone imperative-dots into /etc/skel
./scripts/stage-aur.sh       # build calamares/paru/quickshell/matugen from the AUR
                              # into localrepo/ (takes a while, network required)
sudo mkarchiso -w work -o out profile
# or just:
./build.sh
```

Run the result:

```sh
run_archiso -i out/hyper-os-*.iso
```

## Using the live medium

- Boot → SDDM → live user `hyper` / `hyper`. Calamares auto-starts; decline it
  if you only want to poke around.
- CLI install: `hyper-manual` from any tty.
- Don't care about the wizard? Install straight from the terminal with
  `archinstall`; the manifest is intentionally slim so nothing goes stale.

## Project layout

```
branding/            vector source art (bolt + splash + wallpapers)
profile/             archiso profile — the whole OS
  profiledef.sh      image metadata + file permissions
  pacman.conf        build-time pacman + [hyper] local repo
  packages.x86_64    the package set (ISO == installed base)
  syslinux/          BIOS boot configuration
  grub/              live GRUB/loopback menu
  airootfs/          the live root filesystem, copied verbatim at install
    etc/calamares/   installer settings + branding
    usr/share/calamares/modules/  hypergpu, hyperpresets, hyperprep jobs
    usr/share/hyper/ presets, wallpapers, fastfetch config
scripts/             make-assets, get-dotfiles, stage-aur
```

## Notes for contributors

- The installed system is literally the live rootfs (via `unpackfs`), so
  **anything baked into `airootfs` ends up on disk**. Live-only pieces are
  either guarded by `/run/archiso` (`hyper-live-setup`, `hyper-install-launcher`)
  or removed by the `hyperprep` install job.
- Presets in `usr/share/hyper/presets/*.pkgs` are plain package lists consumed
  by `hyper-setup`. Add one and it shows up in the installer automatically.
- Bootloaders on the media: syslinux (BIOS) and systemd-boot (UEFI). Installed
  systems get GRUB with the bolt theme under
  `/usr/share/grub/themes/hyper-os/`.