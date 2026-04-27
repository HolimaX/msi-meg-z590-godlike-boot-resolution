#!/usr/bin/env bash
set -euo pipefail

echo "[*] Rebuilding initramfs so Plymouth picks up new resolution"
sudo dracut -f
echo "[*] Done."
