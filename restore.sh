#!/bin/bash

echo "=== Restoring Arch Linux Configuration ==="
echo ""

# Install packages
echo "Installing packages from official repos..."
sudo pacman -S --needed - < pkglist.txt

echo ""
echo "Installing AUR packages..."
if command -v yay &> /dev/null; then
    yay -S --needed - < aurlist.txt
elif command -v paru &> /dev/null; then
    paru -S --needed - < aurlist.txt
else
    echo "Warning: No AUR helper found. Install yay or paru first."
    echo "  yay: git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
fi

# Restore user configs
echo ""
echo "Restoring user configs..."
cp -r configs/hypr ~/.config/ 2>/dev/null
cp -r configs/waybar ~/.config/ 2>/dev/null
cp -r configs/rofi ~/.config/ 2>/dev/null
cp -r configs/nvim ~/.config/ 2>/dev/null
cp configs/.bashrc ~/ 2>/dev/null
cp configs/.zshrc ~/ 2>/dev/null
cp configs/.gitconfig ~/ 2>/dev/null

# Restore system configs
echo ""
echo "Restoring system configs (requires sudo)..."
sudo cp system-configs/fstab /etc/ 2>/dev/null
sudo cp system-configs/mkinitcpio.conf /etc/ 2>/dev/null
sudo cp -r system-configs/modprobe.d /etc/ 2>/dev/null
sudo cp -r system-configs/default /etc/ 2>/dev/null

echo ""
echo "✓ Restoration complete!"
echo ""
echo "Next steps:"
echo "  1. Enable services: sudo systemctl enable ly nvidia-suspend.service"
echo "  2. Rebuild initramfs: sudo mkinitcpio -P"
echo "  3. Update bootloader: sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo "  4. Reboot"
