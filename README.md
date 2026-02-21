Custom Mouse DPI

A simple Windows app with a dark UI to manage mouse DPI settings from your system tray.


What it does

Change your mouse DPI on the fly with a clean, dark interface that sits in your system tray.
Features

    Dark theme - Easy on the eyes

    DPI range - 200 to 6400

    Quick presets - 400, 800, 1600, 2400, 3200, 6400 DPI

    Saves your original DPI - Restore anytime

    System tray - Minimize and access quickly

    Slider + manual input - Use whatever you prefer

How to use

    Download CustomMouseDPI.ps1

    Right-click → "Run with PowerShell"

    Choose your DPI and click "APPLY"

    Minimize to tray when done

Controls
Button	What it does
APPLY	Set selected DPI
RESTORE	Go back to original DPI
TRAY	Hide to system tray
System tray

    Right-click icon for quick menu

    Double-click to open window

    Quick access to all presets

Start with Windows

Run this in PowerShell (change the path):
powershell

$startup = [Environment]::GetFolderPath("Startup")
$shortcut = Join-Path $startup "CustomDPI.lnk"
$script = "C:\YourPath\CustomMouseDPI.ps1"

$wshell = New-Object -ComObject WScript.Shell
$link = $wshell.CreateShortcut($shortcut)
$link.TargetPath = "powershell.exe"
$link.Arguments = "-WindowStyle Hidden -File `"$script`""
$link.Save()

Requirements

    Windows 7/8/10/11

    PowerShell (comes with Windows)

Note

This app simulates DPI changes since real mouse DPI is hardware-based. For actual DPI changes, use your mouse manufacturer's software 
Made with PowerShell • Dark theme • Simple & clean
