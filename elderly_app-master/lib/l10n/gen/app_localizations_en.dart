// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Elderly Care';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonDone => 'Done';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonCall => 'Call';

  @override
  String get commonText => 'Text';

  @override
  String get commonShare => 'Share';

  @override
  String get commonToday => 'Today';

  @override
  String get commonTomorrow => 'Tomorrow';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get commonReadAloud => 'Read aloud';

  @override
  String get commonStopReading => 'Stop reading';

  @override
  String get commonReadMedicalDisclaimer => 'Read the medical disclaimer';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSystem => 'Same as my phone';

  @override
  String get languageReviewNote =>
      'This translation is new. If something reads oddly, please tell us so we can improve it.';

  @override
  String get languageEnglishOnlyNote =>
      'The legal documents and the summaries for your doctor are in English.';

  @override
  String get featureMedicines => 'Medicines';

  @override
  String get featureMedicinesSubtitle => 'Reminders & doses';

  @override
  String get featureAppointments => 'Appointments';

  @override
  String get featureAppointmentsSubtitle => 'Doctor visits';

  @override
  String get featureHealth => 'Health tracker';

  @override
  String get featureHealthSubtitle => 'BP, sugar, weight, sleep';

  @override
  String get featureFamily => 'My family';

  @override
  String get featureFamilySubtitle => 'Call, text & alert';

  @override
  String get featureHospitals => 'Hospitals nearby';

  @override
  String get featureHospitalsSubtitle => 'Find & get directions';

  @override
  String get featureVideoCall => 'Video call';

  @override
  String get featureVideoCallSubtitle => 'See your family';

  @override
  String get featureDocuments => 'Documents';

  @override
  String get featureDocumentsSubtitle => 'Prescriptions & reports';

  @override
  String get featureNotes => 'Notes';

  @override
  String get featureNotesSubtitle => 'Things to remember';

  @override
  String get medicineTypeTablet => 'Tablet';

  @override
  String get medicineTypeCapsule => 'Capsule';

  @override
  String get medicineTypeSyrup => 'Syrup';

  @override
  String get medicineTypeDrops => 'Drops';

  @override
  String get medicineTypeInjection => 'Injection';

  @override
  String get medicineTypeInhaler => 'Inhaler';

  @override
  String get medicineTypeOther => 'Other';

  @override
  String get trackerBloodPressure => 'Blood pressure';

  @override
  String get trackerBloodPressureTip => 'Healthy range is below 120/80 mmHg.';

  @override
  String get trackerBloodSugar => 'Blood sugar';

  @override
  String get trackerBloodSugarTip =>
      'Fasting levels of 70–100 mg/dL are typical.';

  @override
  String get trackerWeight => 'Weight';

  @override
  String get trackerWeightTip => 'Weigh yourself at the same time each day.';

  @override
  String get trackerSleep => 'Sleep';

  @override
  String get trackerSleepTip => 'Most adults need 7–8 hours of sleep.';

  @override
  String get trackerFieldSystolic => 'Systolic (top number)';

  @override
  String get trackerFieldDiastolic => 'Diastolic (bottom number)';

  @override
  String get trackerFieldPulse => 'Pulse';

  @override
  String get trackerFieldGlucose => 'Blood glucose';

  @override
  String get trackerFieldWeight => 'Weight';

  @override
  String get trackerFieldHours => 'Hours slept';

  @override
  String get trackerFieldMinutes => 'Extra minutes';

  @override
  String trackerSleepValue(num hours, num minutes) {
    return '$hours h $minutes min';
  }

  @override
  String notifyDoseTitle(String medicine) {
    return 'Time for $medicine';
  }

  @override
  String get notifyDoseBody => 'Tap \"Taken\" once you have taken it.';

  @override
  String notifyDoseBodyWithDosage(String dosage) {
    return 'Take $dosage, then tap \"Taken\".';
  }

  @override
  String notifyFollowUpTitle(String medicine) {
    return 'Did you take your $medicine?';
  }

  @override
  String notifyFollowUpBody(String time) {
    return 'It was due at $time. Let us know so your record stays right.';
  }

  @override
  String get notifySnoozeBody => 'Reminding you again, as you asked.';

  @override
  String get notifyAppointmentTitle => 'Appointment in 1 hour';

  @override
  String get notifyActionTaken => 'Taken';

  @override
  String get notifyActionSnooze => 'In 10 min';

  @override
  String get notifyActionNotYet => 'Not yet';

  @override
  String get notifyMedicineChannel => 'Medicine reminders';

  @override
  String get notifyMedicineChannelDescription =>
      'Reminds you when it is time to take a medicine';

  @override
  String get notifyAppointmentChannel => 'Appointment reminders';

  @override
  String get notifyAppointmentChannelDescription =>
      'Reminds you an hour before a doctor appointment';

  @override
  String get languageChoose => 'Choose a language';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileNotSet => 'Not set';

  @override
  String get profileShowMedicalId => 'Show my medical ID';

  @override
  String get profileContact => 'Contact';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmergencyNumber => 'Emergency number';

  @override
  String get profileMedicalDetails => 'Medical details';

  @override
  String get profileAge => 'Age';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileBloodGroup => 'Blood group';

  @override
  String get profileHeight => 'Height';

  @override
  String get profileWeight => 'Weight';

  @override
  String get profileUsualBloodPressure => 'Usual blood pressure';

  @override
  String get profileUsualBloodSugar => 'Usual blood sugar';

  @override
  String get profileAllergies => 'Allergies';

  @override
  String get profileConditions => 'Medical conditions';

  @override
  String get profileTextSize => 'Text size';

  @override
  String get profileBackup => 'Backup';

  @override
  String get profileThisApp => 'This app';

  @override
  String get profilePrivacySecurity => 'Privacy & security';

  @override
  String get profileAppLockOn => 'App lock is on';

  @override
  String get profileSetPinHint => 'Set a PIN, see how your data is protected';

  @override
  String get profileLegalAbout => 'Legal & about';

  @override
  String get profileLegalAboutSubtitle =>
      'Terms, medical disclaimer, privacy, licences';

  @override
  String get profileEraseAll => 'Erase all my data';

  @override
  String get profileEraseTitle => 'Erase everything?';

  @override
  String get profileEraseMessage =>
      'All medicines, appointments, readings, notes, documents and family contacts will be deleted. This cannot be undone.';

  @override
  String get profileEraseConfirm => 'Erase';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSave => 'Save profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileNameRequired => 'Please enter your name';

  @override
  String get profileEmergencyNumberHint => '112 works from any mobile phone';

  @override
  String get profileEmergencyNumberRequired =>
      'Please enter an emergency number';

  @override
  String get profileBloodGroupHint => 'e.g. O+';

  @override
  String get profileBloodPressureHint => 'e.g. 120/80';

  @override
  String get profileBloodSugarHint => 'e.g. Normal';

  @override
  String get profileAllergiesHint => 'e.g. Penicillin';

  @override
  String get profileConditionsHint =>
      'e.g. Type 2 diabetes, high blood pressure';

  @override
  String get profileTextSizeNormal => 'Normal';

  @override
  String get profileTextSizeLarge => 'Large';

  @override
  String get profileTextSizeExtraLarge => 'Extra large';

  @override
  String get profileTextSizeExplain =>
      'Makes all writing in the app bigger. It adds to your phone\'s own text size.';

  @override
  String get backupProtectTitle => 'Protect your backup?';

  @override
  String get backupProtectMessage =>
      'The backup holds your health details. A password keeps them private if the file ends up in the wrong hands. Write it down: without it the backup cannot be opened.';

  @override
  String get backupPasswordLabel => 'Backup password';

  @override
  String get backupNoPassword => 'No password';

  @override
  String get backupUsePassword => 'Use password';

  @override
  String get backupShareSubject => 'Elderly Care backup';

  @override
  String get backupReady =>
      'Backup ready. Keep it somewhere safe, like your email or cloud storage.';

  @override
  String get backupFailed => 'Could not create the backup.';

  @override
  String get backupRestoreTitle => 'Restore from a backup?';

  @override
  String get backupRestoreMessage =>
      'Everything currently in the app will be replaced by what is in the backup file.';

  @override
  String get backupChooseFile => 'Choose file';

  @override
  String get backupCouldNotReadFile => 'Could not read that file.';

  @override
  String get backupProtectedMessage =>
      'This backup is protected. Enter the password you chose when you made it.';

  @override
  String get backupWrongPasswordRetry =>
      'That password is not right. Please try again.';

  @override
  String get backupPasswordTitle => 'Backup password';

  @override
  String get backupPassword => 'Password';

  @override
  String get backupRestore => 'Restore';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get backupBackUp => 'Back up my data';

  @override
  String get backupBackUpSubtitle =>
      'Save everything to a file you can email to yourself or keep in the cloud.';

  @override
  String get backupRestoreFrom => 'Restore from a backup';

  @override
  String get backupRestoreFromSubtitle =>
      'Use this on a new phone to get your data back.';

  @override
  String get backupErrorNotBackup => 'This file is not an Elderly Care backup.';

  @override
  String get backupErrorTooLarge => 'This file is too large to be a backup.';

  @override
  String get backupErrorDamaged =>
      'This backup is damaged and could not be read.';

  @override
  String get backupErrorNoProfile => 'This backup has no profile in it.';

  @override
  String get backupErrorUnknownProtection =>
      'This backup uses an unknown protection method.';

  @override
  String get securityTitle => 'Privacy & security';

  @override
  String get securityWrongPin => 'That PIN is not right.';

  @override
  String get securityTooManyAttempts =>
      'Too many wrong tries. Please wait a little and try again.';

  @override
  String get securityChoosePin => 'Choose a PIN';

  @override
  String get securityChoosePinMessage =>
      'You will type this PIN to open Elderly Care. Use 4 to 8 numbers that others would not guess.';

  @override
  String get securityNewPin => 'New PIN';

  @override
  String get securityPinUnavailable =>
      'This device cannot store a PIN securely, so app lock is not available here.';

  @override
  String get securityAppLockOn => 'App lock is on';

  @override
  String get securityAppLockOff => 'App lock is off';

  @override
  String get securityEnterCurrentPin => 'Enter your current PIN.';

  @override
  String get securityCurrentPin => 'Current PIN';

  @override
  String get securityChangePin => 'Change PIN';

  @override
  String get securityTurnOffAppLock => 'Turn off app lock';

  @override
  String get securityAppLock => 'App lock';

  @override
  String get securityAppLockOnDetail =>
      'The app asks for your PIN when it opens, and after 2 minutes away.';

  @override
  String get securityAppLockOffDetail =>
      'Anyone holding your phone can see your health details. A PIN keeps them private.';

  @override
  String get securityLockNow => 'Lock now';

  @override
  String get securityTurnOff => 'Turn off';

  @override
  String get securityLockWithPin => 'Lock with a PIN';

  @override
  String get securityBiometrics => 'Unlock with fingerprint or face';

  @override
  String get securityMedicalIdWhenLocked => 'Show Medical ID when locked';

  @override
  String get securityMedicalIdWhenLockedDetail =>
      'Lets paramedics see your allergies and medicines and call for help without your PIN.';

  @override
  String get securityHowProtected => 'How your information is protected';

  @override
  String get securityEncrypted => 'Encrypted on this device';

  @override
  String get securityNotEncrypted => 'Not encrypted on this device';

  @override
  String get securityEncryptedDetail =>
      'Your health details are scrambled with a key kept in this device\'s secure storage.';

  @override
  String get securityNotEncryptedDetail =>
      'This browser has no secure storage. Use the phone app, or open the website over https.';

  @override
  String get securityLocalOnly => 'Kept only on this device';

  @override
  String get securityLocalOnlyDetail =>
      'There is no account and no server. Nothing is uploaded, and there are no ads or tracking.';

  @override
  String get securitySharedByChoice => 'Only shared when you choose';

  @override
  String get securitySharedByChoiceDetail =>
      'Calls and texts go through your own phone. Health summaries and backups only leave the app when you send them.';

  @override
  String get securityHospitalSearch => 'Hospital search';

  @override
  String get securityHospitalSearchDetail =>
      'To find hospitals, your location is sent to the free OpenStreetMap service. Nothing else about you is sent.';

  @override
  String get securityVideoCalls => 'Video calls';

  @override
  String get securityVideoCallsDetail =>
      'Calls use the free Jitsi Meet service in a private room with a long random name. Only people you send the link to can join.';

  @override
  String get securityNoCloudCopy => 'No automatic cloud copy';

  @override
  String get securityNoCloudCopyDetail =>
      'The phone does not copy this app\'s data to the cloud. Use \"Back up my data\" in My profile, ideally with a password.';

  @override
  String get securityReadPrivacyPolicy => 'Read the full privacy policy';

  @override
  String get securityEraseAnyTime =>
      'You can erase everything at any time in My profile.';

  @override
  String get medicalIdTitle => 'Medical ID';

  @override
  String get medicalIdFooter => 'Keep your details up to date in My profile.';

  @override
  String get medicalIdNotRecorded => 'Not recorded';

  @override
  String get medicalIdAge => 'Age';

  @override
  String get medicalIdBloodGroup => 'Blood group';

  @override
  String get medicalIdAllergies => 'Allergies';

  @override
  String get medicalIdConditions => 'Medical conditions';

  @override
  String get medicalIdMedicines => 'Medicines';

  @override
  String get medicalIdEmergencyContacts => 'Emergency contacts';

  @override
  String medicalIdCallContact(String name) {
    return 'Call $name';
  }

  @override
  String medicalIdSpeakTitle(String name) {
    return 'Medical ID for $name.';
  }

  @override
  String medicalIdSpeakAge(String age) {
    return 'Age $age.';
  }

  @override
  String medicalIdSpeakBloodGroup(String group) {
    return 'Blood group $group.';
  }

  @override
  String get medicalIdSpeakNoAllergies => 'No allergies recorded.';

  @override
  String medicalIdSpeakAllergies(String allergies) {
    return 'Allergies: $allergies.';
  }

  @override
  String medicalIdSpeakConditions(String conditions) {
    return 'Medical conditions: $conditions.';
  }

  @override
  String medicalIdSpeakMedicines(String medicines) {
    return 'Medicines: $medicines.';
  }

  @override
  String medicalIdSpeakContact(String name, String phone) {
    return 'Emergency contact: $name, $phone.';
  }

  @override
  String medicalIdSpeakContactWithRelationship(
    String name,
    String relationship,
    String phone,
  ) {
    return 'Emergency contact: $name, $relationship, $phone.';
  }

  @override
  String get secretOk => 'OK';

  @override
  String secretMinDigits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Use at least $count numbers',
      one: 'Use at least 1 number',
    );
    return '$_temp0';
  }

  @override
  String secretMinCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Use at least $count characters',
      one: 'Use at least 1 character',
    );
    return '$_temp0';
  }

  @override
  String get secretTypeAgain => 'Type it again';

  @override
  String get secretNoMatch => 'The two do not match';

  @override
  String get secretShowPin => 'Show PIN';

  @override
  String get secretShowPassword => 'Show password';

  @override
  String get homeMyProfile => 'My profile';

  @override
  String homeGreeting(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeWhatToDo => 'What would you like to do?';

  @override
  String get homeSosTitle => 'I need help';

  @override
  String get homeSosSubtitle => 'Call for help or alert your family';

  @override
  String get homeNoMedicines => 'No medicines yet';

  @override
  String get homeNoMedicinesHint => 'Add one to get reminders';

  @override
  String get homeAllMedicinesDone => 'All medicines done for today';

  @override
  String homeDosesTaken(int taken, int total) {
    return '$taken of $total taken';
  }

  @override
  String homeTimeFor(String medicine) {
    return 'Time for $medicine';
  }

  @override
  String homeNextMedicine(String medicine) {
    return 'Next: $medicine';
  }

  @override
  String get homeCheckDose => 'Check';

  @override
  String homeRefillSoon(String medicine) {
    return 'Refill $medicine soon';
  }

  @override
  String homeDosesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Only $count doses left',
      one: 'Only 1 dose left',
    );
    return '$_temp0';
  }

  @override
  String homeAppointmentWhen(String day, String time) {
    return '$day at $time';
  }

  @override
  String homeSpokenGreeting(String greeting, String name) {
    return '$greeting, $name.';
  }

  @override
  String homeSpokenToday(String date) {
    return 'Today is $date.';
  }

  @override
  String get homeSpokenNoMedicines => 'You have no medicines set up.';

  @override
  String get homeSpokenAllTaken =>
      'You have taken all your medicines for today.';

  @override
  String homeSpokenDoseDue(String medicine, String time) {
    return 'It is time for $medicine at $time.';
  }

  @override
  String homeSpokenDoseDueWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'It is time for $medicine, $dosage, at $time.';
  }

  @override
  String homeSpokenDoseNext(String medicine, String time) {
    return 'Your next medicine is $medicine at $time.';
  }

  @override
  String homeSpokenDoseNextWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'Your next medicine is $medicine, $dosage, at $time.';
  }

  @override
  String homeSpokenRefill(String medicine) {
    return 'Remember to refill $medicine soon.';
  }

  @override
  String homeSpokenAppointment(String doctor, String day, String time) {
    return 'Your next appointment is with $doctor, $day at $time.';
  }

  @override
  String get lockEnterPin => 'Enter your PIN';

  @override
  String get lockPinTooShort => 'Your PIN has at least 4 numbers.';

  @override
  String lockPinWrong(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left tries left',
      one: '1 try left',
    );
    return 'That PIN is not right. $_temp0 before a short wait.';
  }

  @override
  String get lockTooManyTries => 'Too many wrong tries.';

  @override
  String lockWait(String time) {
    return 'Too many wrong tries. Try again in $time.';
  }

  @override
  String lockPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count numbers entered',
      one: '1 number entered',
    );
    return '$_temp0';
  }

  @override
  String get lockUseBiometrics => 'Use fingerprint or face';

  @override
  String get lockEmergency => 'Emergency';

  @override
  String get lockForgotPin => 'Forgot PIN?';

  @override
  String lockCallNumber(String number) {
    return 'Call $number';
  }

  @override
  String get lockMedicalIdHidden =>
      'The Medical ID is hidden while the app is locked.';

  @override
  String get lockForgotTitle => 'Forgot your PIN?';

  @override
  String get lockForgotBody =>
      'For your privacy the PIN cannot be recovered. You can erase everything in the app and start again. If you made a backup, you can restore it afterwards from My profile.';

  @override
  String get lockEraseEverything => 'Erase everything and start again';

  @override
  String get lockEraseConfirm => 'Yes, erase everything';

  @override
  String get lockEraseWarning => 'This cannot be undone. Tap again to confirm.';

  @override
  String get lockKeyDelete => 'Delete';

  @override
  String get lockKeyUnlock => 'Unlock';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingMedicinesTitle => 'Never miss a medicine';

  @override
  String get onboardingMedicinesText =>
      'Get a reminder when each dose is due, and let your family know if one is missed.';

  @override
  String get onboardingAppointmentsTitle => 'Remember appointments';

  @override
  String get onboardingAppointmentsText =>
      'Keep your doctor visits in one place and get a reminder an hour before.';

  @override
  String get onboardingHealthTitle => 'Track your health';

  @override
  String get onboardingHealthText =>
      'Record blood pressure, blood sugar, weight and sleep, and see how they change.';

  @override
  String get onboardingHospitalsTitle => 'Find help nearby';

  @override
  String get onboardingHospitalsText =>
      'See the closest hospitals and clinics with directions and phone numbers.';

  @override
  String get onboardingFamilyTitle => 'Family is one tap away';

  @override
  String get onboardingFamilyText =>
      'Call, text or video call your family, or send them your location in an emergency.';

  @override
  String get setupWelcome => 'Welcome to Elderly Care';

  @override
  String get setupIntro =>
      'Just a few details to get you started. Everything stays on this phone.';

  @override
  String get setupAboutYou => 'About you';

  @override
  String get setupYourName => 'Your name';

  @override
  String get setupNameRequired => 'Please enter your name';

  @override
  String get setupYourPhone => 'Your phone number (optional)';

  @override
  String get setupEmergencyContact => 'Emergency contact';

  @override
  String get setupEmergencyContactInfo =>
      'Someone we can call or text for you when you need help.';

  @override
  String get setupTheirName => 'Their name';

  @override
  String get setupRelationship => 'Relationship';

  @override
  String get setupRelationshipHint => 'e.g. Daughter';

  @override
  String get setupTheirPhone => 'Their phone number';

  @override
  String get setupTheirPhoneRequired => 'Please enter their phone number';

  @override
  String get setupAddMoreLater => 'You can add more family members later.';

  @override
  String get legalDocTerms => 'Terms of Use';

  @override
  String get legalDocMedical => 'Medical disclaimer';

  @override
  String get legalDocPrivacy => 'Privacy policy';

  @override
  String get legalDocAccessibility => 'Accessibility statement';

  @override
  String get legalDocCredits => 'Credits and third-party notices';

  @override
  String get legalReadTerms => 'Read the terms of use';

  @override
  String get legalReadPrivacy => 'Read the privacy policy';

  @override
  String get legalEnglishOnly =>
      'This document is available in English only. The English version is the binding one.';

  @override
  String get legalHubTitle => 'Legal & about';

  @override
  String get legalOpenSourceLicences => 'Open-source licences';

  @override
  String legalAppVersion(String version) {
    return 'Elderly Care, version $version';
  }

  @override
  String legalVersion(String version) {
    return 'Version $version';
  }

  @override
  String legalAcceptedOn(int version, String date) {
    return 'You accepted version $version of these documents on $date.';
  }

  @override
  String get legalAgree =>
      'I agree to the Terms of Use, and I have read the Medical disclaimer and the Privacy policy';

  @override
  String get legalTickBox => 'Please tick the box to continue.';

  @override
  String get legalNotMedicalService =>
      'Elderly Care is not a medical service. In an emergency, call 112.';

  @override
  String get legalReviewTitle => 'Please review our terms';

  @override
  String get legalUpdatedTitle => 'Our terms have been updated';

  @override
  String legalUpdateBody(int version, String date) {
    return 'Before you continue, please read and accept the Terms of Use, the Medical disclaimer and the Privacy policy (version $version, effective $date). Your information stays on this device.';
  }

  @override
  String get medicinesTitle => 'Medicines';

  @override
  String get medicinesAdd => 'Add medicine';

  @override
  String get medicinesEmptyTitle => 'No medicines yet';

  @override
  String get medicinesEmptyMessage =>
      'Add your medicines and we will remind you when each dose is due.';

  @override
  String get medicinesTodaySchedule => 'Today\'s schedule';

  @override
  String medicinesTakenToday(int taken, int total) {
    return '$taken of $total taken';
  }

  @override
  String get medicinesMine => 'My medicines';

  @override
  String medicinesTimesADay(int count) {
    return '$count× a day';
  }

  @override
  String get medicinesDisclaimer =>
      'Always take medicines as your doctor or pharmacist told you. Reminders can sometimes be late, so do not rely on them alone.';

  @override
  String medicinesSupplyLow(int count) {
    return 'Only $count doses left – time to refill';
  }

  @override
  String medicinesSupplyLeft(int count, int days) {
    return '$count doses left (about $days days)';
  }

  @override
  String medicinesLastWeek(int taken, int due) {
    return 'Last 7 days: $taken of $due doses taken';
  }

  @override
  String get medicinesLateTitle => 'Reminders may arrive late';

  @override
  String get medicinesLateMessage =>
      'Your phone is saving battery by delaying reminders. Allow Elderly Care to remind you at the exact time.';

  @override
  String get medicinesLateAllow => 'Allow on-time reminders';

  @override
  String get doseStatusTaken => 'Taken';

  @override
  String get doseStatusNotTaken => 'Not taken';

  @override
  String get doseStatusOverdue => 'Overdue';

  @override
  String get doseStatusDue => 'Due now';

  @override
  String get doseStatusLater => 'Later';

  @override
  String doseRowSubtitle(String time, String status) {
    return '$time · $status';
  }

  @override
  String get doseCheck => 'Check';

  @override
  String get doseCheckTitle => 'Medicine check';

  @override
  String doseCheckQuestion(String medicine) {
    return 'Did you take your $medicine?';
  }

  @override
  String doseCheckWhen(String day, String time) {
    return '$day at $time';
  }

  @override
  String get doseCheckYes => 'Yes, I took it';

  @override
  String get doseCheckNo => 'No, not yet';

  @override
  String get doseTellFamilyTitle => 'Let your family know?';

  @override
  String doseTellFamilyMessage(String names, String medicine) {
    return 'We can send a text to $names saying you missed your $medicine.';
  }

  @override
  String get doseTellFamilySend => 'Send text';

  @override
  String doseMissedSms(String name, String medicine, String time) {
    return '$name did not take $medicine ($time) today. Please check in.';
  }

  @override
  String doseMissedSmsNoName(String medicine, String time) {
    return 'I did not take $medicine ($time) today. Please check in.';
  }

  @override
  String doseRecordedTaken(String medicine) {
    return 'Well done! $medicine recorded.';
  }

  @override
  String doseRecordedNotTaken(String medicine) {
    return 'Noted. $medicine not taken.';
  }

  @override
  String doseTakenFromNotification(String medicine) {
    return '$medicine recorded as taken. Well done!';
  }

  @override
  String doseSnoozed(String medicine) {
    return 'We will remind you about $medicine again in 10 minutes.';
  }

  @override
  String get medicineEditTitle => 'Edit medicine';

  @override
  String get medicineEditSaveChanges => 'Save changes';

  @override
  String get medicineEditSaveNew => 'Save reminder';

  @override
  String get medicineEditDeleteTooltip => 'Delete medicine';

  @override
  String medicineEditDeleteTitle(String medicine) {
    return 'Delete $medicine?';
  }

  @override
  String get medicineEditDeleteMessage =>
      'You will no longer get reminders for this medicine.';

  @override
  String medicineEditReminderSet(String medicine) {
    return 'Reminder set for $medicine';
  }

  @override
  String medicineEditSaved(String medicine) {
    return 'Saved $medicine';
  }

  @override
  String get medicineEditNameLabel => 'Medicine name';

  @override
  String get medicineEditNameHint => 'e.g. Metformin';

  @override
  String get medicineEditNameRequired => 'Please enter the medicine name';

  @override
  String get medicineEditDosageLabel => 'How much (optional)';

  @override
  String get medicineEditDosageHint => 'e.g. 1 tablet, 500 mg';

  @override
  String get medicineEditSupplyLabel => 'Doses left in the pack (optional)';

  @override
  String get medicineEditSupplyHint => 'e.g. 30';

  @override
  String get medicineEditSupplyHelper =>
      'We will warn you when it is time to refill.';

  @override
  String get medicineEditSupplyInvalid => 'Please enter a whole number';

  @override
  String get medicineEditType => 'Type';

  @override
  String get medicineEditHowOften => 'How many times a day?';

  @override
  String get medicineEditOnce => 'Once';

  @override
  String get medicineEditTwice => 'Twice';

  @override
  String get medicineEditThreeTimes => '3 times';

  @override
  String get medicineEditAtWhatTimes => 'At what times?';

  @override
  String medicineEditDoseNumber(int number) {
    return 'Dose $number';
  }

  @override
  String medicineEditDoseTime(int number) {
    return 'Dose $number time';
  }

  @override
  String get medicineEditChange => 'Change';

  @override
  String get appointmentsTitle => 'Appointments';

  @override
  String appointmentsUpcomingTab(int count) {
    return 'Upcoming ($count)';
  }

  @override
  String appointmentsPastTab(int count) {
    return 'Past ($count)';
  }

  @override
  String get appointmentsAdd => 'Add appointment';

  @override
  String get appointmentsNoPast => 'No past appointments';

  @override
  String get appointmentsNoUpcoming => 'No upcoming appointments';

  @override
  String get appointmentsNoPastMessage =>
      'Appointments move here once they are over.';

  @override
  String get appointmentsNoUpcomingMessage =>
      'Add your next doctor visit and we will remind you an hour before.';

  @override
  String get appointmentsAttended => 'Attended';

  @override
  String get appointmentEditTitle => 'Appointment';

  @override
  String get appointmentEditNewTitle => 'New appointment';

  @override
  String get appointmentEditSaveChanges => 'Save changes';

  @override
  String get appointmentEditSaveNew => 'Save appointment';

  @override
  String get appointmentEditDeleteTooltip => 'Delete appointment';

  @override
  String get appointmentEditDeleteTitle => 'Delete appointment?';

  @override
  String appointmentEditDeleteMessage(String doctor) {
    return 'Your appointment with $doctor will be removed.';
  }

  @override
  String appointmentEditSaved(String doctor) {
    return 'Appointment with $doctor saved';
  }

  @override
  String get appointmentEditDoctorLabel => 'Doctor\'s name';

  @override
  String get appointmentEditDoctorHint => 'e.g. Dr. Naidoo';

  @override
  String get appointmentEditDoctorRequired => 'Please enter the doctor\'s name';

  @override
  String get appointmentEditSpecialtyLabel => 'Type of doctor (optional)';

  @override
  String get appointmentEditSpecialtyHint => 'e.g. Cardiologist';

  @override
  String get appointmentEditPlaceLabel => 'Where (optional)';

  @override
  String get appointmentEditPlaceHint => 'Hospital, clinic or home visit';

  @override
  String get appointmentEditWhen => 'When';

  @override
  String get appointmentEditChange => 'Change';

  @override
  String get appointmentEditNotesLabel => 'Notes (optional)';

  @override
  String get appointmentEditNotesHint => 'Questions to ask, things to bring…';

  @override
  String get appointmentEditAttended => 'I went to this appointment';

  @override
  String get notesTitle => 'Notes';

  @override
  String get notesNew => 'New note';

  @override
  String get notesEmptyTitle => 'No notes yet';

  @override
  String get notesEmptyMessage =>
      'Write down things to remember, questions for the doctor, or anything else.';

  @override
  String notesUpdated(String day) {
    return 'Updated $day';
  }

  @override
  String notesImportantUpdated(String day) {
    return 'Important · Updated $day';
  }

  @override
  String get noteEditTitle => 'Edit note';

  @override
  String get noteEditSave => 'Save note';

  @override
  String get noteEditSaved => 'Note saved';

  @override
  String get noteEditDeleteTooltip => 'Delete note';

  @override
  String get noteEditDeleteTitle => 'Delete this note?';

  @override
  String noteEditDeleteMessage(String title) {
    return '\"$title\" will be removed.';
  }

  @override
  String get noteEditTitleLabel => 'Title';

  @override
  String get noteEditTitleRequired => 'Please enter a title';

  @override
  String get noteEditBodyLabel => 'Note';

  @override
  String get noteEditHowImportant => 'How important is it?';

  @override
  String get noteEditImportant => 'Important';

  @override
  String get noteEditNormal => 'Normal';

  @override
  String get healthIntro =>
      'Keep a record of your readings, then tap Share to send your doctor a summary.';

  @override
  String get healthDisclaimer =>
      'Tips here are general information for adults, not medical advice. Ask your doctor what readings are right for you. If you feel very unwell, call 112.';

  @override
  String get healthNoReadings => 'No readings yet';

  @override
  String healthShareSubject(String name) {
    return 'Health summary for $name';
  }

  @override
  String get healthShareSubjectNoName => 'Health summary for me';

  @override
  String get healthShareTitle =>
      'Send your doctor a summary of the last 30 days';

  @override
  String get healthShareAsPdf => 'As a PDF document';

  @override
  String get healthShareAsPdfSubtitle => 'Neat tables, easy to print';

  @override
  String get healthShareAsText => 'As a message';

  @override
  String get healthShareAsTextSubtitle => 'Plain text for email or WhatsApp';

  @override
  String get trackingAddReading => 'Add reading';

  @override
  String get trackingFirstReading =>
      'Add your first reading to start tracking.';

  @override
  String get trackingOneMore => 'Add one more reading to see a chart.';

  @override
  String get trackingReadings => 'Readings';

  @override
  String get trackingDeleteReading => 'Delete reading';

  @override
  String get trackingDeleteReadingTitle => 'Delete reading?';

  @override
  String trackingDeleteReadingMessage(String reading, String day) {
    return '$reading on $day';
  }

  @override
  String trackingChartLabel(int count, String type, String latest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$type chart of the last $count readings. Latest $latest.',
    );
    return '$_temp0';
  }

  @override
  String trackingFieldRequired(String field) {
    return 'Please enter $field';
  }

  @override
  String get trackingEnterNumber => 'Please enter a number';

  @override
  String trackingOutOfRange(String min, String max) {
    return 'Should be between $min and $max';
  }

  @override
  String trackingReadingSaved(String type) {
    return '$type reading saved';
  }

  @override
  String get trackingSaveReading => 'Save reading';

  @override
  String trackingNewReadingTitle(String type) {
    return 'New $type reading';
  }

  @override
  String get trackingChangeTime => 'Change';

  @override
  String get trackingNotes => 'Notes (optional)';

  @override
  String get trackingNotesHint => 'e.g. after breakfast';

  @override
  String get documentTakePhoto => 'Take a photo';

  @override
  String get documentChooseFromGallery => 'Choose from gallery';

  @override
  String get documentPickFailed => 'Could not open the camera or gallery.';

  @override
  String get documentAdd => 'Add document';

  @override
  String get documentNoneTitle => 'No documents yet';

  @override
  String get documentNoneMessage =>
      'Take photos of prescriptions, test results and medical aid cards to keep them handy.';

  @override
  String get documentSearch => 'Search documents';

  @override
  String documentNoMatch(String query) {
    return 'Nothing matches \"$query\".';
  }

  @override
  String get documentSaved => 'Document saved';

  @override
  String get documentSave => 'Save document';

  @override
  String get documentName => 'Name';

  @override
  String get documentNameHint => 'e.g. Blood test March';

  @override
  String get documentNameRequired =>
      'Please enter a name so you can find it later';

  @override
  String get documentDelete => 'Delete document';

  @override
  String documentDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get documentDeleteMessage =>
      'This photo will be removed from the app.';

  @override
  String get hospitalRefresh => 'Refresh';

  @override
  String hospitalEmergencyCall(String number) {
    return 'Emergency? Call $number';
  }

  @override
  String get hospitalSearching => 'Looking for hospitals near you…';

  @override
  String get hospitalSearchFailed => 'Could not search';

  @override
  String get hospitalCheckInternet =>
      'Please check your internet connection and try again.';

  @override
  String get hospitalTryAgain => 'Try again';

  @override
  String get hospitalNoneFound => 'None found within 10 km';

  @override
  String get hospitalNoneFoundMessage =>
      'In an emergency, call the number above.';

  @override
  String hospitalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places within 10 km',
      one: '1 place within 10 km',
    );
    return '$_temp0';
  }

  @override
  String get hospitalListNote =>
      'This list comes from OpenStreetMap and may be incomplete or out of date. Not every place has an emergency unit: phone first if you can.';

  @override
  String get hospitalAttribution => 'Data © OpenStreetMap contributors';

  @override
  String hospitalDistanceMeters(int meters) {
    return '$meters m away';
  }

  @override
  String hospitalDistanceKm(String km) {
    return '$km km away';
  }

  @override
  String get hospitalDirections => 'Directions';

  @override
  String get sosTitle => 'How can we help?';

  @override
  String get sosCallEmergency => 'Call emergency services';

  @override
  String sosDial(String number) {
    return 'Dial $number';
  }

  @override
  String get sosAlertFamily => 'Alert my family';

  @override
  String get sosAlertFamilySubtitle => 'Text everyone my location';

  @override
  String get sosShowMedicalId => 'Show my medical ID';

  @override
  String get sosShowMedicalIdSubtitle =>
      'Allergies, medicines and contacts for helpers';

  @override
  String sosCallPerson(String name) {
    return 'Call $name';
  }

  @override
  String get sosAddFamilyFirst =>
      'Add a family member so we know who to alert.';

  @override
  String get sosAddFamily => 'Add family';

  @override
  String get sosFindingLocation => 'Finding your location…';

  @override
  String sosSendingWithoutLocation(String problem) {
    return '$problem Sending without location.';
  }

  @override
  String get sosLocationUnavailable =>
      'Location unavailable. Sending without it.';

  @override
  String sosAlertSms(String name) {
    return '$name needs help and asked Elderly Care to alert you.';
  }

  @override
  String sosAlertSmsWithLocation(String name, String link) {
    return '$name needs help and asked Elderly Care to alert you. Current location: $link';
  }

  @override
  String get sosAlertSmsNoName =>
      'I need help and asked Elderly Care to alert you.';

  @override
  String sosAlertSmsNoNameWithLocation(String link) {
    return 'I need help and asked Elderly Care to alert you. Current location: $link';
  }

  @override
  String get familyAddPerson => 'Add person';

  @override
  String get familyNoneTitle => 'No family added yet';

  @override
  String get familyNoneMessage =>
      'Add the people who look after you so you can reach them quickly.';

  @override
  String get familyAlertEveryone => 'Alert everyone with my location';

  @override
  String familyEditPerson(String name) {
    return 'Edit $name';
  }

  @override
  String relativeSaved(String name) {
    return '$name saved';
  }

  @override
  String relativeRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get relativeRemoveMessage =>
      'They will no longer be alerted in an emergency.';

  @override
  String get relativeEditTitle => 'Edit family member';

  @override
  String get relativeAddTitle => 'Add family member';

  @override
  String get relativeRemove => 'Remove family member';

  @override
  String get relativeName => 'Name';

  @override
  String get relativeNameRequired => 'Please enter a name';

  @override
  String get relativeRelationship => 'Relationship (optional)';

  @override
  String get relativeRelationshipHint => 'e.g. Son, Neighbour, Nurse';

  @override
  String get relativePhone => 'Phone number';

  @override
  String get relativePhoneRequired => 'Please enter a phone number';

  @override
  String get relativePhoneTooShort => 'That number looks too short';

  @override
  String get relativeEmail => 'Email (optional)';

  @override
  String get videoHeading => 'See and talk to your family';

  @override
  String get videoExplanation =>
      'The call opens in your browser or the Jitsi Meet app. It is free and needs no account.';

  @override
  String get videoTextFamily => 'Text my family the link';

  @override
  String get videoAddFamilyFirst => 'Add family first';

  @override
  String get videoVoiceOnly => 'Voice only (no camera)';

  @override
  String get videoStartMuted => 'Start with microphone off';

  @override
  String get videoStart => 'Start video call';

  @override
  String get videoOpenFailed => 'Could not open the video call.';

  @override
  String videoInviteSms(String name, String link) {
    return '$name would like a video call. Join here: $link';
  }

  @override
  String get locationOff =>
      'Location is switched off. Please turn it on in your phone settings.';

  @override
  String get locationNoPermission =>
      'Elderly Care needs permission to see your location.';

  @override
  String get locationNotFound => 'We could not find your location.';

  @override
  String get shareBackupPickerTitle => 'Choose your Elderly Care backup';

  @override
  String setupStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get setupSkip => 'Skip';

  @override
  String get setupFinish => 'Finish';

  @override
  String get setupNickname => 'What would you like us to call you?';

  @override
  String get setupNicknameHint => 'e.g. Gogo, Oupa or Mrs Smith';

  @override
  String get setupNicknameHelp =>
      'Leave it empty and we will use your first name.';

  @override
  String get setupReadingTitle => 'Is this easy to read?';

  @override
  String get setupReadingBody =>
      'Choose a text size that is comfortable for you. You can change it any time in My profile.';

  @override
  String get setupReadingSample => 'Time for your blood pressure tablet.';

  @override
  String get setupHelpTitle => 'What would you like help with?';

  @override
  String get setupHelpBody =>
      'Choose as many as you like. They will come first on your home screen, and everything else stays there too.';

  @override
  String get setupDayTitle => 'Tell us about your day';

  @override
  String get setupDayBody =>
      'We will suggest medicine times that fit around your day.';

  @override
  String get setupWakeUp => 'I usually get up at';

  @override
  String get setupBedtime => 'I usually go to bed at';

  @override
  String setupDaySuggestion(String times) {
    return 'Suggested medicine times: $times';
  }

  @override
  String get setupHealthTitle => 'A few health details';

  @override
  String get setupHealthBody =>
      'These go on your Medical ID, so paramedics and doctors can help you quickly. You can skip this and add them later.';

  @override
  String get setupBloodGroupUnknown => 'I don\'t know';

  @override
  String setupFinishTitle(String name) {
    return 'You\'re all set, $name!';
  }

  @override
  String get setupFinishBody =>
      'Here is what we set up for you. Please read and accept our terms to finish.';

  @override
  String setupSummaryName(String name) {
    return 'We will call you $name.';
  }

  @override
  String setupSummaryFirst(String features) {
    return 'Your home screen starts with $features.';
  }

  @override
  String setupSummaryContact(String name) {
    return '$name is your emergency contact.';
  }

  @override
  String get setupSummaryNoContact =>
      'No emergency contact yet. You can add one in My family.';

  @override
  String get startTitle => 'Let\'s get started';

  @override
  String get startBody => 'A few first steps to make the app work for you.';

  @override
  String get startAllDone => 'You\'re all set';

  @override
  String get startAllDoneBody => 'Well done! You can close this now.';

  @override
  String get startAddMedicine => 'Add your first medicine';

  @override
  String get startAddAppointment => 'Add your next doctor\'s visit';

  @override
  String get startAddFamily => 'Add someone from your family';

  @override
  String get startAddPin => 'Protect the app with a PIN';

  @override
  String get profileMadeForYou => 'Made for you';

  @override
  String get profileCallMe => 'We call you';

  @override
  String get profileMyDay => 'My day';

  @override
  String profileMyDayValue(String wake, String bed) {
    return 'Up at $wake, bed at $bed';
  }

  @override
  String get profileHomeFirst => 'First on my home screen';

  @override
  String get profileHomeFirstNone => 'Everything, in the usual order';
}
