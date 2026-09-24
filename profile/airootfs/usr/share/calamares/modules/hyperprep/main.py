import os
import shutil

import libcalamares

# The live rootfs ships no kernel under /boot (mkarchiso strips it to save
# space); mkinitcpio in the install chroot needs /boot/vmlinuz-linux, so copy
# it from the live medium before the initcpio module runs.
KERNEL_SRC = "/run/archiso/bootmnt/hyper/boot/x86_64/vmlinuz-linux"

# Live-environment files that must not carry over into the installed system.
LIVE_FILES = [
    "etc/mkinitcpio.conf.d/archiso.conf",
    "etc/systemd/system/getty@tty1.service.d/autologin.conf",
    "etc/systemd/system/hyper-live-setup.service",
    "etc/systemd/system/multi-user.target.wants/hyper-live-setup.service",
    "etc/pacman.d/hooks/uncomment-mirrors.hook",
    "etc/pacman.d/hooks/zzzz99-remove-custom-hooks-from-airootfs.hook",
    "etc/sddm.conf.d/10-live-autologin.conf",
    "root/.zlogin",
    "root/.automated_script.sh",
]

# Directories that only existed to carry live-only files; remove if empty.
LIVE_DIRS = [
    "etc/systemd/system/getty@tty1.service.d",
    "etc/mkinitcpio.conf.d",
    "etc/pacman.d/hooks",
]

MKINITCPIO_PRESET = """\
# mkinitcpio preset file for the 'linux' package

ALL_kver='/boot/vmlinuz-linux'

PRESETS=('default' 'fallback')

default_image='/boot/initramfs-linux.img'
default_options=''

fallback_image='/boot/initramfs-linux-fallback.img'
fallback_options='-S autodetect'
"""


def _path(root, rel):
    return os.path.join(root, rel)


def _copy_kernel(root):
    src = KERNEL_SRC
    if not os.path.isfile(src):
        libcalamares.utils.warning(
            "hyperprep: kernel source %s not found (not on the live medium?)" % src
        )
        return
    boot_dir = _path(root, "boot")
    try:
        os.makedirs(boot_dir, exist_ok=True)
        shutil.copy2(src, os.path.join(boot_dir, "vmlinuz-linux"))
        libcalamares.utils.debug("hyperprep: copied %s -> %s/vmlinuz-linux" % (src, boot_dir))
    except Exception as exc:  # pragma: no cover
        libcalamares.utils.warning("hyperprep: could not copy kernel: %s" % exc)


def run():
    root = libcalamares.globalstorage.value("rootMountPoint") or ""

    _copy_kernel(root)

    for rel in LIVE_FILES:
        path = _path(root, rel)
        try:
            os.remove(path)
            libcalamares.utils.debug("hyperprep: removed %s" % rel)
        except FileNotFoundError:
            pass
        except Exception as exc:  # pragma: no cover
            libcalamares.utils.warning("hyperprep: could not remove %s: %s" % (rel, exc))

    for rel in LIVE_DIRS:
        path = _path(root, rel)
        try:
            if not os.listdir(path):
                os.rmdir(path)
                libcalamares.utils.debug("hyperprep: removed %s/" % rel)
        except FileNotFoundError:
            pass
        except Exception as exc:  # pragma: no cover
            libcalamares.utils.warning("hyperprep: could not remove %s/: %s" % (rel, exc))

    preset = _path(root, "etc/mkinitcpio.d/linux.preset")
    try:
        with open(preset, "w") as handle:
            handle.write(MKINITCPIO_PRESET)
        libcalamares.utils.debug("hyperprep: reset linux.preset to default/fallback")
    except Exception as exc:  # pragma: no cover
        libcalamares.utils.warning("hyperprep: could not write linux.preset: %s" % exc)

    return None