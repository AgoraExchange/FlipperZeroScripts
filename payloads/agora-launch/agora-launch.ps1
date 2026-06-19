$ErrorActionPreference = "SilentlyContinue"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Play-LaunchTone {
    $notes = @(
        @(659, 80), @(784, 80), @(988, 100), @(1175, 90),
        @(988, 80), @(1318, 120), @(1568, 180)
    )

    foreach ($note in $notes) {
        [Console]::Beep($note[0], $note[1])
        Start-Sleep -Milliseconds 18
    }
}

function New-DeckButton {
    param(
        [string]$Text,
        [int]$X,
        [int]$Y
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $button.Size = New-Object System.Drawing.Size(142, 34)
    $button.Location = New-Object System.Drawing.Point($X, $Y)
    $button.BackColor = [System.Drawing.Color]::FromArgb(20, 31, 46)
    $button.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)
    $button.FlatStyle = "Flat"
    $button.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(41, 255, 198)
    return $button
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Agora Exchange"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(620, 390)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(8, 13, 22)
$form.ForeColor = [System.Drawing.Color]::White

$title = New-Object System.Windows.Forms.Label
$title.Text = "Agora Exchange"
$title.Font = New-Object System.Drawing.Font("Consolas", 20, [System.Drawing.FontStyle]::Bold)
$title.AutoSize = $false
$title.TextAlign = "MiddleCenter"
$title.Size = New-Object System.Drawing.Size(580, 38)
$title.Location = New-Object System.Drawing.Point(20, 18)
$title.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)
$form.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "portable ops deck // visual simulation"
$subtitle.Font = New-Object System.Drawing.Font("Consolas", 9)
$subtitle.AutoSize = $false
$subtitle.TextAlign = "MiddleCenter"
$subtitle.Size = New-Object System.Drawing.Size(580, 22)
$subtitle.Location = New-Object System.Drawing.Point(20, 54)
$subtitle.ForeColor = [System.Drawing.Color]::FromArgb(150, 164, 184)
$form.Controls.Add($subtitle)

$launchButton = New-Object System.Windows.Forms.Button
$launchButton.Text = "Launch"
$launchButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$launchButton.Size = New-Object System.Drawing.Size(160, 44)
$launchButton.Location = New-Object System.Drawing.Point(230, 174)
$launchButton.BackColor = [System.Drawing.Color]::FromArgb(34, 197, 154)
$launchButton.ForeColor = [System.Drawing.Color]::Black
$launchButton.FlatStyle = "Flat"
$form.Controls.Add($launchButton)

$status = New-Object System.Windows.Forms.Label
$status.Text = "READY"
$status.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$status.AutoSize = $false
$status.TextAlign = "MiddleLeft"
$status.Size = New-Object System.Drawing.Size(265, 32)
$status.Location = New-Object System.Drawing.Point(310, 105)
$status.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)
$status.Visible = $false
$form.Controls.Add($status)

$module = New-Object System.Windows.Forms.Label
$module.Text = "Select from Agora"
$module.Font = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$module.AutoSize = $false
$module.TextAlign = "MiddleLeft"
$module.Size = New-Object System.Drawing.Size(270, 32)
$module.Location = New-Object System.Drawing.Point(310, 80)
$module.ForeColor = [System.Drawing.Color]::White
$module.Visible = $false
$form.Controls.Add($module)

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ReadOnly = $true
$logBox.ScrollBars = "Vertical"
$logBox.BorderStyle = "FixedSingle"
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$logBox.Size = New-Object System.Drawing.Size(270, 180)
$logBox.Location = New-Object System.Drawing.Point(310, 145)
$logBox.BackColor = [System.Drawing.Color]::FromArgb(3, 7, 13)
$logBox.ForeColor = [System.Drawing.Color]::FromArgb(180, 255, 228)
$logBox.Visible = $false
$form.Controls.Add($logBox)

$buttons = New-Object System.Collections.Generic.List[System.Windows.Forms.Button]

function Add-Log {
    param([string]$Line)
    $logBox.AppendText("[" + (Get-Date -Format "HH:mm:ss") + "] " + $Line + [Environment]::NewLine)
}

function Show-Deck {
    $launchButton.Visible = $false
    $title.Text = "AGORA OPS"
    $subtitle.Text = "local training console // no network actions"
    $module.Visible = $true
    $status.Visible = $true
    $logBox.Visible = $true
    $logBox.Clear()

    $items = @(
        @("Grab IP", 28, 92),
        @("Upload Packets", 176, 92),
        @("Stage Module", 28, 136),
        @("Credential Audit", 176, 136),
        @("Beacon Trace", 28, 180),
        @("Packet Scope", 176, 180),
        @("Vault Sync", 28, 224),
        @("Purge Session", 176, 224)
    )

    foreach ($item in $items) {
        $button = New-DeckButton $item[0] $item[1] $item[2]
        $button.Add_Click({
            Start-AgoraAction $this.Text
        })
        $buttons.Add($button)
        $form.Controls.Add($button)
    }

    Add-Log "deck initialized"
    Add-Log "operator prompt ready"
}

function Start-AgoraAction {
    param([string]$Action)

    foreach ($button in $buttons) {
        $button.Visible = $false
    }

    $module.Text = $Action
    $status.Text = "RUNNING"
    $logBox.Clear()
    Add-Log "module selected: $Action"
    Add-Log "opening local simulation buffer"
    Add-Log "no files written"
    Add-Log "no network output"

    $script:agoraStep = 0
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 650
    $timer.Add_Tick({
        $script:agoraStep++

        if ($script:agoraStep -eq 1) {
            Add-Log "resolving visual context"
        } elseif ($script:agoraStep -eq 2) {
            Add-Log "rendering packet map"
        } elseif ($script:agoraStep -eq 3) {
            Add-Log "validating operator panel"
        } elseif ($script:agoraStep -eq 4) {
            $timer.Stop()
            $status.Text = "Complete."
            Add-Log "sequence complete"

            $closeTimer = New-Object System.Windows.Forms.Timer
            $closeTimer.Interval = 3000
            $closeTimer.Add_Tick({
                $closeTimer.Stop()
                $form.Close()
            })
            $closeTimer.Start()
        }
    })
    $timer.Start()
}

$launchButton.Add_Click({
    Play-LaunchTone
    Show-Deck
})

[void]$form.ShowDialog()
