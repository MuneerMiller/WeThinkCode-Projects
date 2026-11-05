# App Store listing (draft)

Copy these into App Store Connect. Character limits are Apple's.

| Field | Value |
|---|---|
| App name (30) | Elderly Care |
| Subtitle (30) | Medicines, visits & SOS help |
| Bundle ID | `com.muneermiller.elderlycare` |
| SKU | `elderlycare-ios-1` |
| Primary category | Medical |
| Secondary category | Health & Fitness |
| Price | USD 19.99 (once-off, no in-app purchases) |
| Availability | All countries, or start with South Africa |
| Privacy policy URL | https://muneermiller.github.io/WeThinkCode-Projects/privacy.html |
| Support URL | https://muneermiller.github.io/WeThinkCode-Projects/support.html |
| Marketing URL | https://muneermiller.github.io/WeThinkCode-Projects/ |
| Copyright | 2026 *your name or company* |
| Languages | English (U.K.) as primary. The App Store has no isiZulu or isiXhosa listing language; the app itself offers both. You can add an Afrikaans listing only if App Store Connect offers it for your account. |

"Elderly Care" may already be taken on the store. If so, try "Elderly Care: Pill Reminder" or a more distinctive name, and use the same name on Google Play.

## Promotional text (170, can change any time)

Medicine reminders, doctor visits, health readings and one big help button. Large text, plain words, four languages. Private: everything stays on your phone.

## Description (4000)

Elderly Care is a calm, easy app made for older people, and for the families who care about them. Big buttons, large text and plain words make it simple to stay on top of medicines, appointments and health, and to get help quickly when something is wrong.

PRIVATE BY DESIGN
• Everything stays on your phone, encrypted.
• No account, no sign-in, no advertising, no tracking.
• Lock it with a PIN, Face ID or Touch ID.
• Pay once. No subscription.

MEDICINE REMINDERS
• Reminders for up to three doses a day.
• Answer straight from the notification: Taken, In 10 minutes or Not yet.
• A gentle follow-up if a dose is missed, and the option to text your family.
• A warning before your tablets run out.
• A 7-day record of what you took.

DOCTOR VISITS
• Keep upcoming and past appointments in one place.
• A reminder an hour before.

HEALTH READINGS
• Blood pressure and pulse, blood sugar, weight and sleep.
• Clear charts and healthy-range tips.
• Share a 30-day summary with your doctor as a PDF or a message.

HELP IN ONE TAP
• Call emergency services.
• Text everyone in your family your location.
• Show your Medical ID (allergies, conditions, medicines, emergency contacts) to paramedics, even when the app is locked.
• Find hospitals and clinics nearby, with directions and phone numbers.
• Start a free video call with family.

MADE FOR YOU
• A short, friendly setup: what to call you, a comfortable text size, what you want help with, and when you get up and go to bed, so medicine times fit your day.
• Read aloud for today's summary, the medicine check and your Medical ID.
• English, Afrikaans, isiZulu and isiXhosa.
• Works with VoiceOver, larger text and dark mode.

Keep photos of prescriptions and test results, and notes for your next visit, all in the same place.

Elderly Care helps you remember and organise. It is not a medical device and does not give medical advice. Always follow your doctor's or pharmacist's instructions. In an emergency, call your local emergency number.

## Keywords (100, comma-separated, no spaces)

pill,reminder,medication,senior,blood pressure,sugar,sos,medical id,caregiver,dose,tracker,pillbox

## What's New (first release)

First release.

## Screenshots

From `elderly-care-store-screenshots.zip` (shared separately, not in git):

- **iPhone 6.9"** (1320 × 2868): `App Store - iPhone 6.9in/`. Apple scales these down for smaller iPhones.
- **iPad 13"** (2064 × 2752): `App Store - iPad 13in/`. These are required because the app supports iPad.

Upload them in order (01 to 08). The first three are what most people see in search results.

## App Privacy (the "nutrition label")

- **Do you or your third-party partners collect data from this app?** → **No, we do not collect data from this app.**

  Why this is accurate: Apple counts data as "collected" only when it leaves the device and is kept longer than needed to answer the request in real time. Everything is stored on the device. The hospital search sends the location to OpenStreetMap's Overpass service, and video calls go through Jitsi Meet; both only answer the request at that moment, and neither is your partner. Calls and messages are sent by the phone's own Phone and Messages apps.

- **Tracking:** none. The app doesn't need the "Allow tracking" prompt.
- The privacy manifest `ios/Runner/PrivacyInfo.xcprivacy` gives the same answers. Keep the two in step.

## Age rating

Answer the questionnaire honestly. For this app, everything is "None" except, possibly, **Medical or Treatment-Focused Content**. The app manages the user's own medicines and readings and gives no treatment advice, so choose the lowest level the form offers for it. The result should be the youngest or near-youngest rating. Don't mark it "Made for Kids".

## Export compliance

The app uses only standard encryption to protect the user's own data, which is exempt. `ITSAppUsesNonExemptEncryption` is set to `NO` in `Info.plist`, so App Store Connect won't ask about it for each build.

## Notes for the reviewer (App Review Information)

> Elderly Care needs no account or sign-in. On first launch, a short intro and a 7-step setup appear: enter any name and accept the terms on the last step. Sample flows:
> • Medicines → Add medicine → save. A daily reminder is scheduled, and its notification has Taken / In 10 min / Not yet buttons.
> • Health tracker → Blood pressure → Add reading, then Share → PDF.
> • "I need help" opens the emergency options. "Call emergency services" opens the Phone app with the number the user chose (default 112), and "Alert my family" opens Messages with the text filled in. Nothing is sent without the user pressing Send.
> All data is stored on the device and encrypted. There is no server. The hospital search sends the current location to OpenStreetMap's Overpass API to list nearby hospitals; video calls open a Jitsi Meet room.
> The app is an organiser and reminder tool for the user's own medicines. It is not a medical device and makes no diagnosis or treatment recommendation. A medical disclaimer is shown during setup and under My profile → Legal & about.

Contact: *your name, phone and email*. Demo account: not needed.

## Notes on Apple's rules that matter here

- **Guideline 1.4.1 (medical apps):** keep the description and screenshots to "reminders and organiser". Never claim the app diagnoses, treats or measures anything. The disclaimers are already in the app.
- **Guideline 5.1.1(ix):** Apple can ask apps in healthcare to come from a legal entity rather than an individual. A reminder app usually passes as an individual, but enrolling as a company (Pty) Ltd avoids the question.
- **Custom licence:** the Terms of Use include the clauses Apple requires in a custom EULA (section 11). In App Store Connect → App Information → License Agreement, either keep Apple's standard EULA or paste the Terms of Use as a custom one.
