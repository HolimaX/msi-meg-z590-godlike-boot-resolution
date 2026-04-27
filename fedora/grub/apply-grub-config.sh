#!/usr/bin/env bash
set -euo pipefail

echo "[*] Backing up current /etc/default/grub to /etc/default/grub.bak"
sudo cp /etc/default/grub /etc/default/grub.bak

echo "[*] Applying new GRUB config from fedora/grub/grub-default-after"
sudo cp "$(dirname "$0")/grub-default-after" /etc/default/grub

echo "[*] Regenerating GRUB configuration"
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

echo "[*] Rebuilding initramfs for Plymouth"
sudo dracut -f

echo "[*] Done. Please reboot and observe boot resolution behavior."
