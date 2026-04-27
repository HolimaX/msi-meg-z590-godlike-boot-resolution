# MSI MEG Z590 GODLIKE – Boot Resolution & BIOS GOP Issue

This repository documents and reproduces a firmware-level boot resolution issue
on the **MSI MEG Z590 GODLIKE** motherboard with modern high-resolution
monitors (e.g. ASUS ProArt PA278GCV, 2560×1440).

## Summary

- BIOS/UEFI splash and GOP output are limited to low resolutions
  (e.g. 800×600 or 1024×768) over DisplayPort.
- Fedora (and other OSes) can switch to native resolution only **after**
  firmware handoff.
- This repository:
  - Provides a **minimal Fedora configuration** that proves the OS is capable
    of native-resolution early boot.
  - Includes **tests and a cable/port matrix** to show the problem is
    firmware/GOP-specific, not OS-specific.
  - Is structured so that **MSI support and engineering** can plug in fixes
    or updated GOP/BIOS information.

## Goals

1. Clearly separate:
   - What the OS can control (GRUB, kernel framebuffer, Plymouth).
   - What only MSI firmware can control (GOP modes, splash scaling).
2. Provide reproducible steps and logs that MSI can use to:
   - Confirm the issue.
   - Validate any future BIOS/GOP fixes.
3. Make vendor responsibility explicit, while remaining technical and
   professional.

## Quick start (Fedora)

See:

- [`docs/reproduction-guide.md`](docs/reproduction-guide.md)
- [`fedora/grub/apply-grub-config.sh`](fedora/grub/apply-grub-config.sh)
- [`tests/test-gop-modes.sh`](tests/test-gop-modes.sh)
