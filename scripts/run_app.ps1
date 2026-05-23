# Single command: run NeuralMedics on connected device/emulator.
# Requires: Firebase Email/Password enabled + Firestore rules deployed once.

Set-Location $PSScriptRoot\..

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter run @args
