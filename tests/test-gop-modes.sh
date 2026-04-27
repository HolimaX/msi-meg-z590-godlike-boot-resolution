#!/usr/bin/env bash
set -euo pipefail

echo "[*] Listing available framebuffer modes from the kernel (post-boot)"
if command -v fbset >/dev/null 2>&1; then
  fbset -i || true
else
  echo "fbset not installed; install with: sudo dnf install fbset"
fi

echo
echo "[*] Listing DRM modes (requires root)"
if command -v modetest >/dev/null 2>&1; then
  sudo modetest -c || true
else
  echo "modetest not installed; install with: sudo dnf install libdrm-tests"
fi

echo
echo "[*] Note: These modes are available after firmware handoff."
echo "The BIOS splash resolution is determined earlier by GOP."
