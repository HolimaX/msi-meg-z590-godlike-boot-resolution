# Problem description

## Hardware

- **Motherboard:** MSI MEG Z590 GODLIKE
- **BIOS version:** A.A0 (latest at time of writing)
- **Monitor:** ASUS ProArt PA278GCV (2560×1440)
- **Connection:** DisplayPort (primary), HDMI used for comparison
- **OS:** Fedora 42 (UEFI, no CSM)

## Observed behavior

1. On cold boot, the BIOS/UEFI splash appears in a low resolution
   (approx. 800×600, 4:3) with black borders.
2. Once Fedora’s kernel and Plymouth start, the display switches to
   full native resolution (2560×1440) and looks correct.
3. Changing GRUB and kernel parameters can improve resolution **after**
   firmware handoff, but the BIOS splash remains low-res.

## Key point

The low-resolution splash occurs **before** the OS is loaded and is
driven by the motherboard’s UEFI GOP implementation and how it exposes
modes to the GPU/monitor. This is not something Fedora can patch.
