# NixOS-Installer

```bash
# FIXME: change to correct one
TARGET_DISK=1
```

```bash
parted "/dev/nvme${TARGET_DISK}n1" -- mklabel gpt
parted "/dev/nvme${TARGET_DISK}n1" -- mkpart ESP fat32 1MB 512MB
parted "/dev/nvme${TARGET_DISK}n1" -- mkpart root ext4 512MB 100%
parted "/dev/nvme${TARGET_DISK}n1" -- set 1 esp on
```

```bash
mkfs.fat -F 32 -n boot "/dev/nvme${TARGET_DISK}n1p1"
mkfs.ext4 -L nixos "/dev/nvme${TARGET_DISK}n1p2"
```

```bash
mount --mkdir "/dev/nvme${TARGET_DISK}n1p2" /mnt
mount --mkdir -o umask=077 "/dev/nvme${TARGET_DISK}n1p1" /mnt/boot
```

```bash
nixos-generate-config --root /mnt
```

```bash
rm /mnt/etc/nixos/configuration.nix
curl -o /mnt/etc/nixos/configuration.nix "https://raw.githubusercontent.com/scorpiofifth/NixOS-Installer/master/configuration.nix"
```

```bash
nixos-install --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org"
```
