#!/usr/bin/env bash
set -euo pipefail

echo "[*] Checking GRUB gfx settings in /etc/default/grub"
grep -E 'GRUB_GFXMODE|GRUB_GFXPAYLOAD_LINUX|GRUB_TERMINAL_OUTPUT' /etc/default/grub || {
  echo "Missing expected GRUB gfx settings."
  exit 1
}

echo "[*] Verifying GRUB config file exists"
if [ -f /boot/efi/EFI/fedora/grub.cfg ]; then
  echo "Found /boot/efi/EFI/fedora/grub.cfg"
else
  echo "grub.cfg not found at expected path."
  exit 1
fi

echo "[*] Manual step: reboot and confirm GRUB menu is full-screen at 2560×1440."
