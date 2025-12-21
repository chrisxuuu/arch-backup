#!/bin/bash

echo "Updating backup..."

# Update package lists
pacman -Qqe > pkglist.txt
pacman -Qqem > aurlist.txt

# Update configs
cp -r ~/.config/hypr configs/ 2>/dev/null
cp -r ~/.config/waybar configs/ 2>/dev/null
cp -r ~/.config/rofi configs/ 2>/dev/null
cp -r ~/.config/nvim configs/ 2>/dev/null
cp ~/.bashrc configs/ 2>/dev/null
cp ~/.zshrc configs/ 2>/dev/null
cp ~/.gitconfig configs/ 2>/dev/null

# Update system configs
sudo cp /etc/fstab system-configs/ 2>/dev/null
sudo cp /etc/mkinitcpio.conf system-configs/ 2>/dev/null
sudo cp -r /etc/modprobe.d system-configs/ 2>/dev/null
sudo chown -R $USER:$USER system-configs/

# Update README date
sed -i "s/Last updated:.*/Last updated: $(date)/" README.md

# Git commit and push
git add .
git commit -m "Backup update $(date +%Y-%m-%d)"
git push

echo "✓ Backup updated and pushed to GitHub"
