# Elderly Care

The easiest way for an older person to manage medicines, doctor visits, health readings and emergencies, all in one place.

Built with Flutter 3 for **Android, iOS and the web**. Everything is stored on the device. Calls, texts, maps and video calls are handed to the phone's own apps, so no account or server is needed.

<p>
<img src="screens/home.png" width="200" alt="Home screen">
<img src="screens/medicines.png" width="200" alt="Today's medicine schedule">
<img src="screens/sos.png" width="200" alt="Emergency options">
<img src="screens/blood-pressure.png" width="200" alt="Blood pressure chart">
</p>

## Features

| | |
|---|---|
| **Medicine reminders** | Add a medicine, its dose and up to three times a day. A notification comes when it's due, and the app asks *"Did you take it?"*. If the answer is no, it offers to text the family. It can also count the doses left in the pack and warn when it's time to refill, and it shows how many doses were taken in the last 7 days. |
| **Appointments** | Upcoming and past doctor visits, with a reminder an hour before. |
| **Health tracker** | Blood pressure, blood sugar, weight and sleep, with a chart of recent readings and healthy-range tips. **Share** sends a doctor a plain-text summary of recent readings, medicines and appointments. |
| **I need help (SOS)** | One big red button: call emergency services (112 by default, changeable), text every family member your current location, show your medical ID, or call a relative directly. |
| **Medical ID** | Allergies, conditions, blood group, medicines and emergency contacts in large type, for paramedics or a new doctor. |
| **My family** | Family and carers with one-tap Call and Text buttons. |
| **Hospitals nearby** | Hospitals and clinics within 10 km from OpenStreetMap (no API key), nearest first, with directions and phone numbers. |
| **Video call** | Opens a free [Jitsi Meet](https://meet.jit.si) call in the user's own private room and texts the family the link. |
| **Documents** | Photos of prescriptions, test results and medical aid cards, searchable by name. |
| **Notes** | Things to remember. Important notes stay at the top. |
| **Profile** | Medical details (blood group, allergies, conditions, usual BP…), the emergency number and an in-app text size setting (Normal / Large / Extra large). |
| **Backup & restore** | Saves everything to one file you can email to yourself or keep in cloud storage, and restores it on a new phone. |

### Designed for older users
- Large type in [Lexend](https://www.lexend.com/), a font designed for readability. The layout grows with the phone's text-size setting.
- Large touch targets. Every form's main button stays pinned to the bottom of the screen.
- One colour per area of the app, plain-language labels, and a confirmation before anything is deleted.
- Works with screen readers, in dark mode, and on tablets and desktop browsers.

<p>
<img src="screens/dose-check.png" width="180" alt="Medicine check">
<img src="screens/hospitals.png" width="180" alt="Nearby hospitals">
<img src="screens/family.png" width="180" alt="Family">
<img src="screens/documents.png" width="180" alt="Documents">
<img src="screens/medical-id.png" width="180" alt="Medical ID">
<img src="screens/home-dark.png" width="180" alt="Dark mode">
</p>

## Running it

### The easy way: one script

`run.sh` (macOS/Linux) and `run.ps1` (Windows) do everything: download the project if needed, install Flutter to your home folder if you don't have it, fetch packages and start the app. The only thing you need beforehand is [git](https://git-scm.com) (plus Google Chrome for the default mode).

| Command | What it does |
|---|---|
| `./run.sh` | Run the app in Chrome |
| `./run.sh serve` | Run it as a website at http://localhost:8080, for any browser |
| `./run.sh phone` | Run on a plugged-in phone or an emulator |
| `./run.sh test` | Run the code checks and automated tests |

On Windows use `.\run.ps1`, `.\run.ps1 serve` and so on in PowerShell. If Windows blocks the script, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once.

You can also download just the script and run it in an empty folder. It clones the repo next to itself.

### By hand

Requires Flutter 3.35 or newer (Dart 3.9+).

```bash
flutter pub get
```

On a phone or emulator:

```bash
flutter run
```

In Chrome:

```bash
flutter run -d chrome
```

To build:

```bash
flutter build apk --release
```

```bash
flutter build web --release --no-web-resources-cdn
```

On the web, reminders appear inside the app rather than as phone notifications, and calls and texts open the computer's default handler.

## Tests

GitHub Actions (`.github/workflows/elderly-app.yml`) runs the formatting check, `flutter analyze`, the tests and a web build on every push and pull request that touches the app.

```bash
flutter analyze
```

```bash
flutter test
```

`flutter test` runs unit tests for the scheduling, storage and hospital-search logic, plus widget tests that walk through every feature with fake phone services.

`test_e2e/browser_test.js` drives the release **web build** in headless Chromium (Playwright). It goes from onboarding through every feature, reloads the page to check the data persisted, and saves a screenshot of each step to `test_e2e/output/`. Location is faked and the hospital API is answered from a fixture.

```bash
flutter build web --release --no-web-resources-cdn
```

```bash
node test_e2e/browser_test.js
```

## Project layout

```
lib/
  main.dart                 app start, theme, first-run gate
  app_scope.dart            gives screens the data store and services
  theme.dart                colours, type scale, per-feature accents
  data/                     models + on-device store (shared_preferences)
  services/                 calls/SMS/links, location + hospital search, notifications
  screens/<feature>/        one folder per feature
  widgets/common.dart       shared building blocks
```

## Permissions

- **Location**: to find nearby hospitals and, only when you ask, to send your location to your family.
- **Notifications**: for medicine and appointment reminders, which are rescheduled after a reboot.
- **Camera / photos**: to save photos of documents.
- **Internet**: for the hospital search.
