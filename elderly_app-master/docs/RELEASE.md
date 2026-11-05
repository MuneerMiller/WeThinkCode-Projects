# Releasing Elderly Care

A step-by-step checklist for selling the app on the App Store and Google Play: USD 19.99 once-off, no subscription, all data on the user's phone.

The app's code, website, store texts and screenshots are prepared. What's left needs you: accounts, legal details and the two uploads.

## 1. Business and accounts (start first: these take the longest)

- [ ] **Decide who sells the app.** A (Pty) Ltd is recommended: it limits your personal liability for a health-related app, shows a company name on the stores instead of yours, and avoids Apple's rule that healthcare apps may need to come from a company (guideline 5.1.1(ix)). Register at the CIPC (bizportal.gov.za), then get a free **D-U-N-S number**, which Apple needs for company accounts.
- [ ] **Apple Developer Program**, USD 99 a year: developer.apple.com/programs. Verification can take a week or more.
- [ ] **Google Play Console**, USD 25 once: play.google.com/console. Choose an *organisation* account if you have a company: it skips the 12-tester rule.
- [ ] **Apple:** App Store Connect → Business → accept the **Paid Apps Agreement**, add a South African bank account, and complete the US tax form (W-8BEN for a person, W-8BEN-E for a company). Then enrol in the **App Store Small Business Program**, which brings Apple's commission down to 15%.
- [ ] **Google:** Play Console → Settings → Payments profile, to set up the merchant account for paid apps.
- [ ] **SARS:** sales are taxable income. VAT registration is only compulsory over R1 million turnover in 12 months. Apple and Google charge VAT to buyers in most countries themselves.

## 2. Legal details

- [ ] Fill in `LegalInfo.values` in [`lib/legal/legal.dart`](../lib/legal/legal.dart): publisher name, legal status, registration number, address, contact email and phone, Information Officer. Until then, the app and the website show "[… to be completed]".
- [ ] Set `LegalInfo.effectiveDate` to your launch date.
- [ ] Register your Information Officer with the Information Regulator (inforegulator.org.za), and prepare a PAIA manual (the privacy policy refers to both).
- [ ] Confirm you may use the **logo and illustrations** carried over from the original student project, or replace them. **The app icon is that logo**, so the stores need you to have the rights to it.
- [ ] Have a South African attorney review the Terms of Use, privacy policy and medical disclaimer. The Terms now cover the paid sale, refunds through the stores, and Apple's required licence terms.
- [ ] Check that the name "Elderly Care" is free on both stores, and consider a trademark search. A more distinctive name helps sales too.

## 3. Website (privacy policy and support pages)

The site is built from the app's own legal documents by `tool/build_site.py` and published with GitHub Pages.

- [ ] Once: repository **Settings → Pages → Source: GitHub Actions**.
- [ ] Run the "Elderly Care website" workflow (Actions tab), or push a change to the legal files.
- [ ] Check https://muneermiller.github.io/WeThinkCode-Projects/privacy.html and …/support.html.
- [ ] Later, replace the two "Download" buttons in `site/index.html` with the real store links.

`python3 tool/build_site.py --check` fails while any publisher detail still says "to be completed". Use it as a final check.

## 4. Android: build and upload

- [ ] Create the upload key once and keep it safe. The README's "Signing the Android app for release" section explains how.
- [ ] Add these four secrets to the repository (Settings → Secrets and variables → Actions):
  - `ANDROID_KEYSTORE_BASE64`, the output of `base64 -w0 elderly-care-upload.jks`
  - `ANDROID_KEYSTORE_PASSWORD`
  - `ANDROID_KEY_ALIAS`
  - `ANDROID_KEY_PASSWORD`
- [ ] Actions → **Elderly Care release (Google Play)** → Run workflow, then download the `elderly-care-play-bundle` artifact (`app-release.aab`).
- [ ] In Play Console: create the app, fill in the listing and App content from [`store/google-play.md`](store/google-play.md), and upload the `.aab` to **Closed testing**.
- [ ] Personal accounts only: keep at least 12 testers opted in for 14 days, then apply for production.
- [ ] Promote the release to Production.

## 5. iOS: build and upload (needs a Mac with Xcode)

- [ ] On the Mac: clone the repository, then run these in `elderly_app-master`:

```bash
flutter pub get
```

```bash
open ios/Runner.xcworkspace
```

- [ ] In Xcode, select **Runner** → Signing & Capabilities → choose your **Team**. The bundle ID is `com.muneermiller.elderlycare`, and Xcode creates the certificates automatically.
- [ ] In App Store Connect: create the app with the same bundle ID, and fill in the listing, App Privacy, age rating and review notes from [`store/app-store.md`](store/app-store.md).
- [ ] Build and upload:

```bash
flutter build ipa --release
```

  Then open `build/ios/archive/Runner.xcarchive` in Xcode → Distribute App → App Store Connect → Upload. Apple's Transporter app also works with the `.ipa` in `build/ios/ipa`.
- [ ] Test the build on a real iPhone through **TestFlight**: reminders, Face ID, the camera, location and calls.
- [ ] Submit for review. Review usually takes 1–3 days.

No Mac? Codemagic or a rented Mac in the cloud can build and upload with your Apple account, using the same steps.

## 6. Before every release

- [ ] Raise `version` in `pubspec.yaml` (for example `2.2.1+6`; the number after `+` must always go up) and `appVersion` in `lib/legal/legal.dart`. A test checks they match.
- [ ] Run `flutter analyze`, `flutter test`, and `tool/build_web.sh` then `node test_e2e/browser_test.js`.
- [ ] If the legal documents changed in a way users must accept again, raise `LegalInfo.version` and `effectiveDate`.
- [ ] Have a native speaker review any new isiZulu and isiXhosa text.

## 7. Things to keep in mind

- **Don't publish the web version for free** while selling the app.
- **Moving to a new phone:** the encryption key stays on the old phone, so users must use **Back up my data** and **Restore from a backup**. The support page explains this.
- **Refunds** are handled by Apple and Google, not by you.
- **The app ID** (`com.muneermiller.elderlycare`) can't change after the first upload. Change it in `android/app/build.gradle.kts` and the iOS project now if you want another, for example one with your company's domain.
- **Reviews:** keep the store text to "reminders and organiser". Never claim the app diagnoses or treats anything.
