#!/usr/bin/env python3
import os
import platform
import subprocess
import shutil
from datetime import datetime

OUTDIR = "msi-gop-diagnostics-py"


def run(cmd, outfile, shell=False):
    try:
        with open(outfile, "w", encoding="utf-8", errors="ignore") as f:
            f.write(f"# Command: {cmd}\n\n")
            result = subprocess.run(
                cmd,
                shell=shell,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
            )
            f.write(result.stdout)
    except Exception as e:
        with open(outfile, "w") as f:
            f.write(f"Failed to run {cmd}: {e}\n")


def main():
    if os.path.exists(OUTDIR):
        shutil.rmtree(OUTDIR)
    os.makedirs(OUTDIR, exist_ok=True)

    with open(os.path.join(OUTDIR, "system-info.txt"), "w") as f:
        f.write(f"Platform: {platform.platform()}\n")
        f.write(f"System: {platform.system()}\n")
        f.write(f"Release: {platform.release()}\n")
        f.write(f"Date: {datetime.utcnow().isoformat()}Z\n")

    system = platform.system().lower()

    if system == "linux":
        run(["dmidecode", "-t", "bios"], os.path.join(OUTDIR, "bios-info.txt"))
        run(["fbset", "-i"], os.path.join(OUTDIR, "fbset-info.txt"))
        run(["modetest", "-c"], os.path.join(OUTDIR, "drm-connectors.txt"))
        run(["modetest", "-p"], os.path.join(OUTDIR, "drm-planes.txt"))
        run(["cat", "/proc/cmdline"], os.path.join(OUTDIR, "kernel-cmdline.txt"))
        if os.path.exists("/etc/default/grub"):
            shutil.copy("/etc/default/grub", os.path.join(OUTDIR, "grub-default.txt"))
        if os.path.exists("/boot/efi/EFI/fedora/grub.cfg"):
            shutil.copy("/boot/efi/EFI/fedora/grub.cfg", os.path.join(OUTDIR, "grub.cfg"))

        edid_dir = os.path.join(OUTDIR, "edid")
        os.makedirs(edid_dir, exist_ok=True)
        drm_path = "/sys/class/drm"
        if os.path.isdir(drm_path):
            for entry in os.listdir(drm_path):
                edid_path = os.path.join(drm_path, entry, "edid")
                if os.path.isfile(edid_path):
                    try:
                        with open(edid_path, "rb") as src, open(
                            os.path.join(edid_dir, f"edid-{entry}.bin"), "wb"
                        ) as dst:
                            dst.write(src.read())
                    except Exception:
                        pass

    elif system == "windows":
        run(["powershell", "-Command", "Get-CimInstance Win32_BIOS"], os.path.join(OUTDIR, "bios-info.txt"))
        run(["powershell", "-Command", "Get-CimInstance Win32_VideoController"], os.path.join(OUTDIR, "gpu-info.txt"))
        run(
            [
                "powershell",
                "-Command",
                "Get-CimInstance -Namespace root\\wmi -ClassName WmiMonitorBasicDisplayParams"
            ],
            os.path.join(OUTDIR, "monitor-basic-params.txt"),
        )

    gpu_port = input("Enter GPU port used (e.g., DP-1, HDMI-1): ")
    cable_type = input("Enter cable type (DP/HDMI): ")
    monitor_input = input("Enter monitor input used: ")

    with open(os.path.join(OUTDIR, "cable-port-info.txt"), "w") as f:
        f.write(f"GPU port: {gpu_port}\n")
        f.write(f"Cable type: {cable_type}\n")
        f.write(f"Monitor input: {monitor_input}\n")

    with open(os.path.join(OUTDIR, "summary.txt"), "w") as f:
        f.write(
            "MSI GOP Diagnostic Summary (Python)\n"
            "===================================\n\n"
            "Collected system, BIOS, display, and cable/port information.\n"
            "Attach this folder as an archive to MSI support.\n"
        )

    archive = shutil.make_archive(OUTDIR, "gztar", OUTDIR)
    print(f"[*] Done. Attach {archive} to your MSI ticket.")


if __name__ == "__main__":
    main()
