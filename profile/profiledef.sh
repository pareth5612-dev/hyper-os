#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="hyper-os"
iso_label="HYPER_OS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Hyper OS"
iso_application="Hyper OS Live/Install DVD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="hyper"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/usr/local/bin/hyper-session"]="0:0:755"
  ["/usr/local/bin/hyper-live-setup"]="0:0:755"
  ["/usr/local/bin/hyper-gpu-detect"]="0:0:755"
  ["/usr/local/bin/hyper-firstboot"]="0:0:755"
  ["/usr/local/bin/hyper-setup"]="0:0:755"
  ["/usr/local/bin/hyper-switch"]="0:0:755"
  ["/usr/local/bin/hyper-fetch"]="0:0:755"
  ["/usr/local/bin/hyper-manual"]="0:0:755"
  ["/usr/local/bin/hyper-install-launcher"]="0:0:755"
)
