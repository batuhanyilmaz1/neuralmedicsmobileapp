# NeuralMedics — first push or update
# Usage:
#   .\scripts\push.ps1 -Remote "https://github.com/username/neuralmedicsmobileapp.git"
# or:
#   $env:GITHUB_REMOTE = "https://github.com/username/neuralmedicsmobileapp.git"
#   .\scripts\push.ps1

param(
    [string]$Remote = $env:GITHUB_REMOTE,
    [string]$Branch = "main",
    [string]$Message = "NeuralMedics: Flutter AI brain tumor app"
)

$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git not found."
}

git lfs install --local | Out-Null

$currentRemote = git remote get-url origin 2>$null
if (-not $Remote -and $currentRemote) {
    $Remote = $currentRemote
}

if (-not $Remote) {
    throw @"
GitHub remote URL required.

Example:
  .\scripts\push.ps1 -Remote "https://github.com/USERNAME/neuralmedicsmobileapp.git"

First create an empty repo on GitHub (do not add a README).
"@
}

if (-not $currentRemote) {
    git remote add origin $Remote
} elseif ($currentRemote -ne $Remote) {
    git remote set-url origin $Remote
}

git add -A
$status = git status --porcelain
if ($status) {
    git commit -m $Message
} else {
    Write-Host "No changes to commit."
}

git branch -M $Branch
Write-Host "Starting push (including LFS files, this may take a while)..."
git push -u origin $Branch
Write-Host "Done: $Remote ($Branch)"
