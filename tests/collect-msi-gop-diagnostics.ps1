Param(
    [string]$OutDir = "msi-gop-diagnostics-win"
)

$ErrorActionPreference = "Stop"

Write-Host "[*] Creating output directory: $OutDir"
if (Test-Path $OutDir) { Remove-Item -Recurse -Force $OutDir }
New-Item -ItemType Directory -Path $OutDir | Out-Null

Write-Host "[*] Collecting BIOS information"
Get-CimInstance -ClassName Win32_BIOS | Out-File "$OutDir\bios-info.txt"

Write-Host "[*] Collecting GPU information"
Get-CimInstance -ClassName Win32_VideoController | Out-File "$OutDir\gpu-info.txt"

Write-Host "[*] Collecting display configuration"
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams -ErrorAction SilentlyContinue | Out-File "$OutDir\monitor-basic-params.txt"
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorID -ErrorAction SilentlyContinue | Out-File "$OutDir\monitor-id.txt"

Write-Host "[*] Collecting EDID (if available)"
$edidPath = "$OutDir\edid-raw.txt"
try {
    $monitors = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Enum\DISPLAY" -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like "*Device Parameters" }

    foreach ($m in $monitors) {
        $edid = (Get-ItemProperty -Path $m.PSPath -Name "EDID" -ErrorAction SilentlyContinue).EDID
        if ($edid) {
            $hex = ($edid | ForEach-Object { $_.ToString("X2") }) -join " "
            Add-Content -Path $edidPath -Value "Path: $($m.PSPath)"
            Add-Content -Path $edidPath -Value $hex
            Add-Content -Path $edidPath -Value ""
        }
    }
} catch {
    "Failed to read EDID: $_" | Out-File "$OutDir\edid-error.txt"
}

Write-Host "[*] Recording current display modes"
try {
    $modes = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedSupportedSourceModes -ErrorAction SilentlyContinue
    $modes | Out-File "$OutDir\display-modes.txt"
} catch {
    "Failed to query WmiMonitorListedSupportedSourceModes: $_" | Out-File "$OutDir\display-modes-error.txt"
}

Write-Host "[*] Asking user for cable/port information"
$gpuPort = Read-Host "Enter GPU port used (e.g., DP-1, HDMI-1)"
$cableType = Read-Host "Enter cable type (DP/HDMI)"
$monitorInput = Read-Host "Enter monitor input used"

@"
GPU port: $gpuPort
Cable type: $cableType
Monitor input: $monitorInput
"@ | Out-File "$OutDir\cable-port-info.txt"

Write-Host "[*] Creating summary"
@"
MSI GOP Diagnostic Summary (Windows)
====================================

This bundle contains:
- BIOS info
- GPU info
- Monitor info
- EDID (if available)
- Display modes
- Cable/port information

Attach this folder as a ZIP to MSI support.
"@ | Out-File "$OutDir\summary.txt"

Write-Host "[*] Creating ZIP archive"
$zipPath = "$OutDir.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path $OutDir -DestinationPath $zipPath

Write-Host "[*] Done. Attach $zipPath to your MSI ticket."
