# Reproduction guide

## 1. BIOS settings

- **CSM / Legacy boot:** Disabled
- **Boot mode:** UEFI only
- **Full screen logo:** Enabled
- **Primary display:** Set to the active GPU (PEG or iGPU as applicable)

## 2. Fedora GRUB configuration

Use the provided `fedora/grub/grub-default-after` as `/etc/default/grub`:

```bash
sudo cp fedora/grub/grub-default-after /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
sudo dracut -f
