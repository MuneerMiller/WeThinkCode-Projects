#!/usr/bin/env bash
# Builds the public web demo into build/demo: the release web app with
# sample data that resets on every visit (see lib/demo/demo.dart).
#
#   tool/build_demo.sh                         # for GitHub Pages (…/app/)
#   DEMO_BASE=/ tool/build_demo.sh             # to serve from a site's root
set -euo pipefail
cd "$(dirname "$0")/.."

tool/build_web.sh --dart-define=DEMO=true --base-href "${DEMO_BASE:-/WeThinkCode-Projects/app/}"
rm -rf build/demo
mv build/web build/demo
echo "Built the demo in build/demo."
