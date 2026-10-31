# Sets up and runs the Elderly Care app (Windows PowerShell).
#
#   .\run.ps1            run the app in Chrome
#   .\run.ps1 phone      run on a connected Android phone or emulator
#   .\run.ps1 serve      run as a website at http://localhost:8080 (any browser)
#   .\run.ps1 test       run the code checks and automated tests
#
# Works from anywhere: if it isn't run inside the project it downloads it
# first, and if Flutter isn't installed it installs it to %USERPROFILE%\flutter.
# If Windows blocks the script, run once:
#   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
param([string]$Mode = "chrome")
$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/MuneerMiller/WeThinkCode-Projects.git"
$Branch = "claude/focused-mayer-8e0cmm"   # falls back to main once this is merged
$FlutterDir = if ($env:FLUTTER_DIR) { $env:FLUTTER_DIR } else { Join-Path $env:USERPROFILE "flutter" }

function Say($msg) { Write-Host "`n==> $msg" -ForegroundColor Green }
function Die($msg) { Write-Host "`nError: $msg" -ForegroundColor Red; exit 1 }
function Run($exe, [string[]]$argv) {
  & $exe @argv
  if ($LASTEXITCODE -ne 0) { Die "'$exe $($argv -join ' ')' failed." }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Die "git is not installed. Install it from https://git-scm.com and run this again."
}

# 1. Find (or download) the app.
if (Test-Path (Join-Path $PSScriptRoot "pubspec.yaml")) {
  $AppDir = $PSScriptRoot
} else {
  $checkout = Join-Path (Get-Location) "WeThinkCode-Projects"
  if (-not (Test-Path (Join-Path $checkout ".git"))) {
    Say "Downloading the app into $checkout"
    Run git @("clone", $RepoUrl, $checkout)
  }
  Run git @("-C", $checkout, "fetch", "--quiet", "origin")
  git -C $checkout rev-parse --verify --quiet "origin/$Branch" *> $null
  if ($LASTEXITCODE -eq 0) {
    git -C $checkout checkout --quiet $Branch 2>$null
    if ($LASTEXITCODE -ne 0) { Run git @("-C", $checkout, "checkout", "--quiet", "-b", $Branch, "origin/$Branch") }
  } else {
    Run git @("-C", $checkout, "checkout", "--quiet", "main")
  }
  git -C $checkout pull --quiet --ff-only 2>$null
  $AppDir = Join-Path $checkout "elderly_app-master"
}
Set-Location $AppDir

# 2. Make sure Flutter is available.
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  if (-not (Test-Path (Join-Path $FlutterDir "bin\flutter.bat"))) {
    Say "Installing Flutter into $FlutterDir (one-time, a few minutes)"
    Run git @("clone", "--depth", "1", "-b", "stable", "https://github.com/flutter/flutter.git", $FlutterDir)
  }
  $env:Path = (Join-Path $FlutterDir "bin") + ";" + $env:Path
  Write-Host "Tip: add $FlutterDir\bin to your PATH to use flutter directly."
}
flutter config --no-analytics *> $null

Say "Getting the app's packages"
Run flutter @("pub", "get")

# 3. Run it.
switch ($Mode) {
  "chrome" {
    if (-not ((flutter devices) -match "(?i)chrome")) {
      Die "Chrome wasn't found. Install Google Chrome, or use '.\run.ps1 serve' to open it in any browser."
    }
    Say "Starting Elderly Care in Chrome (press q in this window to quit)"
    flutter run -d chrome --no-web-resources-cdn
  }
  "phone" {
    Say "Looking for a phone or emulator"
    flutter devices
    Write-Host "Plug in a phone with USB debugging on, or start an emulator from Android Studio."
    Say "Starting Elderly Care (press q to quit)"
    flutter run
  }
  "serve" {
    Say "Starting Elderly Care at http://localhost:8080 (press q to quit)"
    flutter run -d web-server --web-port 8080 --web-hostname localhost --no-web-resources-cdn
  }
  "test" {
    Say "Checking the code"
    Run flutter @("analyze")
    Say "Running the automated tests"
    Run flutter @("test")
    Say "All checks passed"
  }
  default { Die "Unknown option '$Mode'. Use: chrome, phone, serve or test." }
}
