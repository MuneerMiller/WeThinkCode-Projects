# Google Play listing (draft)

Copy these into Play Console. Character limits are Google's.

| Field | Value |
|---|---|
| App name (30) | Elderly Care |
| Package name | `com.muneermiller.elderlycare` (permanent once uploaded) |
| Default language | English (United Kingdom), en-GB |
| Also add | Afrikaans (af) and Zulu (zu) listings if you want to translate them; Google Play has no Xhosa listing language |
| App or game | App |
| Free or paid | **Paid**, USD 19.99 or the local equivalent (R-price set automatically, adjustable). A paid app can never be changed to free and back. |
| Category | Medical |
| Tags | Health & fitness, Medical, Seniors, Reminders |
| Email | *your support email* |
| Website | https://muneermiller.github.io/WeThinkCode-Projects/ |
| Privacy policy | https://muneermiller.github.io/WeThinkCode-Projects/privacy.html |

## Short description (80)

Medicine reminders, doctor visits, health readings and SOS help. Private.

## Full description (4000)

Use the App Store description in [`app-store.md`](app-store.md); it fits Google's limits. Google doesn't allow claims like "best" or "#1" or emoji-heavy text, and the store description has none.

## Graphics

- **App icon** 512 × 512: `docs/store/graphics/play-icon-512.png`
- **Feature graphic** 1024 × 500: `docs/store/graphics/play-feature-graphic-1024x500.png`
- **Phone screenshots** 1242 × 2208: `Google Play - phone/` in `elderly-care-store-screenshots.zip`. Upload 4 to 8.
- **Tablet screenshots** are optional. You can reuse the iPad ones.

## App content (Policy → App content)

| Section | Answer |
|---|---|
| Privacy policy | The URL above |
| Ads | No, the app has no ads |
| App access | All functionality is available without special access |
| Content rating | Fill in the IARC questionnaire honestly: no violence, sex, drugs, gambling or user-to-user content. It should come out as the lowest rating. |
| Target audience | 18 and over. The app isn't designed for children. |
| News app | No |
| Health apps | Choose **Medication and treatment management** and **Health and fitness tracking**. It doesn't provide clinical decision support or diagnosis, and it isn't a regulated medical device. |
| Government app | No |
| Financial features | None |
| Data safety | See below |

## Data safety

Google counts any data that leaves the device, even briefly, so the answers differ slightly from Apple's.

- **Does your app collect or share any of the required user data types?** → **Yes**, because of the hospital search.
- **Is all user data encrypted in transit?** → Yes. The hospital search and Jitsi use HTTPS.
- **Do you provide a way for users to request that their data be deleted?** → Yes. All data is on the device: My profile → Erase all my data, or uninstall the app.

| Data type | Collected | Shared | Processed ephemerally | Required or optional | Purpose |
|---|---|---|---|---|---|
| Location → Precise location | Yes | No* | **Yes** | Optional | App functionality (find nearby hospitals) |

\* Google's form doesn't count a transfer the user starts themselves, and expects to happen, as sharing. Here the user opens "Hospitals nearby", or taps "Alert my family", which opens Messages for them to send.

Don't declare health info, contacts, photos, messages, app activity or device IDs. They never leave the device unless the user shares them themselves, for example by sending a PDF to their doctor through WhatsApp.

If Google later says the declared practices don't match what the app does, compare against this table and the privacy policy's section 7.

## Permissions to expect questions about

- **SCHEDULE_EXACT_ALARM** (on-time medicine reminders): allowed because reminders are the app's core function. The user grants it in the app ("Allow on-time reminders"). No declaration form is needed for this permission. (USE_EXACT_ALARM, which does need one, isn't used.)
- **ACCESS_FINE_LOCATION / ACCESS_COARSE_LOCATION:** only used while the app is open, never in the background, so no background location declaration is needed.
- **POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, USE_BIOMETRIC, INTERNET:** standard. No declarations needed.

## Testing before production (new personal accounts)

Personal developer accounts created after November 2023 must run a **closed test with at least 12 testers, opted in for at least 14 days in a row**, before they can apply for production access. Organisation accounts don't have this requirement.

1. Testing → Closed testing → create a track and upload the `.aab` built by the "Elderly Care release (Google Play)" workflow.
2. Add testers by email list or Google Group. Ideally include older people, since they are the real audience.
3. Ask them to actually use it: add a medicine, answer a reminder, try "I need help". Google looks at engagement.
4. After 14 days, apply for production in the Dashboard. Google asks a few questions about the test.

Testers on a closed track don't pay. A paid app is free on testing tracks.
