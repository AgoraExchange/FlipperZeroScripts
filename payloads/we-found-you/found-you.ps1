$ErrorActionPreference = "SilentlyContinue"

Add-Type -AssemblyName System.Speech

$speaker = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speaker.Rate = 0
$speaker.Volume = 100

$lines = @(
    "Agora Exchange security training initialized.",
    "This is a harmless awareness demonstration.",
    "A script was launched from a Flipper Zero style payload.",
    "No files were touched. No data was collected.",
    "Training complete. Lock your workstation."
)

foreach ($line in $lines) {
    Write-Host $line
    $speaker.Speak($line)
    Start-Sleep -Milliseconds 350
}

