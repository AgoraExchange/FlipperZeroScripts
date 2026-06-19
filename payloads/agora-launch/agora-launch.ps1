$ErrorActionPreference = "SilentlyContinue"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Agora Exchange"
$form.StartPosition = "CenterScreen"
$form.Size = New-Object System.Drawing.Size(420, 230)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(12, 18, 28)
$form.ForeColor = [System.Drawing.Color]::White

$title = New-Object System.Windows.Forms.Label
$title.Text = "Agora Exchange"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(96, 26)
$title.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)
$form.Controls.Add($title)

$status = New-Object System.Windows.Forms.Label
$status.Text = "Ready to launch secure workspace."
$status.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$status.AutoSize = $false
$status.TextAlign = "MiddleCenter"
$status.Size = New-Object System.Drawing.Size(360, 42)
$status.Location = New-Object System.Drawing.Point(30, 78)
$status.ForeColor = [System.Drawing.Color]::Gainsboro
$form.Controls.Add($status)

$button = New-Object System.Windows.Forms.Button
$button.Text = "Launch"
$button.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$button.Size = New-Object System.Drawing.Size(150, 42)
$button.Location = New-Object System.Drawing.Point(135, 132)
$button.BackColor = [System.Drawing.Color]::FromArgb(34, 197, 154)
$button.ForeColor = [System.Drawing.Color]::Black
$button.FlatStyle = "Flat"
$form.Controls.Add($button)

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 3000
$timer.Add_Tick({
    $timer.Stop()
    $form.Close()
})

$button.Add_Click({
    $button.Visible = $false
    $status.Text = "Agora Launched."
    $status.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $status.ForeColor = [System.Drawing.Color]::FromArgb(92, 255, 210)
    $timer.Start()
})

[void]$form.ShowDialog()

