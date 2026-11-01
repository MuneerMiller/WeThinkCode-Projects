#!/usr/bin/env bash
# Builds the release website into build/web and locks it down with a
# Content-Security-Policy. (The policy is added here rather than in
# web/index.html because Flutter's debug mode needs an inline script.)
#
#   tool/build_web.sh
set -euo pipefail
cd "$(dirname "$0")/.."

flutter build web --release --no-web-resources-cdn "$@"

# Only code from this site may run; the only outside service the page may
# talk to is the OpenStreetMap hospital search (plus Google's font server,
# which Flutter uses for characters missing from the bundled fonts).
CSP="default-src 'self'; \
script-src 'self' 'wasm-unsafe-eval'; \
style-src 'self' 'unsafe-inline'; \
img-src 'self' data: blob:; \
font-src 'self' data: https://fonts.gstatic.com; \
connect-src 'self' blob: data: https://overpass-api.de https://fonts.gstatic.com; \
worker-src 'self' blob:; \
object-src 'none'; base-uri 'self'; form-action 'none'"

python3 - "$CSP" <<'PY'
import sys
path = 'build/web/index.html'
html = open(path, encoding='utf-8').read()
tag = f'<meta http-equiv="Content-Security-Policy" content="{sys.argv[1]}">'
if 'Content-Security-Policy' not in html:
    html = html.replace('<meta charset="UTF-8">', '<meta charset="UTF-8">\n  ' + tag, 1)
    open(path, 'w', encoding='utf-8').write(html)
PY
grep -q 'Content-Security-Policy' build/web/index.html
echo "Built build/web with a Content-Security-Policy."
