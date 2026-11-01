# Privacy policy

Version {{legal_version}} · Effective {{effective_date}}

This policy explains how personal information is handled when you use the Elderly Care app on a phone, tablet or in a web browser (the "App"). It is written to meet the Protection of Personal Information Act 4 of 2013 ("POPIA") of South Africa and, for people in Europe and the United Kingdom, the General Data Protection Regulation ("GDPR").

## The short version

- Your information stays on your device. There is no account, no sign-in and no company server.
- Your health information is encrypted on your device.
- We, the publisher, never receive, see or store your information.
- Some features use outside services, but only when you use them, and only with the minimum needed: the hospital search sends your location to OpenStreetMap, and video calls use Jitsi Meet.
- There is no advertising, no analytics, no tracking and no selling of data.
- You can see, change, export and delete everything at any time.

## 1. Who is responsible

The App is published by {{publisher_name}} ({{publisher_legal_status}}), {{publisher_address}} ("we", "us").

- Information Officer: {{information_officer}}
- Email: {{contact_email}}
- Telephone: {{contact_phone}}

**An important point about our role.** The App is designed so that we do not collect or process your personal information on our own systems at all. Your information is processed on your own device, by the App, under your control. Where you use the App for your own or your household's purposes, POPIA (section 6(1)(a)) generally does not apply to that personal use. We nevertheless explain everything here in full, and we accept responsibility, as the party that decides how the App works, for designing it to protect your information.

## 2. What information the App handles

The App only holds what you type in, choose or add yourself:

- **About you:** name, phone number, email address, age, gender, height, weight, blood group, usual blood pressure and blood sugar, allergies, medical conditions, and the emergency number you choose.
- **Medicines:** names, type, dose, reminder times, doses left, and whether you took each dose and when.
- **Appointments:** doctor, type of doctor, place, date and time, notes, and whether you attended.
- **Health readings:** blood pressure and pulse, blood sugar, weight and sleep, with dates and notes.
- **Notes and documents:** your notes, and photos of documents you choose to save (for example prescriptions or test results). Photos are reduced in size and stored inside the App, not in your phone's photo gallery.
- **Family and contacts:** names, relationship, phone numbers and email addresses of people you add.
- **Settings:** text size, whether you have seen the introduction, app-lock settings, the number of wrong PIN attempts, which version of these documents you accepted and when, and a random name for your private video-call room.
- **Your PIN:** the App never stores your PIN itself, only a scrambled one-way value ("salted hash") that lets it check your PIN.

Some of this is **special personal information** under POPIA (section 26) and "special category" data under the GDPR (Article 9), because it concerns your health. It is handled with the extra protection described in section 6 below.

**Information about other people.** If you add family members or other contacts, you are storing their personal information. Please only do so with their permission or another lawful reason, and tell them that you have added them as emergency contacts.

## 3. What the App does not collect

- No account, username or password with us.
- No analytics, usage statistics, advertising identifiers or tracking of any kind.
- No crash reports sent to us. (Your phone's maker or app store may collect crash and usage information if you allowed this in your phone's settings; their own privacy policies apply.)
- No contacts list, call history, messages, photo gallery or files from your phone, except a photo or backup file that you choose yourself.
- No location in the background. Your location is only read at the moment you use the hospital search or "Alert my family".
- No fingerprint or face data. Fingerprint and face unlock are handled entirely by your phone's operating system. The App only receives a yes or no.

## 4. Why the information is processed

Each piece of information is used only for the feature you use it with:

- to remind you about medicines and appointments, and to keep a record of doses taken;
- to show your readings and charts and create health summaries **when you ask** for one;
- to show your Medical ID;
- to call or send messages to the people you choose, **when you tap** to do so;
- to find hospitals near you, **when you open** the hospital search;
- to start a video call, **when you start** one;
- to make a backup, **when you ask** for one;
- to protect the App with your PIN or fingerprint/face, if you turn this on.

The information is never used for marketing, profiling or automated decisions about you.

## 5. Lawful basis

- **Consent and your request (POPIA sections 11(1)(a) and 27(1)(a); GDPR Articles 6(1)(a) and 9(2)(a)).** You choose to enter your information and to use each feature. You can withdraw consent at any time by deleting the information or the App.
- **Performing what you asked for (POPIA section 11(1)(b); GDPR Article 6(1)(b)).** For example, sending your location to the hospital search because you asked to find hospitals.
- **Your vital interests (POPIA section 11(1)(d); GDPR Article 6(1)(d)),** where you use the emergency features to get help.

## 6. Where your information is kept and how it is protected (POPIA section 19)

- **Only on your device.** On phones, in the App's private storage, which other apps cannot read. In a web browser, in that browser's storage for the App's website.
- **Encryption.** Your health and personal information is encrypted with AES-256-GCM. The key is created at random on your device and is kept in your device's secure key storage (Android Keystore, Apple Keychain, or the browser's Web Crypto). The key never leaves your device and is never sent to us.
- **Browsers without secure storage.** If a browser cannot provide secure storage (for example when the website is not opened over a secure "https" connection), the App cannot encrypt your information, and it tells you so under Privacy & security.
- **App lock.** You can protect the App with a 4 to 8 digit PIN and, on many phones, fingerprint or face unlock. After 5 wrong PINs, each new try is delayed (from 30 seconds, doubling up to 15 minutes). The App locks when opened and after 2 minutes in the background. While locked, its content is hidden. You can choose whether the Medical ID and an emergency call button remain available on the lock screen.
- **No automatic cloud copy.** The App asks Android not to copy its data to cloud backups or to a new phone. On Apple devices, your iCloud or device backup settings apply to the App's storage, and the encryption key itself is held in the Keychain.
- **Notifications** are marked private, so medicine and doctor names are hidden on a locked phone screen if your phone is set to hide sensitive content.
- **Logs.** The App does not write phone numbers, messages or health information to the device's system logs.
- **Backups** are only made when you ask, and you can protect them with a password (PBKDF2 with 210,000 rounds and AES-256-GCM). A restore checks the whole file before changing anything.
- **Web version.** The website only runs code from itself and only connects to the services described in this policy.

No system is perfectly secure. Keep your phone updated, use a screen lock, and keep your PIN and backup password private.

## 7. When information leaves your device

Information leaves your device only in these situations, and only when you use the feature:

- **Hospital search.** Your current location (latitude and longitude) is sent to OpenStreetMap's Overpass service to search for hospitals and clinics within 10 km. No name or other detail about you is sent. Like any website, the service also receives your internet (IP) address. The service is run by volunteers and organisations for OpenStreetMap, and its own privacy policy applies.
- **Directions.** Tapping "Directions" opens Google Maps (or your maps app) with the hospital's location. Google's privacy policy applies to what you do there.
- **Calls and text messages.** "Call", "Text", "Alert my family", missed-dose messages and the video-call link open your phone's own Phone or Messages app with the number and text filled in. Nothing is sent until you press send. Messages go through your mobile network to the people you chose. "Alert my family" can include a Google Maps link to your current location; anyone who opens that link sends that location to Google.
- **Video calls.** Calls use Jitsi Meet (meet.jit.si), a free service operated by a third party. The room has a long random name with no personal details. Your name is shown to the people in the call, and the service receives your IP address and the audio and video of the call. Jitsi's own privacy policy applies.
- **Sharing.** When you share a health summary (as text or PDF) or a backup, it goes to the app or person you choose, such as email, WhatsApp or a cloud drive. Their privacy policies apply.
- **Read aloud** uses your device's or browser's own voice. Some voices, especially in web browsers, may process the text online through the browser or phone maker's service.
- **Web version only.** If a character cannot be shown with the fonts built into the App, your browser may download a font from Google Fonts (fonts.gstatic.com), which receives your IP address.

## 8. Transfers outside South Africa (POPIA section 72)

The hospital search, video-call and font services above, and services you choose to share with, may have servers outside South Africa, for example in the European Union or the United States. Only the minimum information described above is transferred, and only because you asked for the feature. By using these features you consent to this transfer. We do not transfer any of your information ourselves.

## 9. How long information is kept

- Information stays on your device until you delete it, erase all data in the App, or uninstall the App. Uninstalling deletes everything the App stored on the device.
- If you forget your PIN, the only way back in is to erase all data.
- Backup files you make are kept wherever you put them, for as long as you keep them.
- Third-party services keep information according to their own policies.
- We keep nothing, because we receive nothing.

## 10. Your rights

Under POPIA (sections 5, 11(3), 23, 24, 69, 71 and 74) and, where it applies, the GDPR, you have the right to:

- know whether personal information about you is held, and to access it;
- have it corrected or deleted;
- object to its processing;
- not receive direct marketing (the App sends none);
- not be subject to decisions based only on automated processing (the App makes none);
- data portability (you can export everything with "Back up my data");
- withdraw consent at any time;
- complain to the Information Regulator.

**How to use your rights.** Because your information is only on your device, you can exercise most of these rights yourself, at any time: view and edit everything in the App, delete single items, export with "Back up my data", or erase everything under My profile, "Erase all my data". We cannot do this for you, because we cannot see or reach your information. For questions or requests, contact our Information Officer at {{contact_email}}.

## 11. Security incidents (POPIA section 22)

Because we hold none of your information, a breach of our systems cannot expose it. If we learn of a weakness in the App that could put users' information at risk, we will fix it, release an update, inform users through the App and the app store listing, and notify the Information Regulator where the law requires.

## 12. Children

The App is meant for adults. It is not directed at children under 18, and we do not knowingly collect children's information. A parent or guardian may help someone younger use it.

## 13. Access to information (PAIA)

Our manual under the Promotion of Access to Information Act 2 of 2000 is available on request from {{contact_email}}.

## 14. Complaints

Please contact us first at {{contact_email}} so that we can help. You also have the right to lodge a complaint with the **Information Regulator (South Africa)**:

- Website: www.inforegulator.org.za
- Complaints email: POPIAComplaints@inforegulator.org.za
- General enquiries: enquiries@inforegulator.org.za

People in the European Union or the United Kingdom may also complain to their local data protection authority.

## 15. Changes to this policy

If this policy changes, the version number and date at the top will change, and the App will show you the new policy and ask you to accept the updated documents before you continue.
