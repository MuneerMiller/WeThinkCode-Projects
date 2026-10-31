#!/usr/bin/env bash
# Sets up and runs the Elderly Care app (macOS / Linux).
#
#   ./run.sh            run the app in Chrome
#   ./run.sh phone      run on a connected Android/iOS phone or emulator
#   ./run.sh serve      run as a website at http://localhost:8080 (any browser)
#   ./run.sh test       run the code checks and automated tests
#
# Works from anywhere: if it isn't run inside the project it downloads it
# first, and if Flutter isn't installed it installs it to ~/flutter.
set -euo pipefail

REPO_URL="https://github.com/MuneerMiller/WeThinkCode-Projects.git"
BRANCH="claude/focused-mayer-8e0cmm"   # falls back to main once this is merged
FLUTTER_DIR="${FLUTTER_DIR:-$HOME/flutter}"
MODE="${1:-chrome}"

say() { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31mError: %s\033[0m\n' "$*" >&2; exit 1; }

command -v git >/dev/null || die "git is not installed. Install it from https://git-scm.com and run this again."

# 1. Find (or download) the app.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$script_dir/pubspec.yaml" ]]; then
  APP_DIR="$script_dir"
else
  checkout="$PWD/WeThinkCode-Projects"
  if [[ ! -d "$checkout/.git" ]]; then
    say "Downloading the app into $checkout"
    git clone "$REPO_URL" "$checkout"
  fi
  git -C "$checkout" fetch --quiet origin
  if git -C "$checkout" rev-parse --verify --quiet "origin/$BRANCH" >/dev/null; then
    git -C "$checkout" checkout --quiet "$BRANCH" 2>/dev/null ||
      git -C "$checkout" checkout --quiet -b "$BRANCH" "origin/$BRANCH"
  else
    git -C "$checkout" checkout --quiet main
  fi
  git -C "$checkout" pull --quiet --ff-only || true
  APP_DIR="$checkout/elderly_app-master"
fi
cd "$APP_DIR"

# 2. Make sure Flutter is available.
if ! command -v flutter >/dev/null; then
  if [[ ! -x "$FLUTTER_DIR/bin/flutter" ]]; then
    say "Installing Flutter into $FLUTTER_DIR (one-time, a few minutes)"
    git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
  echo "Tip: add this line to your ~/.zshrc or ~/.bashrc to use flutter directly:"
  echo "  export PATH=\"$FLUTTER_DIR/bin:\$PATH\""
fi
flutter config --no-analytics >/dev/null 2>&1 || true

say "Getting the app's packages"
flutter pub get

# 3. Run it.
case "$MODE" in
  chrome)
    if ! flutter devices 2>/dev/null | grep -qi chrome; then
      die "Chrome wasn't found. Install Google Chrome, or use './run.sh serve' to open it in any browser."
    fi
    say "Starting Elderly Care in Chrome (press q in this window to quit)"
    flutter run -d chrome
    ;;
  phone)
    say "Looking for a phone or emulator"
    flutter devices
    echo "Plug in a phone with USB debugging on, or start an emulator from Android Studio."
    say "Starting Elderly Care (press q to quit)"
    flutter run
    ;;
  serve)
    say "Starting Elderly Care at http://localhost:8080 (press q to quit)"
    flutter run -d web-server --web-port 8080 --web-hostname localhost
    ;;
  test)
    say "Checking the code"
    flutter analyze
    say "Running the automated tests"
    flutter test
    say "All checks passed"
    ;;
  *)
    die "Unknown option '$MODE'. Use: chrome, phone, serve or test."
    ;;
esac
