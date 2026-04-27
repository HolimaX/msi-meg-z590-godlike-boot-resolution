# Vendor responsibility notes

This repository is intentionally structured so that MSI support and
engineering can:

- See that:
  - The OS (Fedora) is configured correctly.
  - Native-resolution early boot works as soon as firmware hands off.
- Focus on:
  - GOP mode exposure over DisplayPort.
  - BIOS splash scaling and resolution.

## Prior support experience

In previous support interactions, responsibility for this issue was
implicitly or explicitly shifted toward the operating system or
distribution. The data and tests here show:

- The low-resolution splash occurs **before** the OS is loaded.
- Fedora can and does use native resolution once GOP allows it.
- Therefore, the root cause lies in firmware/GOP behavior, not Fedora.

The goal is not to assign blame, but to make it clear that a durable
fix requires **MSI firmware changes**, not OS workarounds.
