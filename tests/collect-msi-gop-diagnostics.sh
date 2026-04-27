#!/usr/bin/env bash
set -euo pipefail

OUTDIR="msi-gop-diagnostics"
ARCHIVE="${OUTDIR}.tar.gz"

echo "[*] Creating output directory: $OUTDIR"
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

echo "[*] Collecting BIOS information"
sudo dmidecode -t bios > "$OUTDIR/bios-info.txt" 2>/dev/null || true

echo "[*] Collecting kernel framebuffer info"
if command -v fbset >/dev/null; then
    fbset -i > "$OUTDIR/fbset-info.txt" 2>&1 || true
else
    echo "fbset not installed" > "$OUTDIR/fbset-info.txt"
fi

echo "[*] Collecting DRM mode information"
if command -v modetest >/dev/null; then
    sudo modetest -c > "$OUTDIR/drm-connectors.txt" 2>&1 || true
    sudo modetest -p > "$OUTDIR/drm-planes.txt" 2>&1 || true
else
    echo "modetest not installed" > "$OUTDIR/drm-info.txt"
fi

echo "[*] Dumping EDID (if available)"
for edid in /sys/class/drm/*/edid; do
    name=$(echo "$edid" | sed 's/.*drm\///; s/\/edid//')
    sudo cat "$edid" > "$OUTDIR/edid-${name}.bin" 2>/dev/null || true
done

echo "[*] Collecting GRUB configuration"
cp /etc/default/grub "$OUTDIR/grub-default.txt" 2>/dev/null || true
cp /boot/efi/EFI/fedora/grub.cfg "$OUTDIR/grub.cfg" 2>/dev/null || true

echo "[*] Recording kernel command line"
cat /proc/cmdline > "$OUTDIR/kernel-cmdline.txt"

echo "[*] Asking user for cable/port information"
read -rp "Enter GPU port used (e.g., DP-1, HDMI-1): " gpu_port
read -rp "Enter cable type (DP/HDMI): " cable_type
read -rp "Enter monitor input used: " monitor_input

cat <<EOF > "$OUTDIR/cable-port-info.txt"
GPU port: $gpu_port
Cable type: $cable_type
Monitor input: $monitor_input
EOF

echo "[*] Creating summary report"
cat <<EOF > "$OUTDIR/summary.txt"
MSI GOP Diagnostic Summary
==========================

BIOS splash resolution issue on MSI MEG Z590 GODLIKE.

Collected:
- BIOS info
- Framebuffer modes
- DRM modes
- EDID dumps
- GRUB configuration
- Kernel command line
- Cable/port information

This bundle is ready for MSI support.
EOF

echo "[*] Packaging results into $ARCHIVE"
tar -czf "$ARCHIVE" "$OUTDIR"

echo "[*] Done."
echo "Attach $ARCHIVE to your GitHub issue or MSI support ticket."
