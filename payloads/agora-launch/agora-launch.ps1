$ErrorActionPreference = "SilentlyContinue"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Play-LaunchTone {
    # Short original retro-style arpeggio. No external audio files needed.
    $notes = @(
        @(659, 90), @(784, 90), @(988, 110), @(1318, 130),
        @(988, 90), @(1318, 160), @(1568, 220)
    )

    foreach ($note in $notes) {
        [Console]::Beep($note[0], $note[1])
        Start-Sleep -Milliseconds 25
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Agora Exchange"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(460, 280)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(12, 18, 28)
$form.ForeColor = [System.Drawing.Color]::White

$title = New-Object System.Windows.Forms.Label
$title.Text = "Agora Exchange"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$title.AutoSize = $false
$title.TextAlign = "MiddleCenter"
$title.Size = New-Object System.Drawing.Size(420, 42)
$title.Location = New-Object System.Drawing.Point(20, 24)
$title.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)
$form.Controls.Add($title)

$status = New-Object System.Windows.Forms.Label
$status.Text = "Ready to launch secure workspace."
$status.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$status.AutoSize = $false
$status.TextAlign = "MiddleCenter"
$status.Size = New-Object System.Drawing.Size(400, 46)
$status.Location = New-Object System.Drawing.Point(30, 78)
$status.ForeColor = [System.Drawing.Color]::Gainsboro
$form.Controls.Add($status)

$launchButton = New-Object System.Windows.Forms.Button
$launchButton.Text = "Launch"
$launchButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$launchButton.Size = New-Object System.Drawing.Size(150, 42)
$launchButton.Location = New-Object System.Drawing.Point(155, 148)
$launchButton.BackColor = [System.Drawing.Color]::FromArgb(34, 197, 154)
$launchButton.ForeColor = [System.Drawing.Color]::Black
$launchButton.FlatStyle = "Flat"
$form.Controls.Add($launchButton)

$menuButtons = New-Object System.Collections.Generic.List[System.Windows.Forms.Button]

function New-MenuButton {
    param(
        [int]$X,
        [int]$Y
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = "Test"
    $button.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $button.Size = New-Object System.Drawing.Size(150, 38)
    $button.Location = New-Object System.Drawing.Point($X, $Y)
    $button.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 48)
    $button.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)
    $button.FlatStyle = "Flat"
    $button.Add_Click({ Start-TestSequence })
    $menuButtons.Add($button)
    $form.Controls.Add($button)
}

function Show-Menu {
    $launchButton.Visible = $false
    $title.Text = "Select from agora"
    $status.Text = "Choose a validation module."
    New-MenuButton 70 132
    New-MenuButton 240 132
    New-MenuButton 70 184
    New-MenuButton 240 184
}

function Start-TestSequence {
    foreach ($button in $menuButtons) {
        $button.Visible = $false
    }

    $title.Text = "Agora"
    $status.Text = "2"
    $status.Font = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Bold)
    $status.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)

    $script:agoraCountdown = 2
    $countTimer = New-Object System.Windows.Forms.Timer
    $countTimer.Interval = 1000
    $countTimer.Add_Tick({
        $script:agoraCountdown--
        if ($script:agoraCountdown -gt 0) {
            $status.Text = $script:agoraCountdown.ToString()
            return
        }

        $countTimer.Stop()
        $title.Text = "Agora"
        $status.Text = "Complete."

        $closeTimer = New-Object System.Windows.Forms.Timer
        $closeTimer.Interval = 3000
        $closeTimer.Add_Tick({
            $closeTimer.Stop()
            $form.Close()
        })
        $closeTimer.Start()
    })
    $countTimer.Start()
}

$launchButton.Add_Click({
    Play-LaunchTone
    Show-Menu
})

[void]$form.ShowDialog()
