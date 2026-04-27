
---

### `docs/expected-behavior.md`

```markdown
# Expected behavior

On a modern high-resolution monitor:

- BIOS/UEFI splash should either:
  - Use the monitor's native resolution, or
  - Scale appropriately without large black borders.
- GOP should expose higher-resolution modes (e.g. 2560×1440) to the OS
  bootloader over DisplayPort, not only low-res 4:3 modes.

Fedora demonstrates that, once GOP provides suitable modes, the OS can
use native resolution reliably during early boot.
