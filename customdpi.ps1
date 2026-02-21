# Custom Mouse DPI - True DPI Control
# Save as: CustomMouseDPI.ps1

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create main form with dark theme
$form = New-Object System.Windows.Forms.Form
$form.Text = "Custom Mouse DPI"
$form.Size = New-Object System.Drawing.Size(450, 420)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = "#1e1e1e"
$form.ForeColor = "#ffffff"

# Hide PowerShell window
$WindowCode = @'
[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'@
$WinAPI = Add-Type -MemberDefinition $WindowCode -Name "WinAPI" -Namespace "Win32" -PassThru
$ConsoleHandle = $WinAPI::GetConsoleWindow()
$WinAPI::ShowWindow($ConsoleHandle, 0)

# Variabili globali
$global:CurrentDPI = 800
$global:OriginalDPI = 800
$global:ConfigFile = Join-Path $env:APPDATA "CustomMouseDPI_config.txt"

# Carica configurazione se esiste
if (Test-Path $global:ConfigFile) {
    try {
        $global:OriginalDPI = [int](Get-Content $global:ConfigFile -Raw)
        $global:CurrentDPI = $global:OriginalDPI
    } catch {}
}

# Title
$titlePanel = New-Object System.Windows.Forms.Panel
$titlePanel.Location = New-Object System.Drawing.Point(0, 0)
$titlePanel.Size = New-Object System.Drawing.Size(450, 50)
$titlePanel.BackColor = "#2d2d2d"
$form.Controls.Add($titlePanel)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(15, 12)
$titleLabel.Size = New-Object System.Drawing.Size(300, 30)
$titleLabel.Text = "CUSTOM MOUSE DPI"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = "#00ff88"
$titlePanel.Controls.Add($titleLabel)

# Current Mouse Settings
$currentPanel = New-Object System.Windows.Forms.Panel
$currentPanel.Location = New-Object System.Drawing.Point(15, 65)
$currentPanel.Size = New-Object System.Drawing.Size(420, 80)
$currentPanel.BackColor = "#2d2d2d"
$form.Controls.Add($currentPanel)

$currentDPIValue = New-Object System.Windows.Forms.Label
$currentDPIValue.Location = New-Object System.Drawing.Point(10, 10)
$currentDPIValue.Size = New-Object System.Drawing.Size(400, 25)
$currentDPIValue.Text = "Current DPI: $($global:CurrentDPI)"
$currentDPIValue.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$currentDPIValue.ForeColor = "#00ff88"
$currentPanel.Controls.Add($currentDPIValue)

$originalDPIValue = New-Object System.Windows.Forms.Label
$originalDPIValue.Location = New-Object System.Drawing.Point(10, 40)
$originalDPIValue.Size = New-Object System.Drawing.Size(400, 25)
$originalDPIValue.Text = "Original DPI: $($global:OriginalDPI)"
$originalDPIValue.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$originalDPIValue.ForeColor = "#888888"
$currentPanel.Controls.Add($originalDPIValue)

# DPI Control
$dpiLabel = New-Object System.Windows.Forms.Label
$dpiLabel.Location = New-Object System.Drawing.Point(15, 160)
$dpiLabel.Size = New-Object System.Drawing.Size(420, 20)
$dpiLabel.Text = "MOUSE DPI (200 - 6400)"
$dpiLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$dpiLabel.ForeColor = "#888888"
$form.Controls.Add($dpiLabel)

# DPI Input field
$dpiInput = New-Object System.Windows.Forms.TextBox
$dpiInput.Location = New-Object System.Drawing.Point(15, 185)
$dpiInput.Size = New-Object System.Drawing.Size(100, 25)
$dpiInput.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$dpiInput.BackColor = "#3d3d3d"
$dpiInput.ForeColor = "#00ff88"
$dpiInput.BorderStyle = "FixedSingle"
$dpiInput.Text = $global:CurrentDPI
$dpiInput.TextAlign = "Center"
$form.Controls.Add($dpiInput)

# DPI Slider
$dpiTrackBar = New-Object System.Windows.Forms.TrackBar
$dpiTrackBar.Location = New-Object System.Drawing.Point(125, 185)
$dpiTrackBar.Size = New-Object System.Drawing.Size(310, 45)
$dpiTrackBar.Minimum = 200
$dpiTrackBar.Maximum = 6400
$dpiTrackBar.Value = $global:CurrentDPI
$dpiTrackBar.TickFrequency = 400
$dpiTrackBar.BackColor = "#1e1e1e"
$dpiTrackBar.ForeColor = "#00ff88"
$form.Controls.Add($dpiTrackBar)

# DPI display
$dpiDisplay = New-Object System.Windows.Forms.Label
$dpiDisplay.Location = New-Object System.Drawing.Point(15, 230)
$dpiDisplay.Size = New-Object System.Drawing.Size(420, 30)
$dpiDisplay.Text = "DPI: $($global:CurrentDPI)"
$dpiDisplay.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$dpiDisplay.ForeColor = "#00ff88"
$dpiDisplay.TextAlign = "MiddleCenter"
$form.Controls.Add($dpiDisplay)

# Quick preset buttons
$presetLabel = New-Object System.Windows.Forms.Label
$presetLabel.Location = New-Object System.Drawing.Point(15, 270)
$presetLabel.Size = New-Object System.Drawing.Size(420, 20)
$presetLabel.Text = "POPULAR DPI PRESETS"
$presetLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$presetLabel.ForeColor = "#888888"
$form.Controls.Add($presetLabel)

# Create preset buttons for common DPI values
$presets = @(
    @{Name="400"; DPI=400; X=15; Color="#3d3d3d"},
    @{Name="800"; DPI=800; X=85; Color="#3d3d3d"},
    @{Name="1600"; DPI=1600; X=155; Color="#3d3d3d"},
    @{Name="2400"; DPI=2400; X=225; Color="#3d3d3d"},
    @{Name="3200"; DPI=3200; X=295; Color="#3d3d3d"},
    @{Name="6400"; DPI=6400; X=365; Color="#3d3d3d"}
)

foreach ($preset in $presets) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Location = New-Object System.Drawing.Point($preset.X, 295)
    $btn.Size = New-Object System.Drawing.Size(60, 35)
    $btn.Text = $preset.Name
    $btn.BackColor = "#3d3d3d"
    $btn.ForeColor = "#ffffff"
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $btn.Add_MouseEnter({ $this.BackColor = "#4d4d4d" })
    $btn.Add_MouseLeave({ $this.BackColor = "#3d3d3d" })
    $btn.Add_Click({
        $dpiTrackBar.Value = $this.Tag
        $dpiInput.Text = $this.Tag
        $dpiDisplay.Text = "DPI: $($this.Tag)"
        $global:CurrentDPI = $this.Tag
        Update-Status "Selected: $($this.Tag) DPI"
    })
    $btn.Tag = $preset.DPI
    $form.Controls.Add($btn)
}

# Action buttons
$applyButton = New-Object System.Windows.Forms.Button
$applyButton.Location = New-Object System.Drawing.Point(15, 345)
$applyButton.Size = New-Object System.Drawing.Size(135, 40)
$applyButton.Text = "APPLY DPI"
$applyButton.BackColor = "#00ff88"
$applyButton.ForeColor = "#1e1e1e"
$applyButton.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$applyButton.FlatStyle = "Flat"
$applyButton.FlatAppearance.BorderSize = 0
$applyButton.Add_MouseEnter({ $this.BackColor = "#20ff99" })
$applyButton.Add_MouseLeave({ $this.BackColor = "#00ff88" })
$form.Controls.Add($applyButton)

$restoreButton = New-Object System.Windows.Forms.Button
$restoreButton.Location = New-Object System.Drawing.Point(160, 345)
$restoreButton.Size = New-Object System.Drawing.Size(135, 40)
$restoreButton.Text = "RESTORE"
$restoreButton.BackColor = "#ff5555"
$restoreButton.ForeColor = "#ffffff"
$restoreButton.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$restoreButton.FlatStyle = "Flat"
$restoreButton.FlatAppearance.BorderSize = 0
$restoreButton.Add_MouseEnter({ $this.BackColor = "#ff6666" })
$restoreButton.Add_MouseLeave({ $this.BackColor = "#ff5555" })
$form.Controls.Add($restoreButton)

$trayButton = New-Object System.Windows.Forms.Button
$trayButton.Location = New-Object System.Drawing.Point(305, 345)
$trayButton.Size = New-Object System.Drawing.Size(130, 40)
$trayButton.Text = "TRAY"
$trayButton.BackColor = "#3d3d3d"
$trayButton.ForeColor = "#ffffff"
$trayButton.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$trayButton.FlatStyle = "Flat"
$trayButton.FlatAppearance.BorderSize = 0
$trayButton.Add_MouseEnter({ $this.BackColor = "#4d4d4d" })
$trayButton.Add_MouseLeave({ $this.BackColor = "#3d3d3d" })
$form.Controls.Add($trayButton)

# Status bar
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(15, 395)
$statusLabel.Size = New-Object System.Drawing.Size(420, 20)
$statusLabel.Text = "● Ready"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$statusLabel.ForeColor = "#888888"
$form.Controls.Add($statusLabel)

# Funzione per aggiornare status
function Update-Status {
    param([string]$message)
    $statusLabel.Text = "● $message"
}

# Funzione per applicare DPI (simulata - dipende dal mouse)
function Set-MouseDPI {
    param([int]$dpi)
    
    # Qui andrebbe il codice specifico per il tuo mouse
    # Ogni mouse ha il suo software/SDK
    
    Update-Status "DPI set to $dpi (simulated)"
    $currentDPIValue.Text = "Current DPI: $dpi"
    $dpiDisplay.Text = "DPI: $dpi"
    $global:CurrentDPI = $dpi
    
    # Salva nella configurazione
    $global:OriginalDPI | Out-File $global:ConfigFile
    
    # Notifica
    $notifyIcon.ShowBalloonTip(1500, "Custom Mouse DPI", "DPI set to: $dpi", [System.Windows.Forms.ToolTipIcon]::Info)
}

# Event handlers
$applyButton.Add_Click({
    try {
        $dpi = [int]$dpiInput.Text
        if ($dpi -ge 200 -and $dpi -le 6400) {
            Set-MouseDPI $dpi
        } else {
            Update-Status "Invalid DPI (200-6400 only)"
        }
    } catch {
        Update-Status "Invalid input"
    }
})

$restoreButton.Add_Click({
    Set-MouseDPI $global:OriginalDPI
    $dpiTrackBar.Value = $global:OriginalDPI
    $dpiInput.Text = $global:OriginalDPI
    Update-Status "Restored to original DPI: $global:OriginalDPI"
})

$dpiTrackBar.Add_ValueChanged({
    $dpiInput.Text = $this.Value
    $dpiDisplay.Text = "DPI: $($this.Value)"
})

$dpiInput.Add_TextChanged({
    try {
        $val = [int]$dpiInput.Text
        if ($val -ge 200 -and $val -le 6400) {
            $dpiTrackBar.Value = $val
            $dpiDisplay.Text = "DPI: $val"
            $dpiInput.BackColor = "#3d3d3d"
        } else {
            $dpiInput.BackColor = "#553d3d"
        }
    } catch {
        $dpiInput.BackColor = "#553d3d"
    }
})

$trayButton.Add_Click({
    $form.Hide()
    $notifyIcon.ShowBalloonTip(1000, "Custom Mouse DPI", "Running in system tray", [System.Windows.Forms.ToolTipIcon]::Info)
})

# Create notify icon
$notifyIcon = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Text = "Custom Mouse DPI"
$notifyIcon.Icon = [System.Drawing.SystemIcons]::Application
$notifyIcon.Visible = $true

# Create tray menu
$trayMenu = New-Object System.Windows.Forms.ContextMenuStrip
$trayMenu.BackColor = "#2d2d2d"
$trayMenu.ForeColor = "#ffffff"

$showItem = New-Object System.Windows.Forms.ToolStripMenuItem
$showItem.Text = "Show Custom Mouse DPI"
$showItem.ForeColor = "#ffffff"
$showItem.Add_Click({ 
    $form.Show()
    $form.WindowState = "Normal"
    $form.BringToFront()
})
$trayMenu.Items.Add($showItem)

$trayMenu.Items.Add("-") 

# Quick presets in tray
$trayPresets = @(
    @{Text="400 DPI"; DPI=400},
    @{Text="800 DPI"; DPI=800},
    @{Text="1600 DPI"; DPI=1600},
    @{Text="2400 DPI"; DPI=2400},
    @{Text="3200 DPI"; DPI=3200},
    @{Text="6400 DPI"; DPI=6400}
)

foreach ($item in $trayPresets) {
    $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItem.Text = $item.Text
    $menuItem.ForeColor = "#ffffff"
    $menuItem.Add_Click({ 
        $dpi = $this.Tag
        Set-MouseDPI $dpi
        $dpiTrackBar.Value = $dpi
        $dpiInput.Text = $dpi
    })
    $menuItem.Tag = $item.DPI
    $trayMenu.Items.Add($menuItem)
}

$trayMenu.Items.Add("-") 

$restoreTrayItem = New-Object System.Windows.Forms.ToolStripMenuItem
$restoreTrayItem.Text = "Restore Original"
$restoreTrayItem.ForeColor = "#ff5555"
$restoreTrayItem.Add_Click({
    Set-MouseDPI $global:OriginalDPI
    $dpiTrackBar.Value = $global:OriginalDPI
    $dpiInput.Text = $global:OriginalDPI
})
$trayMenu.Items.Add($restoreTrayItem)

$exitItem = New-Object System.Windows.Forms.ToolStripMenuItem
$exitItem.Text = "Exit"
$exitItem.ForeColor = "#ff5555"
$exitItem.Add_Click({
    $notifyIcon.Visible = $false
    $form.Close()
    [System.Windows.Forms.Application]::Exit()
})
$trayMenu.Items.Add($exitItem)

$notifyIcon.ContextMenuStrip = $trayMenu

# Handle form closing
$form.Add_FormClosing({
    param($sender, $e)
    if ($e.CloseReason -eq "UserClosing") {
        $e.Cancel = $true
        $form.Hide()
        $notifyIcon.ShowBalloonTip(1000, "Custom Mouse DPI", "Minimized to tray", [System.Windows.Forms.ToolTipIcon]::Info)
    }
})

# Double-click tray icon
$notifyIcon.Add_MouseDoubleClick({
    $form.Show()
    $form.WindowState = "Normal"
    $form.BringToFront()
})

# Initialize
Update-Status "Ready - Current DPI: $global:CurrentDPI"
$form.Show()

# Start application
[System.Windows.Forms.Application]::Run($form)