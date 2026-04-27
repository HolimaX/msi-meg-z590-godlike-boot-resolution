# MSI Support & Engineering Brief  
**Subject:** UEFI GOP Low‑Resolution Boot Splash on MSI MEG Z590 GODLIKE  
**Status:** Reproducible, firmware‑level issue  
**Required Action:** GOP/BIOS update to expose correct display modes over DisplayPort

---

## Overview

This document summarizes a reproducible firmware issue affecting the  
**MSI MEG Z590 GODLIKE** motherboard (BIOS A.A0) when connected to modern  
high‑resolution monitors such as the **ASUS ProArt PA278GCV (2560×1440)**.

The issue occurs **before the operating system loads**, during the UEFI GOP  
initialization phase. The OS (Fedora, Ubuntu, Windows) cannot influence this  
stage. This repository includes:

- A complete reproduction environment  
- Hardware matrix  
- Cable/port tests  
- GRUB/kernel configuration proving OS‑side correctness  
- Logs and screenshots  
- A structured test suite MSI engineering can run internally  

The goal is to provide MSI with everything needed to diagnose and fix the  
firmware behavior.

---

## Problem Summary

### Observed behavior

- BIOS/UEFI splash appears in **800×600 or 1024×768**, heavily letterboxed.
- This occurs **only** during the firmware GOP stage.
- Once the OS loads, the display switches to **native 2560×1440** immediately.
- GRUB and Linux framebuffer can use 2560×1440 **only if GOP exposes it**.
- DisplayPort is affected; HDMI sometimes exposes more modes.

### Expected behavior

- GOP should expose native or at least aspect‑correct modes over DisplayPort.
- BIOS splash should scale correctly or use a higher resolution.
- Modern monitors should not fall back to 4:3 VESA modes.

---

## Why this is a firmware issue (not OS)

This repository demonstrates:

1. The low‑resolution splash occurs **before** GRUB or the OS loads.  
2. GRUB can use 2560×1440 **when GOP exposes the mode**.  
3. Linux switches to native resolution immediately after GOP handoff.  
4. The same behavior occurs across multiple Linux distributions and Windows.  
5. Cable/port matrix shows the issue is tied to **DisplayPort GOP mode exposure**.

Therefore:

> **The root cause is the GOP implementation in the MSI MEG Z590 GODLIKE firmware.  
> This cannot be fixed by Fedora, GRUB, Linux, or any OS‑level patch.**

---

## Prior Support Interactions

In previous support cases, responsibility was redirected toward the operating  
system. This repository provides clear, reproducible evidence that:

- The OS is functioning correctly.  
- The issue exists entirely within the firmware stage.  
- The OS cannot modify GOP behavior or BIOS splash resolution.  

This documentation is intended to prevent further misattribution and allow MSI  
engineering to focus on the correct subsystem.

---

## What MSI Engineering Can Do

### 1. Update GOP driver in BIOS

- Expose native or aspect‑correct modes (e.g., 2560×1440, 1920×1080).
- Ensure DisplayPort and HDMI receive the same mode list.
- Improve scaling behavior for the full‑screen logo.

### 2. Provide a test BIOS for validation

This repository includes:

- Automated tests (`tests/`)
- Cable/port matrix
- GRUB/kernel configs
- Expected vs actual screenshots
- A reproducible Fedora environment

Engineering can validate fixes quickly using these tools.

---

## What This Repository Provides to MSI

- **Complete reproduction steps**  
- **Hardware and cable matrix**  
- **Before/after GRUB configs**  
- **Framebuffer and DRM mode logs**  
- **Photos of BIOS splash and GRUB**  
- **Automated test scripts**  
- **A structured issue template for MSI feedback**

Everything is organized so MSI can drop in:

- Updated GOP binaries  
- Updated BIOS builds  
- Engineering notes  
- Validation results  

---

## Requested Action from MSI

1. **Acknowledge** that the issue is firmware/GOP‑related.  
2. **Provide an updated BIOS** or **engineering test build** with corrected GOP mode exposure.  
3. **Confirm** whether this issue is known internally.  
4. **Advise** whether similar GOP fixes have been applied to other Z590 boards.  
5. **Communicate** whether a fix is planned for a future BIOS release.

---

## Contact & Ticket Linking

Please reference this repository in all communication so support and engineering  
can access:

- Reproduction steps  
- Logs  
- Test results  
- Hardware details  
- Photos and videos  

This ensures consistent handling and prevents repeated explanations.

---

## Closing Note

This repository is not intended as criticism.  
It is a **technical, reproducible, engineering‑ready** package designed to help  
MSI identify and fix a firmware issue that affects users with modern monitors  
and DisplayPort connections.

We appreciate MSI’s attention and look forward to collaborating on a fix.

