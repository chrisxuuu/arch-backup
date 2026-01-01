# Arch Linux Backup

## Contents

- `pkglist.txt` - Official repository packages
- `aurlist.txt` - AUR packages
- `configs/` - User configuration files
  - hypr/ - Hyprland config
  - waybar/ - Waybar config
  - rofi/ - Rofi config
  - And more...
- `system-configs/` - System-wide configurations
- `restore.sh` - Restoration script

## Restore on Fresh Arch Install

```bash
# Clone this repo
git clone git@github.com:chrisxuuu/arch-backup.git
cd arch-backup

# Run the restore script
chmod +x restore.sh
./restore.sh
```

## Manual Restore

```bash
# Install packages
sudo pacman -S --needed - < pkglist.txt
yay -S --needed - < aurlist.txt

# Restore user configs
cp -r configs/* ~/.config/

# Restore system configs (requires sudo)
sudo cp system-configs/fstab /etc/
sudo cp system-configs/mkinitcpio.conf /etc/
sudo cp -r system-configs/modprobe.d /etc/

# Rebuild initramfs and update bootloader
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Regular Backups

Run `./backup.sh` to update this backup.

Last updated: Wed Dec 31 06:50:29 PM PST 2025
