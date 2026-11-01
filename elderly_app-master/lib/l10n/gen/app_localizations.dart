import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_en.dart';
import 'app_localizations_xh.dart';
import 'app_localizations_zu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('en'),
    Locale('xh'),
    Locale('zu'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Elderly Care'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// No description provided for @commonText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get commonText;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get commonTomorrow;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @commonReadAloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get commonReadAloud;

  /// No description provided for @commonStopReading.
  ///
  /// In en, this message translates to:
  /// **'Stop reading'**
  String get commonStopReading;

  /// No description provided for @commonReadMedicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Read the medical disclaimer'**
  String get commonReadMedicalDisclaimer;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as my phone'**
  String get languageSystem;

  /// Shown under the language setting when isiZulu or isiXhosa is chosen.
  ///
  /// In en, this message translates to:
  /// **'This translation is new. If something reads oddly, please tell us so we can improve it.'**
  String get languageReviewNote;

  /// No description provided for @languageEnglishOnlyNote.
  ///
  /// In en, this message translates to:
  /// **'The legal documents and the summaries for your doctor are in English.'**
  String get languageEnglishOnlyNote;

  /// No description provided for @featureMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get featureMedicines;

  /// No description provided for @featureMedicinesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders & doses'**
  String get featureMedicinesSubtitle;

  /// No description provided for @featureAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get featureAppointments;

  /// No description provided for @featureAppointmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor visits'**
  String get featureAppointmentsSubtitle;

  /// No description provided for @featureHealth.
  ///
  /// In en, this message translates to:
  /// **'Health tracker'**
  String get featureHealth;

  /// BP is blood pressure; keep it short, it is a tile subtitle.
  ///
  /// In en, this message translates to:
  /// **'BP, sugar, weight, sleep'**
  String get featureHealthSubtitle;

  /// No description provided for @featureFamily.
  ///
  /// In en, this message translates to:
  /// **'My family'**
  String get featureFamily;

  /// No description provided for @featureFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Call, text & alert'**
  String get featureFamilySubtitle;

  /// No description provided for @featureHospitals.
  ///
  /// In en, this message translates to:
  /// **'Hospitals nearby'**
  String get featureHospitals;

  /// No description provided for @featureHospitalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find & get directions'**
  String get featureHospitalsSubtitle;

  /// No description provided for @featureVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get featureVideoCall;

  /// No description provided for @featureVideoCallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See your family'**
  String get featureVideoCallSubtitle;

  /// No description provided for @featureDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get featureDocuments;

  /// No description provided for @featureDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions & reports'**
  String get featureDocumentsSubtitle;

  /// No description provided for @featureNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get featureNotes;

  /// No description provided for @featureNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Things to remember'**
  String get featureNotesSubtitle;

  /// No description provided for @medicineTypeTablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get medicineTypeTablet;

  /// No description provided for @medicineTypeCapsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get medicineTypeCapsule;

  /// No description provided for @medicineTypeSyrup.
  ///
  /// In en, this message translates to:
  /// **'Syrup'**
  String get medicineTypeSyrup;

  /// No description provided for @medicineTypeDrops.
  ///
  /// In en, this message translates to:
  /// **'Drops'**
  String get medicineTypeDrops;

  /// No description provided for @medicineTypeInjection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get medicineTypeInjection;

  /// No description provided for @medicineTypeInhaler.
  ///
  /// In en, this message translates to:
  /// **'Inhaler'**
  String get medicineTypeInhaler;

  /// No description provided for @medicineTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get medicineTypeOther;

  /// No description provided for @trackerBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get trackerBloodPressure;

  /// No description provided for @trackerBloodPressureTip.
  ///
  /// In en, this message translates to:
  /// **'Healthy range is below 120/80 mmHg.'**
  String get trackerBloodPressureTip;

  /// No description provided for @trackerBloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar'**
  String get trackerBloodSugar;

  /// No description provided for @trackerBloodSugarTip.
  ///
  /// In en, this message translates to:
  /// **'Fasting levels of 70–100 mg/dL are typical.'**
  String get trackerBloodSugarTip;

  /// No description provided for @trackerWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get trackerWeight;

  /// No description provided for @trackerWeightTip.
  ///
  /// In en, this message translates to:
  /// **'Weigh yourself at the same time each day.'**
  String get trackerWeightTip;

  /// No description provided for @trackerSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get trackerSleep;

  /// No description provided for @trackerSleepTip.
  ///
  /// In en, this message translates to:
  /// **'Most adults need 7–8 hours of sleep.'**
  String get trackerSleepTip;

  /// No description provided for @trackerFieldSystolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic (top number)'**
  String get trackerFieldSystolic;

  /// No description provided for @trackerFieldDiastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic (bottom number)'**
  String get trackerFieldDiastolic;

  /// No description provided for @trackerFieldPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get trackerFieldPulse;

  /// No description provided for @trackerFieldGlucose.
  ///
  /// In en, this message translates to:
  /// **'Blood glucose'**
  String get trackerFieldGlucose;

  /// No description provided for @trackerFieldWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get trackerFieldWeight;

  /// No description provided for @trackerFieldHours.
  ///
  /// In en, this message translates to:
  /// **'Hours slept'**
  String get trackerFieldHours;

  /// No description provided for @trackerFieldMinutes.
  ///
  /// In en, this message translates to:
  /// **'Extra minutes'**
  String get trackerFieldMinutes;

  /// No description provided for @trackerSleepValue.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String trackerSleepValue(num hours, num minutes);

  /// Phone notification title.
  ///
  /// In en, this message translates to:
  /// **'Time for {medicine}'**
  String notifyDoseTitle(String medicine);

  /// No description provided for @notifyDoseBody.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Taken\" once you have taken it.'**
  String get notifyDoseBody;

  /// "Taken" must match notifyActionTaken.
  ///
  /// In en, this message translates to:
  /// **'Take {dosage}, then tap \"Taken\".'**
  String notifyDoseBodyWithDosage(String dosage);

  /// No description provided for @notifyFollowUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Did you take your {medicine}?'**
  String notifyFollowUpTitle(String medicine);

  /// No description provided for @notifyFollowUpBody.
  ///
  /// In en, this message translates to:
  /// **'It was due at {time}. Let us know so your record stays right.'**
  String notifyFollowUpBody(String time);

  /// No description provided for @notifySnoozeBody.
  ///
  /// In en, this message translates to:
  /// **'Reminding you again, as you asked.'**
  String get notifySnoozeBody;

  /// No description provided for @notifyAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment in 1 hour'**
  String get notifyAppointmentTitle;

  /// No description provided for @notifyActionTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get notifyActionTaken;

  /// No description provided for @notifyActionSnooze.
  ///
  /// In en, this message translates to:
  /// **'In 10 min'**
  String get notifyActionSnooze;

  /// No description provided for @notifyActionNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notifyActionNotYet;

  /// No description provided for @notifyMedicineChannel.
  ///
  /// In en, this message translates to:
  /// **'Medicine reminders'**
  String get notifyMedicineChannel;

  /// No description provided for @notifyMedicineChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminds you when it is time to take a medicine'**
  String get notifyMedicineChannelDescription;

  /// No description provided for @notifyAppointmentChannel.
  ///
  /// In en, this message translates to:
  /// **'Appointment reminders'**
  String get notifyAppointmentChannel;

  /// No description provided for @notifyAppointmentChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminds you an hour before a doctor appointment'**
  String get notifyAppointmentChannelDescription;

  /// No description provided for @languageChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get languageChoose;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profileTitle;

  /// Shown in the profile instead of a detail the user has not filled in.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileNotSet;

  /// No description provided for @profileShowMedicalId.
  ///
  /// In en, this message translates to:
  /// **'Show my medical ID'**
  String get profileShowMedicalId;

  /// Section heading for the user's phone, email and emergency number.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get profileContact;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmergencyNumber.
  ///
  /// In en, this message translates to:
  /// **'Emergency number'**
  String get profileEmergencyNumber;

  /// No description provided for @profileMedicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Medical details'**
  String get profileMedicalDetails;

  /// No description provided for @profileAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileAge;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get profileBloodGroup;

  /// No description provided for @profileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileHeight;

  /// No description provided for @profileWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get profileWeight;

  /// No description provided for @profileUsualBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Usual blood pressure'**
  String get profileUsualBloodPressure;

  /// No description provided for @profileUsualBloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Usual blood sugar'**
  String get profileUsualBloodSugar;

  /// No description provided for @profileAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get profileAllergies;

  /// No description provided for @profileConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical conditions'**
  String get profileConditions;

  /// No description provided for @profileTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get profileTextSize;

  /// Section heading (noun) for backing up and restoring data.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get profileBackup;

  /// Section heading for settings about the app itself (security, legal, erase).
  ///
  /// In en, this message translates to:
  /// **'This app'**
  String get profileThisApp;

  /// No description provided for @profilePrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get profilePrivacySecurity;

  /// No description provided for @profileAppLockOn.
  ///
  /// In en, this message translates to:
  /// **'App lock is on'**
  String get profileAppLockOn;

  /// No description provided for @profileSetPinHint.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN, see how your data is protected'**
  String get profileSetPinHint;

  /// No description provided for @profileLegalAbout.
  ///
  /// In en, this message translates to:
  /// **'Legal & about'**
  String get profileLegalAbout;

  /// No description provided for @profileLegalAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms, medical disclaimer, privacy, licences'**
  String get profileLegalAboutSubtitle;

  /// No description provided for @profileEraseAll.
  ///
  /// In en, this message translates to:
  /// **'Erase all my data'**
  String get profileEraseAll;

  /// No description provided for @profileEraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase everything?'**
  String get profileEraseTitle;

  /// No description provided for @profileEraseMessage.
  ///
  /// In en, this message translates to:
  /// **'All medicines, appointments, readings, notes, documents and family contacts will be deleted. This cannot be undone.'**
  String get profileEraseMessage;

  /// No description provided for @profileEraseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get profileEraseConfirm;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get profileSave;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTitle;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get profileNameRequired;

  /// Hint under the emergency number field. 112 is the international emergency number; keep it.
  ///
  /// In en, this message translates to:
  /// **'112 works from any mobile phone'**
  String get profileEmergencyNumberHint;

  /// No description provided for @profileEmergencyNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an emergency number'**
  String get profileEmergencyNumberRequired;

  /// No description provided for @profileBloodGroupHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. O+'**
  String get profileBloodGroupHint;

  /// No description provided for @profileBloodPressureHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 120/80'**
  String get profileBloodPressureHint;

  /// No description provided for @profileBloodSugarHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Normal'**
  String get profileBloodSugarHint;

  /// No description provided for @profileAllergiesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Penicillin'**
  String get profileAllergiesHint;

  /// No description provided for @profileConditionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Type 2 diabetes, high blood pressure'**
  String get profileConditionsHint;

  /// Text size option; the three options sit side by side in a small segmented button, so keep them short.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get profileTextSizeNormal;

  /// No description provided for @profileTextSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get profileTextSizeLarge;

  /// No description provided for @profileTextSizeExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get profileTextSizeExtraLarge;

  /// No description provided for @profileTextSizeExplain.
  ///
  /// In en, this message translates to:
  /// **'Makes all writing in the app bigger. It adds to your phone\'s own text size.'**
  String get profileTextSizeExplain;

  /// No description provided for @backupProtectTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your backup?'**
  String get backupProtectTitle;

  /// No description provided for @backupProtectMessage.
  ///
  /// In en, this message translates to:
  /// **'The backup holds your health details. A password keeps them private if the file ends up in the wrong hands. Write it down: without it the backup cannot be opened.'**
  String get backupProtectMessage;

  /// No description provided for @backupPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Backup password'**
  String get backupPasswordLabel;

  /// Button: make the backup without a password.
  ///
  /// In en, this message translates to:
  /// **'No password'**
  String get backupNoPassword;

  /// No description provided for @backupUsePassword.
  ///
  /// In en, this message translates to:
  /// **'Use password'**
  String get backupUsePassword;

  /// Subject line when the backup file is shared, e.g. by email. 'Elderly Care' is the app's name.
  ///
  /// In en, this message translates to:
  /// **'Elderly Care backup'**
  String get backupShareSubject;

  /// No description provided for @backupReady.
  ///
  /// In en, this message translates to:
  /// **'Backup ready. Keep it somewhere safe, like your email or cloud storage.'**
  String get backupReady;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the backup.'**
  String get backupFailed;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup?'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Everything currently in the app will be replaced by what is in the backup file.'**
  String get backupRestoreMessage;

  /// No description provided for @backupChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get backupChooseFile;

  /// No description provided for @backupCouldNotReadFile.
  ///
  /// In en, this message translates to:
  /// **'Could not read that file.'**
  String get backupCouldNotReadFile;

  /// No description provided for @backupProtectedMessage.
  ///
  /// In en, this message translates to:
  /// **'This backup is protected. Enter the password you chose when you made it.'**
  String get backupProtectedMessage;

  /// No description provided for @backupWrongPasswordRetry.
  ///
  /// In en, this message translates to:
  /// **'That password is not right. Please try again.'**
  String get backupWrongPasswordRetry;

  /// No description provided for @backupPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup password'**
  String get backupPasswordTitle;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get backupPassword;

  /// Button (verb) in the password dialog that restores the backup.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestore;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @backupBackUp.
  ///
  /// In en, this message translates to:
  /// **'Back up my data'**
  String get backupBackUp;

  /// No description provided for @backupBackUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save everything to a file you can email to yourself or keep in the cloud.'**
  String get backupBackUpSubtitle;

  /// No description provided for @backupRestoreFrom.
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup'**
  String get backupRestoreFrom;

  /// No description provided for @backupRestoreFromSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use this on a new phone to get your data back.'**
  String get backupRestoreFromSubtitle;

  /// No description provided for @backupErrorNotBackup.
  ///
  /// In en, this message translates to:
  /// **'This file is not an Elderly Care backup.'**
  String get backupErrorNotBackup;

  /// No description provided for @backupErrorTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This file is too large to be a backup.'**
  String get backupErrorTooLarge;

  /// No description provided for @backupErrorDamaged.
  ///
  /// In en, this message translates to:
  /// **'This backup is damaged and could not be read.'**
  String get backupErrorDamaged;

  /// No description provided for @backupErrorNoProfile.
  ///
  /// In en, this message translates to:
  /// **'This backup has no profile in it.'**
  String get backupErrorNoProfile;

  /// The backup file is protected with an encryption method this app version does not know.
  ///
  /// In en, this message translates to:
  /// **'This backup uses an unknown protection method.'**
  String get backupErrorUnknownProtection;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get securityTitle;

  /// No description provided for @securityWrongPin.
  ///
  /// In en, this message translates to:
  /// **'That PIN is not right.'**
  String get securityWrongPin;

  /// No description provided for @securityTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries. Please wait a little and try again.'**
  String get securityTooManyAttempts;

  /// No description provided for @securityChoosePin.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN'**
  String get securityChoosePin;

  /// 'Elderly Care' is the app's name. 'numbers' means digits.
  ///
  /// In en, this message translates to:
  /// **'You will type this PIN to open Elderly Care. Use 4 to 8 numbers that others would not guess.'**
  String get securityChoosePinMessage;

  /// No description provided for @securityNewPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get securityNewPin;

  /// No description provided for @securityPinUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This device cannot store a PIN securely, so app lock is not available here.'**
  String get securityPinUnavailable;

  /// No description provided for @securityAppLockOn.
  ///
  /// In en, this message translates to:
  /// **'App lock is on'**
  String get securityAppLockOn;

  /// No description provided for @securityAppLockOff.
  ///
  /// In en, this message translates to:
  /// **'App lock is off'**
  String get securityAppLockOff;

  /// No description provided for @securityEnterCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN.'**
  String get securityEnterCurrentPin;

  /// No description provided for @securityCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get securityCurrentPin;

  /// No description provided for @securityChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get securityChangePin;

  /// No description provided for @securityTurnOffAppLock.
  ///
  /// In en, this message translates to:
  /// **'Turn off app lock'**
  String get securityTurnOffAppLock;

  /// Section heading for the PIN lock settings.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get securityAppLock;

  /// No description provided for @securityAppLockOnDetail.
  ///
  /// In en, this message translates to:
  /// **'The app asks for your PIN when it opens, and after 2 minutes away.'**
  String get securityAppLockOnDetail;

  /// No description provided for @securityAppLockOffDetail.
  ///
  /// In en, this message translates to:
  /// **'Anyone holding your phone can see your health details. A PIN keeps them private.'**
  String get securityAppLockOffDetail;

  /// No description provided for @securityLockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock now'**
  String get securityLockNow;

  /// Button that turns off the app lock.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get securityTurnOff;

  /// No description provided for @securityLockWithPin.
  ///
  /// In en, this message translates to:
  /// **'Lock with a PIN'**
  String get securityLockWithPin;

  /// No description provided for @securityBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint or face'**
  String get securityBiometrics;

  /// No description provided for @securityMedicalIdWhenLocked.
  ///
  /// In en, this message translates to:
  /// **'Show Medical ID when locked'**
  String get securityMedicalIdWhenLocked;

  /// No description provided for @securityMedicalIdWhenLockedDetail.
  ///
  /// In en, this message translates to:
  /// **'Lets paramedics see your allergies and medicines and call for help without your PIN.'**
  String get securityMedicalIdWhenLockedDetail;

  /// No description provided for @securityHowProtected.
  ///
  /// In en, this message translates to:
  /// **'How your information is protected'**
  String get securityHowProtected;

  /// No description provided for @securityEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted on this device'**
  String get securityEncrypted;

  /// No description provided for @securityNotEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Not encrypted on this device'**
  String get securityNotEncrypted;

  /// No description provided for @securityEncryptedDetail.
  ///
  /// In en, this message translates to:
  /// **'Your health details are scrambled with a key kept in this device\'s secure storage.'**
  String get securityEncryptedDetail;

  /// No description provided for @securityNotEncryptedDetail.
  ///
  /// In en, this message translates to:
  /// **'This browser has no secure storage. Use the phone app, or open the website over https.'**
  String get securityNotEncryptedDetail;

  /// No description provided for @securityLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Kept only on this device'**
  String get securityLocalOnly;

  /// No description provided for @securityLocalOnlyDetail.
  ///
  /// In en, this message translates to:
  /// **'There is no account and no server. Nothing is uploaded, and there are no ads or tracking.'**
  String get securityLocalOnlyDetail;

  /// No description provided for @securitySharedByChoice.
  ///
  /// In en, this message translates to:
  /// **'Only shared when you choose'**
  String get securitySharedByChoice;

  /// No description provided for @securitySharedByChoiceDetail.
  ///
  /// In en, this message translates to:
  /// **'Calls and texts go through your own phone. Health summaries and backups only leave the app when you send them.'**
  String get securitySharedByChoiceDetail;

  /// No description provided for @securityHospitalSearch.
  ///
  /// In en, this message translates to:
  /// **'Hospital search'**
  String get securityHospitalSearch;

  /// OpenStreetMap is a service name; keep it.
  ///
  /// In en, this message translates to:
  /// **'To find hospitals, your location is sent to the free OpenStreetMap service. Nothing else about you is sent.'**
  String get securityHospitalSearchDetail;

  /// No description provided for @securityVideoCalls.
  ///
  /// In en, this message translates to:
  /// **'Video calls'**
  String get securityVideoCalls;

  /// Jitsi Meet is a service name; keep it.
  ///
  /// In en, this message translates to:
  /// **'Calls use the free Jitsi Meet service in a private room with a long random name. Only people you send the link to can join.'**
  String get securityVideoCallsDetail;

  /// No description provided for @securityNoCloudCopy.
  ///
  /// In en, this message translates to:
  /// **'No automatic cloud copy'**
  String get securityNoCloudCopy;

  /// "Back up my data" and "My profile" are the names of a button and a screen in the app; use the same words as those translations.
  ///
  /// In en, this message translates to:
  /// **'The phone does not copy this app\'s data to the cloud. Use \"Back up my data\" in My profile, ideally with a password.'**
  String get securityNoCloudCopyDetail;

  /// No description provided for @securityReadPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read the full privacy policy'**
  String get securityReadPrivacyPolicy;

  /// No description provided for @securityEraseAnyTime.
  ///
  /// In en, this message translates to:
  /// **'You can erase everything at any time in My profile.'**
  String get securityEraseAnyTime;

  /// No description provided for @medicalIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical ID'**
  String get medicalIdTitle;

  /// No description provided for @medicalIdFooter.
  ///
  /// In en, this message translates to:
  /// **'Keep your details up to date in My profile.'**
  String get medicalIdFooter;

  /// No description provided for @medicalIdNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get medicalIdNotRecorded;

  /// No description provided for @medicalIdAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get medicalIdAge;

  /// No description provided for @medicalIdBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get medicalIdBloodGroup;

  /// No description provided for @medicalIdAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get medicalIdAllergies;

  /// No description provided for @medicalIdConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical conditions'**
  String get medicalIdConditions;

  /// No description provided for @medicalIdMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicalIdMedicines;

  /// No description provided for @medicalIdEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get medicalIdEmergencyContacts;

  /// Screen-reader label of the Call button next to a contact.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String medicalIdCallContact(String name);

  /// Read aloud by the phone (text to speech) to a paramedic. The spoken sentences are joined with spaces.
  ///
  /// In en, this message translates to:
  /// **'Medical ID for {name}.'**
  String medicalIdSpeakTitle(String name);

  /// Read aloud. age is what the user typed, usually a number of years.
  ///
  /// In en, this message translates to:
  /// **'Age {age}.'**
  String medicalIdSpeakAge(String age);

  /// Read aloud.
  ///
  /// In en, this message translates to:
  /// **'Blood group {group}.'**
  String medicalIdSpeakBloodGroup(String group);

  /// Read aloud.
  ///
  /// In en, this message translates to:
  /// **'No allergies recorded.'**
  String get medicalIdSpeakNoAllergies;

  /// Read aloud.
  ///
  /// In en, this message translates to:
  /// **'Allergies: {allergies}.'**
  String medicalIdSpeakAllergies(String allergies);

  /// Read aloud.
  ///
  /// In en, this message translates to:
  /// **'Medical conditions: {conditions}.'**
  String medicalIdSpeakConditions(String conditions);

  /// Read aloud. medicines is a comma-separated list of names and doses.
  ///
  /// In en, this message translates to:
  /// **'Medicines: {medicines}.'**
  String medicalIdSpeakMedicines(String medicines);

  /// Read aloud. phone is the number with spaces between the digits so it is read digit by digit.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact: {name}, {phone}.'**
  String medicalIdSpeakContact(String name, String phone);

  /// Read aloud. relationship is what the user typed, e.g. Daughter. phone is read digit by digit.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact: {name}, {relationship}, {phone}.'**
  String medicalIdSpeakContactWithRelationship(
    String name,
    String relationship,
    String phone,
  );

  /// Default button that confirms a typed PIN or password.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get secretOk;

  /// Error under a PIN field that is too short. 'numbers' means digits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Use at least 1 number} other{Use at least {count} numbers}}'**
  String secretMinDigits(int count);

  /// Error under a password field that is too short.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Use at least 1 character} other{Use at least {count} characters}}'**
  String secretMinCharacters(int count);

  /// Label of the second field where the user repeats the new PIN or password.
  ///
  /// In en, this message translates to:
  /// **'Type it again'**
  String get secretTypeAgain;

  /// No description provided for @secretNoMatch.
  ///
  /// In en, this message translates to:
  /// **'The two do not match'**
  String get secretNoMatch;

  /// No description provided for @secretShowPin.
  ///
  /// In en, this message translates to:
  /// **'Show PIN'**
  String get secretShowPin;

  /// No description provided for @secretShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get secretShowPassword;

  /// Tooltip on the profile picture button at the top of the home screen.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get homeMyProfile;

  /// Big greeting at the top of the home screen. greeting is e.g. 'Good morning'; name is the user's first name.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String homeGreeting(String greeting, String name);

  /// Heading above the grid of feature tiles on the home screen.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get homeWhatToDo;

  /// Large red emergency button on the home screen.
  ///
  /// In en, this message translates to:
  /// **'I need help'**
  String get homeSosTitle;

  /// No description provided for @homeSosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Call for help or alert your family'**
  String get homeSosSubtitle;

  /// No description provided for @homeNoMedicines.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get homeNoMedicines;

  /// No description provided for @homeNoMedicinesHint.
  ///
  /// In en, this message translates to:
  /// **'Add one to get reminders'**
  String get homeNoMedicinesHint;

  /// No description provided for @homeAllMedicinesDone.
  ///
  /// In en, this message translates to:
  /// **'All medicines done for today'**
  String get homeAllMedicinesDone;

  /// How many of today's medicine doses were taken, e.g. '3 of 3 taken'.
  ///
  /// In en, this message translates to:
  /// **'{taken} of {total} taken'**
  String homeDosesTaken(int taken, int total);

  /// A medicine dose is due now. medicine is the medicine's name.
  ///
  /// In en, this message translates to:
  /// **'Time for {medicine}'**
  String homeTimeFor(String medicine);

  /// The next medicine dose later today. medicine is the medicine's name.
  ///
  /// In en, this message translates to:
  /// **'Next: {medicine}'**
  String homeNextMedicine(String medicine);

  /// Button that opens a screen to confirm the right medicine before taking it.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get homeCheckDose;

  /// Warning that a medicine is running out.
  ///
  /// In en, this message translates to:
  /// **'Refill {medicine} soon'**
  String homeRefillSoon(String medicine);

  /// How many doses of a medicine are left.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Only 1 dose left} other{Only {count} doses left}}'**
  String homeDosesLeft(int count);

  /// When the next appointment is. day is e.g. 'Today', 'Tomorrow' or a date; time is a clock time.
  ///
  /// In en, this message translates to:
  /// **'{day} at {time}'**
  String homeAppointmentWhen(String day, String time);

  /// Read aloud at the start of today's summary. greeting is e.g. 'Good morning'; name is the user's first name.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}.'**
  String homeSpokenGreeting(String greeting, String name);

  /// Read aloud. date is the weekday and date, e.g. 'Monday 2 November'.
  ///
  /// In en, this message translates to:
  /// **'Today is {date}.'**
  String homeSpokenToday(String date);

  /// Read aloud in today's summary.
  ///
  /// In en, this message translates to:
  /// **'You have no medicines set up.'**
  String get homeSpokenNoMedicines;

  /// Read aloud in today's summary.
  ///
  /// In en, this message translates to:
  /// **'You have taken all your medicines for today.'**
  String get homeSpokenAllTaken;

  /// Read aloud: a dose is due now.
  ///
  /// In en, this message translates to:
  /// **'It is time for {medicine} at {time}.'**
  String homeSpokenDoseDue(String medicine, String time);

  /// Read aloud: a dose is due now. dosage is free text typed by the user, e.g. '1 tablet'.
  ///
  /// In en, this message translates to:
  /// **'It is time for {medicine}, {dosage}, at {time}.'**
  String homeSpokenDoseDueWithDosage(
    String medicine,
    String dosage,
    String time,
  );

  /// Read aloud: the next dose later today.
  ///
  /// In en, this message translates to:
  /// **'Your next medicine is {medicine} at {time}.'**
  String homeSpokenDoseNext(String medicine, String time);

  /// Read aloud: the next dose later today. dosage is free text typed by the user, e.g. '1 tablet'.
  ///
  /// In en, this message translates to:
  /// **'Your next medicine is {medicine}, {dosage}, at {time}.'**
  String homeSpokenDoseNextWithDosage(
    String medicine,
    String dosage,
    String time,
  );

  /// Read aloud when a medicine is running out.
  ///
  /// In en, this message translates to:
  /// **'Remember to refill {medicine} soon.'**
  String homeSpokenRefill(String medicine);

  /// Read aloud. doctor is the doctor's name as typed by the user; day is e.g. 'today', 'tomorrow' or a date (in lower case); time is a clock time.
  ///
  /// In en, this message translates to:
  /// **'Your next appointment is with {doctor}, {day} at {time}.'**
  String homeSpokenAppointment(String doctor, String day, String time);

  /// Title of the lock screen. PIN is the secret number that unlocks the app.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get lockEnterPin;

  /// No description provided for @lockPinTooShort.
  ///
  /// In en, this message translates to:
  /// **'Your PIN has at least 4 numbers.'**
  String get lockPinTooShort;

  /// left is how many more wrong PINs are allowed before the app makes the user wait.
  ///
  /// In en, this message translates to:
  /// **'That PIN is not right. {left, plural, =1{1 try left} other{{left} tries left}} before a short wait.'**
  String lockPinWrong(int left);

  /// No description provided for @lockTooManyTries.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries.'**
  String get lockTooManyTries;

  /// time is a countdown in minutes and seconds, e.g. '0:45'.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries. Try again in {time}.'**
  String lockWait(String time);

  /// Screen-reader label for the dots that show how many PIN numbers were typed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 number entered} other{{count} numbers entered}}'**
  String lockPinDigitsEntered(int count);

  /// Button to unlock with the phone's fingerprint or face recognition.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face'**
  String get lockUseBiometrics;

  /// Button on the lock screen, and the title of the emergency panel that shows the Medical ID and a call button.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get lockEmergency;

  /// No description provided for @lockForgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get lockForgotPin;

  /// Button that phones the emergency number, e.g. 'Call 112'.
  ///
  /// In en, this message translates to:
  /// **'Call {number}'**
  String lockCallNumber(String number);

  /// Medical ID is the user's health summary for emergency workers.
  ///
  /// In en, this message translates to:
  /// **'The Medical ID is hidden while the app is locked.'**
  String get lockMedicalIdHidden;

  /// No description provided for @lockForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your PIN?'**
  String get lockForgotTitle;

  /// 'My profile' is the name of the profile screen; keep it the same as that screen's name.
  ///
  /// In en, this message translates to:
  /// **'For your privacy the PIN cannot be recovered. You can erase everything in the app and start again. If you made a backup, you can restore it afterwards from My profile.'**
  String get lockForgotBody;

  /// No description provided for @lockEraseEverything.
  ///
  /// In en, this message translates to:
  /// **'Erase everything and start again'**
  String get lockEraseEverything;

  /// No description provided for @lockEraseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, erase everything'**
  String get lockEraseConfirm;

  /// No description provided for @lockEraseWarning.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Tap again to confirm.'**
  String get lockEraseWarning;

  /// Screen-reader label for the backspace key on the PIN keypad (removes the last number).
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get lockKeyDelete;

  /// Screen-reader label for the tick key on the PIN keypad.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockKeyUnlock;

  /// Skips the introduction pages.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Button on the last introduction page.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Never miss a medicine'**
  String get onboardingMedicinesTitle;

  /// No description provided for @onboardingMedicinesText.
  ///
  /// In en, this message translates to:
  /// **'Get a reminder when each dose is due, and let your family know if one is missed.'**
  String get onboardingMedicinesText;

  /// No description provided for @onboardingAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Remember appointments'**
  String get onboardingAppointmentsTitle;

  /// No description provided for @onboardingAppointmentsText.
  ///
  /// In en, this message translates to:
  /// **'Keep your doctor visits in one place and get a reminder an hour before.'**
  String get onboardingAppointmentsText;

  /// No description provided for @onboardingHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Track your health'**
  String get onboardingHealthTitle;

  /// No description provided for @onboardingHealthText.
  ///
  /// In en, this message translates to:
  /// **'Record blood pressure, blood sugar, weight and sleep, and see how they change.'**
  String get onboardingHealthText;

  /// No description provided for @onboardingHospitalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Find help nearby'**
  String get onboardingHospitalsTitle;

  /// No description provided for @onboardingHospitalsText.
  ///
  /// In en, this message translates to:
  /// **'See the closest hospitals and clinics with directions and phone numbers.'**
  String get onboardingHospitalsText;

  /// No description provided for @onboardingFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family is one tap away'**
  String get onboardingFamilyTitle;

  /// No description provided for @onboardingFamilyText.
  ///
  /// In en, this message translates to:
  /// **'Call, text or video call your family, or send them your location in an emergency.'**
  String get onboardingFamilyText;

  /// Elderly Care is the app's name.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Elderly Care'**
  String get setupWelcome;

  /// No description provided for @setupIntro.
  ///
  /// In en, this message translates to:
  /// **'Just a few details to get you started. Everything stays on this phone.'**
  String get setupIntro;

  /// Section heading in the first-run form.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get setupAboutYou;

  /// No description provided for @setupYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get setupYourName;

  /// No description provided for @setupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get setupNameRequired;

  /// No description provided for @setupYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone number (optional)'**
  String get setupYourPhone;

  /// Section heading: the person to contact in an emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get setupEmergencyContact;

  /// No description provided for @setupEmergencyContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Someone we can call or text for you when you need help.'**
  String get setupEmergencyContactInfo;

  /// The emergency contact's name.
  ///
  /// In en, this message translates to:
  /// **'Their name'**
  String get setupTheirName;

  /// How the emergency contact is related to the user.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get setupRelationship;

  /// No description provided for @setupRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Daughter'**
  String get setupRelationshipHint;

  /// The emergency contact's phone number.
  ///
  /// In en, this message translates to:
  /// **'Their phone number'**
  String get setupTheirPhone;

  /// No description provided for @setupTheirPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter their phone number'**
  String get setupTheirPhoneRequired;

  /// No description provided for @setupAddMoreLater.
  ///
  /// In en, this message translates to:
  /// **'You can add more family members later.'**
  String get setupAddMoreLater;

  /// Title of a legal document.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get legalDocTerms;

  /// Title of a legal document saying the app does not replace a doctor.
  ///
  /// In en, this message translates to:
  /// **'Medical disclaimer'**
  String get legalDocMedical;

  /// Title of a legal document.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get legalDocPrivacy;

  /// Title of a document about how the app supports people with disabilities.
  ///
  /// In en, this message translates to:
  /// **'Accessibility statement'**
  String get legalDocAccessibility;

  /// Title of a document listing fonts, images and software by others.
  ///
  /// In en, this message translates to:
  /// **'Credits and third-party notices'**
  String get legalDocCredits;

  /// Link that opens the Terms of Use.
  ///
  /// In en, this message translates to:
  /// **'Read the terms of use'**
  String get legalReadTerms;

  /// Link that opens the Privacy policy.
  ///
  /// In en, this message translates to:
  /// **'Read the privacy policy'**
  String get legalReadPrivacy;

  /// Shown above a legal document when the app is not in English.
  ///
  /// In en, this message translates to:
  /// **'This document is available in English only. The English version is the binding one.'**
  String get legalEnglishOnly;

  /// Screen listing the legal documents, licences and app version.
  ///
  /// In en, this message translates to:
  /// **'Legal & about'**
  String get legalHubTitle;

  /// No description provided for @legalOpenSourceLicences.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get legalOpenSourceLicences;

  /// Elderly Care is the app's name; version is e.g. '2.1.0'.
  ///
  /// In en, this message translates to:
  /// **'Elderly Care, version {version}'**
  String legalAppVersion(String version);

  /// Shown on the open-source licences page; version is e.g. '2.1.0'.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String legalVersion(String version);

  /// version is the legal documents' version number; date is e.g. '1 November 2026'.
  ///
  /// In en, this message translates to:
  /// **'You accepted version {version} of these documents on {date}.'**
  String legalAcceptedOn(int version, String date);

  /// Checkbox label. Use the same document names as legalDocTerms, legalDocMedical and legalDocPrivacy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Use, and I have read the Medical disclaimer and the Privacy policy'**
  String get legalAgree;

  /// No description provided for @legalTickBox.
  ///
  /// In en, this message translates to:
  /// **'Please tick the box to continue.'**
  String get legalTickBox;

  /// Elderly Care is the app's name; 112 is the emergency number, keep it.
  ///
  /// In en, this message translates to:
  /// **'Elderly Care is not a medical service. In an emergency, call 112.'**
  String get legalNotMedicalService;

  /// Title when an existing user is asked to accept the legal documents for the first time.
  ///
  /// In en, this message translates to:
  /// **'Please review our terms'**
  String get legalReviewTitle;

  /// No description provided for @legalUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Our terms have been updated'**
  String get legalUpdatedTitle;

  /// version is the documents' version number; date is when they take effect, e.g. '1 November 2026'.
  ///
  /// In en, this message translates to:
  /// **'Before you continue, please read and accept the Terms of Use, the Medical disclaimer and the Privacy policy (version {version}, effective {date}). Your information stays on this device.'**
  String legalUpdateBody(int version, String date);

  /// No description provided for @medicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicinesTitle;

  /// Button on the medicines list that opens the form for a new medicine; also the title of that form.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get medicinesAdd;

  /// No description provided for @medicinesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get medicinesEmptyTitle;

  /// No description provided for @medicinesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your medicines and we will remind you when each dose is due.'**
  String get medicinesEmptyMessage;

  /// No description provided for @medicinesTodaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get medicinesTodaySchedule;

  /// Next to today's schedule: how many of today's doses have been taken.
  ///
  /// In en, this message translates to:
  /// **'{taken} of {total} taken'**
  String medicinesTakenToday(int taken, int total);

  /// Section heading above the list of the user's medicines.
  ///
  /// In en, this message translates to:
  /// **'My medicines'**
  String get medicinesMine;

  /// How often a medicine is taken, shown short, e.g. '2× a day'. The × sign means 'times'.
  ///
  /// In en, this message translates to:
  /// **'{count}× a day'**
  String medicinesTimesADay(int count);

  /// No description provided for @medicinesDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Always take medicines as your doctor or pharmacist told you. Reminders can sometimes be late, so do not rely on them alone.'**
  String get medicinesDisclaimer;

  /// Warning when a medicine pack is nearly empty.
  ///
  /// In en, this message translates to:
  /// **'Only {count} doses left – time to refill'**
  String medicinesSupplyLow(int count);

  /// How many doses are left in the pack and roughly how many days that lasts.
  ///
  /// In en, this message translates to:
  /// **'{count} doses left (about {days} days)'**
  String medicinesSupplyLeft(int count, int days);

  /// No description provided for @medicinesLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days: {taken} of {due} doses taken'**
  String medicinesLastWeek(int taken, int due);

  /// No description provided for @medicinesLateTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders may arrive late'**
  String get medicinesLateTitle;

  /// Android only. 'Elderly Care' is the app's name.
  ///
  /// In en, this message translates to:
  /// **'Your phone is saving battery by delaying reminders. Allow Elderly Care to remind you at the exact time.'**
  String get medicinesLateMessage;

  /// Button that opens the phone setting allowing reminders at the exact time.
  ///
  /// In en, this message translates to:
  /// **'Allow on-time reminders'**
  String get medicinesLateAllow;

  /// Status of a dose in today's schedule: the user took it.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get doseStatusTaken;

  /// Status of a dose: the user said they did not take it.
  ///
  /// In en, this message translates to:
  /// **'Not taken'**
  String get doseStatusNotTaken;

  /// Status of a dose that was due more than an hour ago and has no answer yet.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get doseStatusOverdue;

  /// No description provided for @doseStatusDue.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get doseStatusDue;

  /// Status of a dose that is due later today.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get doseStatusLater;

  /// A dose in today's schedule: its time and its status, e.g. '08:00 · Due now'.
  ///
  /// In en, this message translates to:
  /// **'{time} · {status}'**
  String doseRowSubtitle(String time, String status);

  /// Button on a due dose that opens the 'Did you take it?' screen.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get doseCheck;

  /// No description provided for @doseCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicine check'**
  String get doseCheckTitle;

  /// No description provided for @doseCheckQuestion.
  ///
  /// In en, this message translates to:
  /// **'Did you take your {medicine}?'**
  String doseCheckQuestion(String medicine);

  /// When a dose was due, e.g. 'Today at 08:00'. {day} is a word like Today/Yesterday or a date.
  ///
  /// In en, this message translates to:
  /// **'{day} at {time}'**
  String doseCheckWhen(String day, String time);

  /// No description provided for @doseCheckYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, I took it'**
  String get doseCheckYes;

  /// No description provided for @doseCheckNo.
  ///
  /// In en, this message translates to:
  /// **'No, not yet'**
  String get doseCheckNo;

  /// No description provided for @doseTellFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Let your family know?'**
  String get doseTellFamilyTitle;

  /// {names} is a comma-separated list of family members' names.
  ///
  /// In en, this message translates to:
  /// **'We can send a text to {names} saying you missed your {medicine}.'**
  String doseTellFamilyMessage(String names, String medicine);

  /// Button that sends an SMS to family.
  ///
  /// In en, this message translates to:
  /// **'Send text'**
  String get doseTellFamilySend;

  /// SMS sent to family members when the user missed a dose. {name} is the user's first name; {time} is when the dose was due.
  ///
  /// In en, this message translates to:
  /// **'{name} did not take {medicine} ({time}) today. Please check in.'**
  String doseMissedSms(String name, String medicine, String time);

  /// SMS sent to family when the user missed a dose and has not entered a name; written as the user speaking.
  ///
  /// In en, this message translates to:
  /// **'I did not take {medicine} ({time}) today. Please check in.'**
  String doseMissedSmsNoName(String medicine, String time);

  /// No description provided for @doseRecordedTaken.
  ///
  /// In en, this message translates to:
  /// **'Well done! {medicine} recorded.'**
  String doseRecordedTaken(String medicine);

  /// No description provided for @doseRecordedNotTaken.
  ///
  /// In en, this message translates to:
  /// **'Noted. {medicine} not taken.'**
  String doseRecordedNotTaken(String medicine);

  /// Shown after the user taps 'Taken' on a reminder notification.
  ///
  /// In en, this message translates to:
  /// **'{medicine} recorded as taken. Well done!'**
  String doseTakenFromNotification(String medicine);

  /// Shown after the user taps 'In 10 min' on a reminder notification.
  ///
  /// In en, this message translates to:
  /// **'We will remind you about {medicine} again in 10 minutes.'**
  String doseSnoozed(String medicine);

  /// No description provided for @medicineEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit medicine'**
  String get medicineEditTitle;

  /// No description provided for @medicineEditSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get medicineEditSaveChanges;

  /// Button that saves a new medicine and sets its reminders.
  ///
  /// In en, this message translates to:
  /// **'Save reminder'**
  String get medicineEditSaveNew;

  /// No description provided for @medicineEditDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete medicine'**
  String get medicineEditDeleteTooltip;

  /// No description provided for @medicineEditDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {medicine}?'**
  String medicineEditDeleteTitle(String medicine);

  /// No description provided for @medicineEditDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You will no longer get reminders for this medicine.'**
  String get medicineEditDeleteMessage;

  /// No description provided for @medicineEditReminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set for {medicine}'**
  String medicineEditReminderSet(String medicine);

  /// No description provided for @medicineEditSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {medicine}'**
  String medicineEditSaved(String medicine);

  /// No description provided for @medicineEditNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get medicineEditNameLabel;

  /// No description provided for @medicineEditNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Metformin'**
  String get medicineEditNameHint;

  /// No description provided for @medicineEditNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the medicine name'**
  String get medicineEditNameRequired;

  /// No description provided for @medicineEditDosageLabel.
  ///
  /// In en, this message translates to:
  /// **'How much (optional)'**
  String get medicineEditDosageLabel;

  /// No description provided for @medicineEditDosageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1 tablet, 500 mg'**
  String get medicineEditDosageHint;

  /// No description provided for @medicineEditSupplyLabel.
  ///
  /// In en, this message translates to:
  /// **'Doses left in the pack (optional)'**
  String get medicineEditSupplyLabel;

  /// No description provided for @medicineEditSupplyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 30'**
  String get medicineEditSupplyHint;

  /// No description provided for @medicineEditSupplyHelper.
  ///
  /// In en, this message translates to:
  /// **'We will warn you when it is time to refill.'**
  String get medicineEditSupplyHelper;

  /// No description provided for @medicineEditSupplyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a whole number'**
  String get medicineEditSupplyInvalid;

  /// Heading above the choices Tablet, Capsule, Syrup, …
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get medicineEditType;

  /// No description provided for @medicineEditHowOften.
  ///
  /// In en, this message translates to:
  /// **'How many times a day?'**
  String get medicineEditHowOften;

  /// No description provided for @medicineEditOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get medicineEditOnce;

  /// No description provided for @medicineEditTwice.
  ///
  /// In en, this message translates to:
  /// **'Twice'**
  String get medicineEditTwice;

  /// No description provided for @medicineEditThreeTimes.
  ///
  /// In en, this message translates to:
  /// **'3 times'**
  String get medicineEditThreeTimes;

  /// No description provided for @medicineEditAtWhatTimes.
  ///
  /// In en, this message translates to:
  /// **'At what times?'**
  String get medicineEditAtWhatTimes;

  /// Label for the 1st, 2nd or 3rd dose of the day.
  ///
  /// In en, this message translates to:
  /// **'Dose {number}'**
  String medicineEditDoseNumber(int number);

  /// Heading of the time picker for the 1st, 2nd or 3rd dose.
  ///
  /// In en, this message translates to:
  /// **'Dose {number} time'**
  String medicineEditDoseTime(int number);

  /// Shown at the end of a row that can be tapped to change a time.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get medicineEditChange;

  /// No description provided for @appointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsTitle;

  /// No description provided for @appointmentsUpcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming ({count})'**
  String appointmentsUpcomingTab(int count);

  /// No description provided for @appointmentsPastTab.
  ///
  /// In en, this message translates to:
  /// **'Past ({count})'**
  String appointmentsPastTab(int count);

  /// No description provided for @appointmentsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add appointment'**
  String get appointmentsAdd;

  /// No description provided for @appointmentsNoPast.
  ///
  /// In en, this message translates to:
  /// **'No past appointments'**
  String get appointmentsNoPast;

  /// No description provided for @appointmentsNoUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get appointmentsNoUpcoming;

  /// No description provided for @appointmentsNoPastMessage.
  ///
  /// In en, this message translates to:
  /// **'Appointments move here once they are over.'**
  String get appointmentsNoPastMessage;

  /// No description provided for @appointmentsNoUpcomingMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your next doctor visit and we will remind you an hour before.'**
  String get appointmentsNoUpcomingMessage;

  /// Marks an appointment the user went to.
  ///
  /// In en, this message translates to:
  /// **'Attended'**
  String get appointmentsAttended;

  /// No description provided for @appointmentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointmentEditTitle;

  /// No description provided for @appointmentEditNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get appointmentEditNewTitle;

  /// No description provided for @appointmentEditSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get appointmentEditSaveChanges;

  /// No description provided for @appointmentEditSaveNew.
  ///
  /// In en, this message translates to:
  /// **'Save appointment'**
  String get appointmentEditSaveNew;

  /// No description provided for @appointmentEditDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete appointment'**
  String get appointmentEditDeleteTooltip;

  /// No description provided for @appointmentEditDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete appointment?'**
  String get appointmentEditDeleteTitle;

  /// No description provided for @appointmentEditDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Your appointment with {doctor} will be removed.'**
  String appointmentEditDeleteMessage(String doctor);

  /// No description provided for @appointmentEditSaved.
  ///
  /// In en, this message translates to:
  /// **'Appointment with {doctor} saved'**
  String appointmentEditSaved(String doctor);

  /// No description provided for @appointmentEditDoctorLabel.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s name'**
  String get appointmentEditDoctorLabel;

  /// No description provided for @appointmentEditDoctorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dr. Naidoo'**
  String get appointmentEditDoctorHint;

  /// No description provided for @appointmentEditDoctorRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the doctor\'s name'**
  String get appointmentEditDoctorRequired;

  /// No description provided for @appointmentEditSpecialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Type of doctor (optional)'**
  String get appointmentEditSpecialtyLabel;

  /// No description provided for @appointmentEditSpecialtyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cardiologist'**
  String get appointmentEditSpecialtyHint;

  /// No description provided for @appointmentEditPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Where (optional)'**
  String get appointmentEditPlaceLabel;

  /// No description provided for @appointmentEditPlaceHint.
  ///
  /// In en, this message translates to:
  /// **'Hospital, clinic or home visit'**
  String get appointmentEditPlaceHint;

  /// Heading above the appointment's date and time.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get appointmentEditWhen;

  /// Shown at the end of the date row; tapping it changes the date and time.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get appointmentEditChange;

  /// No description provided for @appointmentEditNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get appointmentEditNotesLabel;

  /// No description provided for @appointmentEditNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Questions to ask, things to bring…'**
  String get appointmentEditNotesHint;

  /// No description provided for @appointmentEditAttended.
  ///
  /// In en, this message translates to:
  /// **'I went to this appointment'**
  String get appointmentEditAttended;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @notesNew.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notesNew;

  /// No description provided for @notesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesEmptyTitle;

  /// No description provided for @notesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Write down things to remember, questions for the doctor, or anything else.'**
  String get notesEmptyMessage;

  /// When a note was last changed. {day} is 'today', 'yesterday' or a date, already in lower case.
  ///
  /// In en, this message translates to:
  /// **'Updated {day}'**
  String notesUpdated(String day);

  /// Same as notesUpdated, for a note marked important.
  ///
  /// In en, this message translates to:
  /// **'Important · Updated {day}'**
  String notesImportantUpdated(String day);

  /// No description provided for @noteEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get noteEditTitle;

  /// No description provided for @noteEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get noteEditSave;

  /// No description provided for @noteEditSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get noteEditSaved;

  /// No description provided for @noteEditDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get noteEditDeleteTooltip;

  /// No description provided for @noteEditDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get noteEditDeleteTitle;

  /// No description provided for @noteEditDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be removed.'**
  String noteEditDeleteMessage(String title);

  /// Label of the field for a note's title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteEditTitleLabel;

  /// No description provided for @noteEditTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get noteEditTitleRequired;

  /// Label of the field for a note's text.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteEditBodyLabel;

  /// No description provided for @noteEditHowImportant.
  ///
  /// In en, this message translates to:
  /// **'How important is it?'**
  String get noteEditHowImportant;

  /// No description provided for @noteEditImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get noteEditImportant;

  /// Priority of a note that is not marked important.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get noteEditNormal;

  /// "Share" must match commonShare (the button at the top of the screen).
  ///
  /// In en, this message translates to:
  /// **'Keep a record of your readings, then tap Share to send your doctor a summary.'**
  String get healthIntro;

  /// 112 is the emergency phone number; keep it as is.
  ///
  /// In en, this message translates to:
  /// **'Tips here are general information for adults, not medical advice. Ask your doctor what readings are right for you. If you feel very unwell, call 112.'**
  String get healthDisclaimer;

  /// No description provided for @healthNoReadings.
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get healthNoReadings;

  /// Subject line of the email/message that sends the health summary to the doctor.
  ///
  /// In en, this message translates to:
  /// **'Health summary for {name}'**
  String healthShareSubject(String name);

  /// Subject line used when the user has not entered a name.
  ///
  /// In en, this message translates to:
  /// **'Health summary for me'**
  String get healthShareSubjectNoName;

  /// No description provided for @healthShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Send your doctor a summary of the last 30 days'**
  String get healthShareTitle;

  /// No description provided for @healthShareAsPdf.
  ///
  /// In en, this message translates to:
  /// **'As a PDF document'**
  String get healthShareAsPdf;

  /// No description provided for @healthShareAsPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Neat tables, easy to print'**
  String get healthShareAsPdfSubtitle;

  /// No description provided for @healthShareAsText.
  ///
  /// In en, this message translates to:
  /// **'As a message'**
  String get healthShareAsText;

  /// No description provided for @healthShareAsTextSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plain text for email or WhatsApp'**
  String get healthShareAsTextSubtitle;

  /// No description provided for @trackingAddReading.
  ///
  /// In en, this message translates to:
  /// **'Add reading'**
  String get trackingAddReading;

  /// No description provided for @trackingFirstReading.
  ///
  /// In en, this message translates to:
  /// **'Add your first reading to start tracking.'**
  String get trackingFirstReading;

  /// No description provided for @trackingOneMore.
  ///
  /// In en, this message translates to:
  /// **'Add one more reading to see a chart.'**
  String get trackingOneMore;

  /// Section heading above the list of saved health readings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get trackingReadings;

  /// No description provided for @trackingDeleteReading.
  ///
  /// In en, this message translates to:
  /// **'Delete reading'**
  String get trackingDeleteReading;

  /// No description provided for @trackingDeleteReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete reading?'**
  String get trackingDeleteReadingTitle;

  /// Asks to confirm deleting a reading, e.g. "120/80 mmHg on Today".
  ///
  /// In en, this message translates to:
  /// **'{reading} on {day}'**
  String trackingDeleteReadingMessage(String reading, String day);

  /// Read by screen readers for the chart. type is the reading type, e.g. Blood pressure; latest is the latest value.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{type} chart of the last {count} readings. Latest {latest}.}}'**
  String trackingChartLabel(int count, String type, String latest);

  /// Form error. field is the field name in lower case, e.g. "diastolic (bottom number)".
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String trackingFieldRequired(String field);

  /// No description provided for @trackingEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a number'**
  String get trackingEnterNumber;

  /// Form error when a reading is outside the allowed range.
  ///
  /// In en, this message translates to:
  /// **'Should be between {min} and {max}'**
  String trackingOutOfRange(String min, String max);

  /// No description provided for @trackingReadingSaved.
  ///
  /// In en, this message translates to:
  /// **'{type} reading saved'**
  String trackingReadingSaved(String type);

  /// No description provided for @trackingSaveReading.
  ///
  /// In en, this message translates to:
  /// **'Save reading'**
  String get trackingSaveReading;

  /// Screen title. type is the reading type in lower case, e.g. "blood pressure".
  ///
  /// In en, this message translates to:
  /// **'New {type} reading'**
  String trackingNewReadingTitle(String type);

  /// Shown next to the date and time of a reading; tap to change it.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get trackingChangeTime;

  /// No description provided for @trackingNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get trackingNotes;

  /// No description provided for @trackingNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. after breakfast'**
  String get trackingNotesHint;

  /// No description provided for @documentTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get documentTakePhoto;

  /// No description provided for @documentChooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get documentChooseFromGallery;

  /// No description provided for @documentPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the camera or gallery.'**
  String get documentPickFailed;

  /// No description provided for @documentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get documentAdd;

  /// No description provided for @documentNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get documentNoneTitle;

  /// "Medical aid" is South African health insurance.
  ///
  /// In en, this message translates to:
  /// **'Take photos of prescriptions, test results and medical aid cards to keep them handy.'**
  String get documentNoneMessage;

  /// No description provided for @documentSearch.
  ///
  /// In en, this message translates to:
  /// **'Search documents'**
  String get documentSearch;

  /// Shown when a search finds nothing. query is what the user typed.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches \"{query}\".'**
  String documentNoMatch(String query);

  /// No description provided for @documentSaved.
  ///
  /// In en, this message translates to:
  /// **'Document saved'**
  String get documentSaved;

  /// No description provided for @documentSave.
  ///
  /// In en, this message translates to:
  /// **'Save document'**
  String get documentSave;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get documentName;

  /// No description provided for @documentNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Blood test March'**
  String get documentNameHint;

  /// No description provided for @documentNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name so you can find it later'**
  String get documentNameRequired;

  /// No description provided for @documentDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get documentDelete;

  /// No description provided for @documentDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String documentDeleteTitle(String name);

  /// No description provided for @documentDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This photo will be removed from the app.'**
  String get documentDeleteMessage;

  /// No description provided for @hospitalRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get hospitalRefresh;

  /// No description provided for @hospitalEmergencyCall.
  ///
  /// In en, this message translates to:
  /// **'Emergency? Call {number}'**
  String hospitalEmergencyCall(String number);

  /// No description provided for @hospitalSearching.
  ///
  /// In en, this message translates to:
  /// **'Looking for hospitals near you…'**
  String get hospitalSearching;

  /// No description provided for @hospitalSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not search'**
  String get hospitalSearchFailed;

  /// No description provided for @hospitalCheckInternet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get hospitalCheckInternet;

  /// No description provided for @hospitalTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get hospitalTryAgain;

  /// No description provided for @hospitalNoneFound.
  ///
  /// In en, this message translates to:
  /// **'None found within 10 km'**
  String get hospitalNoneFound;

  /// No description provided for @hospitalNoneFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'In an emergency, call the number above.'**
  String get hospitalNoneFoundMessage;

  /// Heading above the list of hospitals and clinics found.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place within 10 km} other{{count} places within 10 km}}'**
  String hospitalCount(int count);

  /// No description provided for @hospitalListNote.
  ///
  /// In en, this message translates to:
  /// **'This list comes from OpenStreetMap and may be incomplete or out of date. Not every place has an emergency unit: phone first if you can.'**
  String get hospitalListNote;

  /// Required map data credit; keep "OpenStreetMap" and "©" unchanged.
  ///
  /// In en, this message translates to:
  /// **'Data © OpenStreetMap contributors'**
  String get hospitalAttribution;

  /// No description provided for @hospitalDistanceMeters.
  ///
  /// In en, this message translates to:
  /// **'{meters} m away'**
  String hospitalDistanceMeters(int meters);

  /// No description provided for @hospitalDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String hospitalDistanceKm(String km);

  /// Button that opens a map with directions to the hospital.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get hospitalDirections;

  /// Heading of the emergency (SOS) options sheet.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get sosTitle;

  /// No description provided for @sosCallEmergency.
  ///
  /// In en, this message translates to:
  /// **'Call emergency services'**
  String get sosCallEmergency;

  /// No description provided for @sosDial.
  ///
  /// In en, this message translates to:
  /// **'Dial {number}'**
  String sosDial(String number);

  /// No description provided for @sosAlertFamily.
  ///
  /// In en, this message translates to:
  /// **'Alert my family'**
  String get sosAlertFamily;

  /// No description provided for @sosAlertFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Text everyone my location'**
  String get sosAlertFamilySubtitle;

  /// No description provided for @sosShowMedicalId.
  ///
  /// In en, this message translates to:
  /// **'Show my medical ID'**
  String get sosShowMedicalId;

  /// No description provided for @sosShowMedicalIdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allergies, medicines and contacts for helpers'**
  String get sosShowMedicalIdSubtitle;

  /// No description provided for @sosCallPerson.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String sosCallPerson(String name);

  /// No description provided for @sosAddFamilyFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a family member so we know who to alert.'**
  String get sosAddFamilyFirst;

  /// No description provided for @sosAddFamily.
  ///
  /// In en, this message translates to:
  /// **'Add family'**
  String get sosAddFamily;

  /// No description provided for @sosFindingLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding your location…'**
  String get sosFindingLocation;

  /// problem is a full sentence explaining why the location could not be found.
  ///
  /// In en, this message translates to:
  /// **'{problem} Sending without location.'**
  String sosSendingWithoutLocation(String problem);

  /// No description provided for @sosLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable. Sending without it.'**
  String get sosLocationUnavailable;

  /// Text message sent to family in an emergency. name is the user's first name. Elderly Care is the app's name.
  ///
  /// In en, this message translates to:
  /// **'{name} needs help and asked Elderly Care to alert you.'**
  String sosAlertSms(String name);

  /// Text message sent to family in an emergency, with a map link to where the user is.
  ///
  /// In en, this message translates to:
  /// **'{name} needs help and asked Elderly Care to alert you. Current location: {link}'**
  String sosAlertSmsWithLocation(String name, String link);

  /// Emergency text message, written by the user in the first person, used when no name is set.
  ///
  /// In en, this message translates to:
  /// **'I need help and asked Elderly Care to alert you.'**
  String get sosAlertSmsNoName;

  /// No description provided for @sosAlertSmsNoNameWithLocation.
  ///
  /// In en, this message translates to:
  /// **'I need help and asked Elderly Care to alert you. Current location: {link}'**
  String sosAlertSmsNoNameWithLocation(String link);

  /// No description provided for @familyAddPerson.
  ///
  /// In en, this message translates to:
  /// **'Add person'**
  String get familyAddPerson;

  /// No description provided for @familyNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No family added yet'**
  String get familyNoneTitle;

  /// No description provided for @familyNoneMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the people who look after you so you can reach them quickly.'**
  String get familyNoneMessage;

  /// No description provided for @familyAlertEveryone.
  ///
  /// In en, this message translates to:
  /// **'Alert everyone with my location'**
  String get familyAlertEveryone;

  /// No description provided for @familyEditPerson.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String familyEditPerson(String name);

  /// No description provided for @relativeSaved.
  ///
  /// In en, this message translates to:
  /// **'{name} saved'**
  String relativeSaved(String name);

  /// No description provided for @relativeRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String relativeRemoveTitle(String name);

  /// No description provided for @relativeRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'They will no longer be alerted in an emergency.'**
  String get relativeRemoveMessage;

  /// No description provided for @relativeEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit family member'**
  String get relativeEditTitle;

  /// No description provided for @relativeAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add family member'**
  String get relativeAddTitle;

  /// No description provided for @relativeRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove family member'**
  String get relativeRemove;

  /// No description provided for @relativeName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get relativeName;

  /// No description provided for @relativeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get relativeNameRequired;

  /// No description provided for @relativeRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship (optional)'**
  String get relativeRelationship;

  /// No description provided for @relativeRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Son, Neighbour, Nurse'**
  String get relativeRelationshipHint;

  /// No description provided for @relativePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get relativePhone;

  /// No description provided for @relativePhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get relativePhoneRequired;

  /// No description provided for @relativePhoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'That number looks too short'**
  String get relativePhoneTooShort;

  /// No description provided for @relativeEmail.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get relativeEmail;

  /// No description provided for @videoHeading.
  ///
  /// In en, this message translates to:
  /// **'See and talk to your family'**
  String get videoHeading;

  /// Jitsi Meet is the name of a video call app; keep it unchanged.
  ///
  /// In en, this message translates to:
  /// **'The call opens in your browser or the Jitsi Meet app. It is free and needs no account.'**
  String get videoExplanation;

  /// No description provided for @videoTextFamily.
  ///
  /// In en, this message translates to:
  /// **'Text my family the link'**
  String get videoTextFamily;

  /// No description provided for @videoAddFamilyFirst.
  ///
  /// In en, this message translates to:
  /// **'Add family first'**
  String get videoAddFamilyFirst;

  /// No description provided for @videoVoiceOnly.
  ///
  /// In en, this message translates to:
  /// **'Voice only (no camera)'**
  String get videoVoiceOnly;

  /// No description provided for @videoStartMuted.
  ///
  /// In en, this message translates to:
  /// **'Start with microphone off'**
  String get videoStartMuted;

  /// No description provided for @videoStart.
  ///
  /// In en, this message translates to:
  /// **'Start video call'**
  String get videoStart;

  /// No description provided for @videoOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the video call.'**
  String get videoOpenFailed;

  /// Text message sent to family. name is the user's first name.
  ///
  /// In en, this message translates to:
  /// **'{name} would like a video call. Join here: {link}'**
  String videoInviteSms(String name, String link);

  /// No description provided for @locationOff.
  ///
  /// In en, this message translates to:
  /// **'Location is switched off. Please turn it on in your phone settings.'**
  String get locationOff;

  /// Elderly Care is the app's name.
  ///
  /// In en, this message translates to:
  /// **'Elderly Care needs permission to see your location.'**
  String get locationNoPermission;

  /// No description provided for @locationNotFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find your location.'**
  String get locationNotFound;

  /// Title of the file picker used to restore a backup file.
  ///
  /// In en, this message translates to:
  /// **'Choose your Elderly Care backup'**
  String get shareBackupPickerTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['af', 'en', 'xh', 'zu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'en':
      return AppLocalizationsEn();
    case 'xh':
      return AppLocalizationsXh();
    case 'zu':
      return AppLocalizationsZu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
