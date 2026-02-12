# Installer

```bash
TARGET_DISK="/dev/nvme1n1" #WARN: change to correct one

parted "${TARGET_DISK}" -- mklabel gpt
parted "${TARGET_DISK}" -- mkpart ESP fat32 1MB 512MB
parted "${TARGET_DISK}" -- mkpart root ext4 512MB 100%
parted "${TARGET_DISK}" -- set 1 esp on

mkfs.fat -F 32 -n boot "${TARGET_DISK}p1"
mkfs.ext4 -L nixos "${TARGET_DISK}p2"

mount --mkdir  "${TARGET_DISK}p2" /mnt
mount --mkdir -o umask=077 "${TARGET_DISK}p1" /mnt/boot

nixos-generate-config --root /mnt

rm /mnt/etc/nixos/configuration.nix
curl -o /mnt/etc/nixos/configuration.nix "https://github.com/scorpiofifth/NixOS-Installer/raw/refs/heads/master/configuration.nix"

nixos-install --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org"
```
