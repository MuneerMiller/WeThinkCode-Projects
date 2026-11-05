#!/usr/bin/env python3
"""Builds the app's public website (privacy policy, terms, support) into
build/site, from the same legal documents the app shows.

The app stores need a privacy policy and a support page at public web
addresses. GitHub Pages publishes this site (see
.github/workflows/elderly-app-site.yml).

    python3 tool/build_site.py          # build
    python3 tool/build_site.py --check  # also fail while placeholders remain
"""
import html
import pathlib
import re
import shutil
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "build" / "site"

DOCS = [  # (asset file, page, title)
    ("privacy_policy", "privacy", "Privacy policy"),
    ("terms_of_use", "terms", "Terms of Use"),
    ("medical_disclaimer", "medical-disclaimer", "Medical disclaimer"),
    ("accessibility", "accessibility", "Accessibility statement"),
    ("credits", "credits", "Credits and third-party notices"),
]


def legal_values():
    """Reads LegalInfo (version, date, publisher details) from legal.dart."""
    src = (ROOT / "lib/legal/legal.dart").read_text(encoding="utf-8")
    version = re.search(r"static const version = (\d+);", src).group(1)
    date = re.search(r"static const effectiveDate = '([^']*)';", src).group(1)
    block = re.search(r"static const values = <String, String>\{(.*?)\};", src, re.S).group(1)
    values = {}
    # Each entry is 'key': 'part' 'part' ... (adjacent literals concatenate).
    for m in re.finditer(r"'(\w+)':\s*((?:'[^']*'\s*)+),", block):
        values[m.group(1)] = "".join(re.findall(r"'([^']*)'", m.group(2)))
    values["legal_version"] = version
    values["effective_date"] = date
    app_version = re.search(r"const appVersion = '([^']*)';", src).group(1)
    return values, app_version


def fill(text, values):
    for k, v in values.items():
        text = text.replace("{{" + k + "}}", v)
    return text


def inline(text):
    out = html.escape(text, quote=False)
    out = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", out)
    # Turn bare web addresses into links.
    out = re.sub(
        r"(?<![\"=>])\b((?:https?://)[^\s<)]+[^\s<.,;:)])",
        r'<a href="\1">\1</a>',
        out,
    )
    return out


def markdown(md):
    """The small Markdown subset the documents use (same as the app)."""
    parts = []
    for block in re.split(r"\n\s*\n", md.strip()):
        lines = block.strip().split("\n")
        first = lines[0]
        if first.startswith("# "):
            parts.append(f"<h1>{inline(first[2:])}</h1>")
        elif first.startswith("## "):
            parts.append(f"<h2>{inline(first[3:])}</h2>")
        elif first.startswith("### "):
            parts.append(f"<h3>{inline(first[4:])}</h3>")
        elif first.startswith("- "):
            items = "".join(f"<li>{inline(l[2:])}</li>" for l in lines)
            parts.append(f"<ul>{items}</ul>")
        else:
            parts.append(f"<p>{inline(' '.join(lines))}</p>")
    return "\n".join(parts)


def page(title, body, active=""):
    nav = [("index.html", "Home"), ("support.html", "Support"),
           ("privacy.html", "Privacy"), ("terms.html", "Terms")]
    links = "".join(
        f'<a href="{href}"{" aria-current=\"page\"" if href == active else ""}>{name}</a>'
        for href, name in nav
    )
    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(title)} · Elderly Care</title>
<link rel="icon" href="logo.png">
<link rel="stylesheet" href="style.css">
</head>
<body>
<header><a class="brand" href="index.html"><img src="logo.png" alt="" width="36" height="36">Elderly Care</a>
<nav>{links}</nav></header>
<main>
{body}
</main>
<footer><p>Elderly Care keeps your information on your own phone. No account, no tracking, no advertising.</p>
<p><a href="privacy.html">Privacy policy</a> · <a href="terms.html">Terms of Use</a> · <a href="medical-disclaimer.html">Medical disclaimer</a> · <a href="accessibility.html">Accessibility</a> · <a href="credits.html">Credits</a></p></footer>
</body>
</html>
"""


def main():
    values, app_version = legal_values()
    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir(parents=True)
    shutil.copy(ROOT / "site/style.css", OUT / "style.css")
    shutil.copy(ROOT / "assets/images/logo.png", OUT / "logo.png")
    shutil.copy(ROOT / "docs/screenshots/feature-grid.png", OUT / "screens.png")
    (OUT / ".nojekyll").write_text("")

    unfinished = []
    for asset, name, title in DOCS:
        text = fill((ROOT / f"assets/legal/{asset}.md").read_text(encoding="utf-8"), values)
        if "to be completed" in text:
            unfinished.append(name)
        (OUT / f"{name}.html").write_text(
            page(title, f'<article class="doc">{markdown(text)}</article>', f"{name}.html"),
            encoding="utf-8",
        )

    for name in ["index", "support"]:
        body = fill((ROOT / f"site/{name}.html").read_text(encoding="utf-8"), values)
        body = body.replace("{{app_version}}", app_version)
        if "to be completed" in body:
            unfinished.append(name)
        title = "Medicines, appointments and help, made simple" if name == "index" else "Support"
        (OUT / f"{name}.html").write_text(page(title, body, f"{name}.html"), encoding="utf-8")

    print(f"Built {OUT.relative_to(ROOT)} ({len(DOCS) + 2} pages).")
    if unfinished:
        msg = ("Publisher details still say 'to be completed' on: "
               + ", ".join(unfinished) + ". Fill in LegalInfo.values in lib/legal/legal.dart.")
        if "--check" in sys.argv:
            sys.exit(msg)
        print("Warning: " + msg)


if __name__ == "__main__":
    main()
