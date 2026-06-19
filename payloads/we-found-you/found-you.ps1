$ErrorActionPreference = "SilentlyContinue"

# Notes: Speech engine setup.
# This keeps the payload harmless and local. It only speaks training text.
Add-Type -AssemblyName System.Speech

$speaker = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speaker.Rate = 0
$speaker.Volume = 100

function Say-Note {
    param(
        [string]$Title,
        [string]$Message
    )

    $line = "$Title - $Message"
    Write-Host $line
    $speaker.Speak($line)
    Start-Sleep -Milliseconds 350
}

# Notes: Local Windows account label.
# This displays the signed-in Windows user only. It does not upload or save it.
$userName = [Environment]::UserName
$domainName = [Environment]::UserDomainName
$accountLabel = "$domainName\$userName"

# Notes: Demo location label.
# Real latitude/longitude is intentionally not collected. These are fixed lab/demo values.
$demoLatitude = "37.3382"
$demoLongitude = "-121.8863"

# Notes: Interaction pause.
# Mouse-movement waiting is intentionally not used here. This demo uses a short pause instead.
Start-Sleep -Seconds 2

Say-Note "Agora Exchange" "security training initialized"
Say-Note "Account" "local user detected as $accountLabel"
Say-Note "Location" "demo coordinates $demoLatitude, $demoLongitude"
Say-Note "Payload" "launched from a Flipper Zero style training script"
Say-Note "Safety" "no files touched and no data collected"
Say-Note "Reminder" "training complete, lock your workstation"
