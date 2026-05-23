# NeuralMedics — ilk push veya güncelleme
# Kullanım:
#   .\scripts\push.ps1 -Remote "https://github.com/kullanici/neuralmedicsmobileapp.git"
# veya:
#   $env:GITHUB_REMOTE = "https://github.com/kullanici/neuralmedicsmobileapp.git"
#   .\scripts\push.ps1

param(
    [string]$Remote = $env:GITHUB_REMOTE,
    [string]$Branch = "main",
    [string]$Message = "NeuralMedics: Flutter AI brain tumor app"
)

$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git bulunamadi."
}

git lfs install --local | Out-Null

$currentRemote = git remote get-url origin 2>$null
if (-not $Remote -and $currentRemote) {
    $Remote = $currentRemote
}

if (-not $Remote) {
    throw @"
GitHub remote URL gerekli.

Ornek:
  .\scripts\push.ps1 -Remote "https://github.com/KULLANICI/neuralmedicsmobileapp.git"

Once GitHub'da bos repo olustur (README ekleme).
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
    Write-Host "Commit edilecek degisiklik yok."
}

git branch -M $Branch
Write-Host "Push basliyor (LFS dosyalari dahil, biraz surebilir)..."
git push -u origin $Branch
Write-Host "Tamam: $Remote ($Branch)"
