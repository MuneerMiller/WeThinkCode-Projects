// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get appTitle => 'Elderly Care';

  @override
  String get commonCancel => 'Kanselleer';

  @override
  String get commonSave => 'Stoor';

  @override
  String get commonDelete => 'Vee uit';

  @override
  String get commonEdit => 'Wysig';

  @override
  String get commonClose => 'Maak toe';

  @override
  String get commonContinue => 'Gaan voort';

  @override
  String get commonBack => 'Terug';

  @override
  String get commonNext => 'Volgende';

  @override
  String get commonDone => 'Klaar';

  @override
  String get commonRemove => 'Verwyder';

  @override
  String get commonCall => 'Bel';

  @override
  String get commonText => 'SMS';

  @override
  String get commonShare => 'Deel';

  @override
  String get commonToday => 'Vandag';

  @override
  String get commonTomorrow => 'Môre';

  @override
  String get commonYesterday => 'Gister';

  @override
  String get commonReadAloud => 'Lees hardop';

  @override
  String get commonStopReading => 'Hou op lees';

  @override
  String get commonReadMedicalDisclaimer => 'Lees die mediese vrywaring';

  @override
  String get greetingMorning => 'Goeiemôre';

  @override
  String get greetingAfternoon => 'Goeiemiddag';

  @override
  String get greetingEvening => 'Goeienaand';

  @override
  String get languageTitle => 'Taal';

  @override
  String get languageSystem => 'Dieselfde as my foon';

  @override
  String get languageReviewNote =>
      'Hierdie vertaling is nuut. As iets vreemd klink, laat weet ons asseblief sodat ons dit kan verbeter.';

  @override
  String get languageEnglishOnlyNote =>
      'Die regsdokumente en die opsommings vir u dokter is in Engels.';

  @override
  String get featureMedicines => 'Medisyne';

  @override
  String get featureMedicinesSubtitle => 'Herinneringe en dosisse';

  @override
  String get featureAppointments => 'Afsprake';

  @override
  String get featureAppointmentsSubtitle => 'Doktersbesoeke';

  @override
  String get featureHealth => 'Gesondheid';

  @override
  String get featureHealthSubtitle => 'Bloeddruk, suiker, gewig, slaap';

  @override
  String get featureFamily => 'My familie';

  @override
  String get featureFamilySubtitle => 'Bel, SMS en waarsku';

  @override
  String get featureHospitals => 'Hospitale naby';

  @override
  String get featureHospitalsSubtitle => 'Soek en kry aanwysings';

  @override
  String get featureVideoCall => 'Video-oproep';

  @override
  String get featureVideoCallSubtitle => 'Sien u familie';

  @override
  String get featureDocuments => 'Dokumente';

  @override
  String get featureDocumentsSubtitle => 'Voorskrifte en verslae';

  @override
  String get featureNotes => 'Notas';

  @override
  String get featureNotesSubtitle => 'Dinge om te onthou';

  @override
  String get medicineTypeTablet => 'Pil';

  @override
  String get medicineTypeCapsule => 'Kapsule';

  @override
  String get medicineTypeSyrup => 'Stroop';

  @override
  String get medicineTypeDrops => 'Druppels';

  @override
  String get medicineTypeInjection => 'Inspuiting';

  @override
  String get medicineTypeInhaler => 'Pompie';

  @override
  String get medicineTypeOther => 'Ander';

  @override
  String get trackerBloodPressure => 'Bloeddruk';

  @override
  String get trackerBloodPressureTip =>
      '\'n Gesonde bloeddruk is onder 120/80 mmHg.';

  @override
  String get trackerBloodSugar => 'Bloedsuiker';

  @override
  String get trackerBloodSugarTip =>
      'Voor u eet (nugter) is 70–100 mg/dL gewoonlik normaal.';

  @override
  String get trackerWeight => 'Gewig';

  @override
  String get trackerWeightTip => 'Weeg uself elke dag op dieselfde tyd.';

  @override
  String get trackerSleep => 'Slaap';

  @override
  String get trackerSleepTip =>
      'Die meeste volwassenes het 7–8 uur slaap nodig.';

  @override
  String get trackerFieldSystolic => 'Sistolies (boonste getal)';

  @override
  String get trackerFieldDiastolic => 'Diastolies (onderste getal)';

  @override
  String get trackerFieldPulse => 'Polsslag';

  @override
  String get trackerFieldGlucose => 'Bloedsuiker';

  @override
  String get trackerFieldWeight => 'Gewig';

  @override
  String get trackerFieldHours => 'Ure geslaap';

  @override
  String get trackerFieldMinutes => 'Ekstra minute';

  @override
  String trackerSleepValue(num hours, num minutes) {
    return '$hours h $minutes min';
  }

  @override
  String notifyDoseTitle(String medicine) {
    return 'Tyd vir $medicine';
  }

  @override
  String get notifyDoseBody => 'Tik op \"Geneem\" sodra u dit geneem het.';

  @override
  String notifyDoseBodyWithDosage(String dosage) {
    return 'Neem $dosage en tik dan op \"Geneem\".';
  }

  @override
  String notifyFollowUpTitle(String medicine) {
    return 'Het u u $medicine geneem?';
  }

  @override
  String notifyFollowUpBody(String time) {
    return 'Dit was om $time gewees. Laat weet ons sodat u rekord reg bly.';
  }

  @override
  String get notifySnoozeBody => 'Ons herinner u weer, soos u gevra het.';

  @override
  String get notifyAppointmentTitle => 'Afspraak oor 1 uur';

  @override
  String get notifyActionTaken => 'Geneem';

  @override
  String get notifyActionSnooze => 'Oor 10 min';

  @override
  String get notifyActionNotYet => 'Nog nie';

  @override
  String get notifyMedicineChannel => 'Medisyne-herinneringe';

  @override
  String get notifyMedicineChannelDescription =>
      'Herinner u wanneer dit tyd is om medisyne te neem';

  @override
  String get notifyAppointmentChannel => 'Afspraakherinneringe';

  @override
  String get notifyAppointmentChannelDescription =>
      'Herinner u \'n uur voor \'n doktersafspraak';

  @override
  String get languageChoose => 'Kies \'n taal';

  @override
  String get profileTitle => 'My profiel';

  @override
  String get profileNotSet => 'Nie ingevul nie';

  @override
  String get profileShowMedicalId => 'Wys my Mediese ID';

  @override
  String get profileContact => 'Kontak';

  @override
  String get profilePhone => 'Foon';

  @override
  String get profileEmail => 'E-pos';

  @override
  String get profileEmergencyNumber => 'Noodnommer';

  @override
  String get profileMedicalDetails => 'Mediese besonderhede';

  @override
  String get profileAge => 'Ouderdom';

  @override
  String get profileGender => 'Geslag';

  @override
  String get profileBloodGroup => 'Bloedgroep';

  @override
  String get profileHeight => 'Lengte';

  @override
  String get profileWeight => 'Gewig';

  @override
  String get profileUsualBloodPressure => 'Gewone bloeddruk';

  @override
  String get profileUsualBloodSugar => 'Gewone bloedsuiker';

  @override
  String get profileAllergies => 'Allergieë';

  @override
  String get profileConditions => 'Mediese toestande';

  @override
  String get profileTextSize => 'Grootte van skrif';

  @override
  String get profileBackup => 'Rugsteun';

  @override
  String get profileThisApp => 'Hierdie app';

  @override
  String get profilePrivacySecurity => 'Privaatheid en sekuriteit';

  @override
  String get profileAppLockOn => 'App-slot is aan';

  @override
  String get profileSetPinHint => 'Stel \'n PIN, sien hoe u data beskerm word';

  @override
  String get profileLegalAbout => 'Regsake en inligting';

  @override
  String get profileLegalAboutSubtitle =>
      'Gebruiksvoorwaardes, mediese vrywaring, privaatheid, lisensies';

  @override
  String get profileEraseAll => 'Vee al my data uit';

  @override
  String get profileEraseTitle => 'Alles uitvee?';

  @override
  String get profileEraseMessage =>
      'Alle medisyne, afsprake, lesings, notas, dokumente en familiekontakte sal uitgevee word. Dit kan nie ongedaan gemaak word nie.';

  @override
  String get profileEraseConfirm => 'Vee uit';

  @override
  String get profileSaved => 'Profiel gestoor';

  @override
  String get profileSave => 'Stoor profiel';

  @override
  String get profileEditTitle => 'Wysig profiel';

  @override
  String get profileName => 'Naam';

  @override
  String get profileNameRequired => 'Tik asseblief u naam in';

  @override
  String get profileEmergencyNumberHint => '112 werk van enige selfoon af';

  @override
  String get profileEmergencyNumberRequired =>
      'Tik asseblief \'n noodnommer in';

  @override
  String get profileBloodGroupHint => 'bv. O+';

  @override
  String get profileBloodPressureHint => 'bv. 120/80';

  @override
  String get profileBloodSugarHint => 'bv. Normaal';

  @override
  String get profileAllergiesHint => 'bv. Penisillien';

  @override
  String get profileConditionsHint => 'bv. Tipe 2-diabetes, hoë bloeddruk';

  @override
  String get profileTextSizeNormal => 'Normaal';

  @override
  String get profileTextSizeLarge => 'Groot';

  @override
  String get profileTextSizeExtraLarge => 'Ekstra groot';

  @override
  String get profileTextSizeExplain =>
      'Maak al die skrif in die app groter. Dit kom by u foon se eie skrifgrootte.';

  @override
  String get backupProtectTitle => 'Beskerm u rugsteun?';

  @override
  String get backupProtectMessage =>
      'Die rugsteun bevat u gesondheidsbesonderhede. \'n Wagwoord hou dit privaat as die lêer in die verkeerde hande beland. Skryf dit neer: sonder die wagwoord kan die rugsteun nie oopgemaak word nie.';

  @override
  String get backupPasswordLabel => 'Rugsteun-wagwoord';

  @override
  String get backupNoPassword => 'Geen wagwoord';

  @override
  String get backupUsePassword => 'Gebruik wagwoord';

  @override
  String get backupShareSubject => 'Elderly Care-rugsteun';

  @override
  String get backupReady =>
      'Rugsteun is gereed. Hou dit op \'n veilige plek, soos u e-pos of in die wolk.';

  @override
  String get backupFailed => 'Kon nie die rugsteun maak nie.';

  @override
  String get backupRestoreTitle => 'Herstel van \'n rugsteun?';

  @override
  String get backupRestoreMessage =>
      'Alles wat nou in die app is, sal vervang word met wat in die rugsteunlêer is.';

  @override
  String get backupChooseFile => 'Kies lêer';

  @override
  String get backupCouldNotReadFile => 'Kon nie daardie lêer lees nie.';

  @override
  String get backupProtectedMessage =>
      'Hierdie rugsteun is beskerm. Tik die wagwoord in wat u gekies het toe u dit gemaak het.';

  @override
  String get backupWrongPasswordRetry =>
      'Daardie wagwoord is nie reg nie. Probeer asseblief weer.';

  @override
  String get backupPasswordTitle => 'Rugsteun-wagwoord';

  @override
  String get backupPassword => 'Wagwoord';

  @override
  String get backupRestore => 'Herstel';

  @override
  String get backupRestored => 'Rugsteun herstel';

  @override
  String get backupBackUp => 'Rugsteun my data';

  @override
  String get backupBackUpSubtitle =>
      'Stoor alles in \'n lêer wat u aan uself kan e-pos of in die wolk kan hou.';

  @override
  String get backupRestoreFrom => 'Herstel van \'n rugsteun';

  @override
  String get backupRestoreFromSubtitle =>
      'Gebruik dit op \'n nuwe foon om u data terug te kry.';

  @override
  String get backupErrorNotBackup =>
      'Hierdie lêer is nie \'n Elderly Care-rugsteun nie.';

  @override
  String get backupErrorTooLarge =>
      'Hierdie lêer is te groot om \'n rugsteun te wees.';

  @override
  String get backupErrorDamaged =>
      'Hierdie rugsteun is beskadig en kon nie gelees word nie.';

  @override
  String get backupErrorNoProfile =>
      'Daar is geen profiel in hierdie rugsteun nie.';

  @override
  String get backupErrorUnknownProtection =>
      'Hierdie rugsteun is beskerm op \'n manier wat die app nie ken nie.';

  @override
  String get securityTitle => 'Privaatheid en sekuriteit';

  @override
  String get securityWrongPin => 'Daardie PIN is nie reg nie.';

  @override
  String get securityTooManyAttempts =>
      'Te veel verkeerde pogings. Wag asseblief \'n rukkie en probeer weer.';

  @override
  String get securityChoosePin => 'Kies \'n PIN';

  @override
  String get securityChoosePinMessage =>
      'U sal hierdie PIN intik om Elderly Care oop te maak. Gebruik 4 tot 8 syfers wat ander mense nie sal raai nie.';

  @override
  String get securityNewPin => 'Nuwe PIN';

  @override
  String get securityPinUnavailable =>
      'Hierdie toestel kan nie \'n PIN veilig bewaar nie, so die app-slot werk nie hier nie.';

  @override
  String get securityAppLockOn => 'App-slot is aan';

  @override
  String get securityAppLockOff => 'App-slot is af';

  @override
  String get securityEnterCurrentPin => 'Tik u huidige PIN in.';

  @override
  String get securityCurrentPin => 'Huidige PIN';

  @override
  String get securityChangePin => 'Verander PIN';

  @override
  String get securityTurnOffAppLock => 'Skakel app-slot af';

  @override
  String get securityAppLock => 'App-slot';

  @override
  String get securityAppLockOnDetail =>
      'Die app vra u PIN wanneer dit oopmaak, en ná 2 minute weg.';

  @override
  String get securityAppLockOffDetail =>
      'Enigiemand wat u foon vashou, kan u gesondheidsbesonderhede sien. \'n PIN hou dit privaat.';

  @override
  String get securityLockNow => 'Sluit nou';

  @override
  String get securityTurnOff => 'Skakel af';

  @override
  String get securityLockWithPin => 'Sluit met \'n PIN';

  @override
  String get securityBiometrics => 'Sluit oop met vingerafdruk of gesig';

  @override
  String get securityMedicalIdWhenLocked => 'Wys Mediese ID wanneer gesluit';

  @override
  String get securityMedicalIdWhenLockedDetail =>
      'Laat paramedici u allergieë en medisyne sien en hulp ontbied sonder u PIN.';

  @override
  String get securityHowProtected => 'Hoe u inligting beskerm word';

  @override
  String get securityEncrypted => 'Geënkripteer op hierdie toestel';

  @override
  String get securityNotEncrypted => 'Nie geënkripteer op hierdie toestel nie';

  @override
  String get securityEncryptedDetail =>
      'U gesondheidsbesonderhede word deurmekaargemaak met \'n sleutel wat veilig op hierdie toestel gebêre word.';

  @override
  String get securityNotEncryptedDetail =>
      'Hierdie blaaier het geen veilige berging nie. Gebruik die foon-app, of maak die webwerf oop met https.';

  @override
  String get securityLocalOnly => 'Net op hierdie toestel gehou';

  @override
  String get securityLocalOnlyDetail =>
      'Daar is geen rekening en geen bediener nie. Niks word opgelaai nie, en daar is geen advertensies of opsporing nie.';

  @override
  String get securitySharedByChoice => 'Net gedeel wanneer u kies';

  @override
  String get securitySharedByChoiceDetail =>
      'Oproepe en SMS\'e gaan deur u eie foon. Gesondheidsopsommings en rugsteune verlaat die app net wanneer u dit stuur.';

  @override
  String get securityHospitalSearch => 'Soek na hospitale';

  @override
  String get securityHospitalSearchDetail =>
      'Om hospitale te vind, word u ligging na die gratis OpenStreetMap-diens gestuur. Niks anders oor u word gestuur nie.';

  @override
  String get securityVideoCalls => 'Video-oproepe';

  @override
  String get securityVideoCallsDetail =>
      'Oproepe gebruik die gratis Jitsi Meet-diens in \'n privaat kamer met \'n lang, lukrake naam. Net mense aan wie u die skakel stuur, kan aansluit.';

  @override
  String get securityNoCloudCopy => 'Geen outomatiese kopie in die wolk nie';

  @override
  String get securityNoCloudCopyDetail =>
      'Die foon kopieer nie hierdie app se data na die wolk nie. Gebruik \"Rugsteun my data\" in My profiel, verkieslik met \'n wagwoord.';

  @override
  String get securityReadPrivacyPolicy =>
      'Lees die volledige privaatheidsbeleid';

  @override
  String get securityEraseAnyTime =>
      'U kan enige tyd alles uitvee in My profiel.';

  @override
  String get medicalIdTitle => 'Mediese ID';

  @override
  String get medicalIdFooter => 'Hou u besonderhede op datum in My profiel.';

  @override
  String get medicalIdNotRecorded => 'Nie aangeteken nie';

  @override
  String get medicalIdAge => 'Ouderdom';

  @override
  String get medicalIdBloodGroup => 'Bloedgroep';

  @override
  String get medicalIdAllergies => 'Allergieë';

  @override
  String get medicalIdConditions => 'Mediese toestande';

  @override
  String get medicalIdMedicines => 'Medisyne';

  @override
  String get medicalIdEmergencyContacts => 'Noodkontakte';

  @override
  String medicalIdCallContact(String name) {
    return 'Bel $name';
  }

  @override
  String medicalIdSpeakTitle(String name) {
    return 'Mediese ID van $name.';
  }

  @override
  String medicalIdSpeakAge(String age) {
    return 'Ouderdom $age.';
  }

  @override
  String medicalIdSpeakBloodGroup(String group) {
    return 'Bloedgroep $group.';
  }

  @override
  String get medicalIdSpeakNoAllergies => 'Geen allergieë aangeteken nie.';

  @override
  String medicalIdSpeakAllergies(String allergies) {
    return 'Allergieë: $allergies.';
  }

  @override
  String medicalIdSpeakConditions(String conditions) {
    return 'Mediese toestande: $conditions.';
  }

  @override
  String medicalIdSpeakMedicines(String medicines) {
    return 'Medisyne: $medicines.';
  }

  @override
  String medicalIdSpeakContact(String name, String phone) {
    return 'Noodkontak: $name, $phone.';
  }

  @override
  String medicalIdSpeakContactWithRelationship(
    String name,
    String relationship,
    String phone,
  ) {
    return 'Noodkontak: $name, $relationship, $phone.';
  }

  @override
  String get secretOk => 'OK';

  @override
  String secretMinDigits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gebruik ten minste $count syfers',
      one: 'Gebruik ten minste 1 syfer',
    );
    return '$_temp0';
  }

  @override
  String secretMinCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gebruik ten minste $count karakters',
      one: 'Gebruik ten minste 1 karakter',
    );
    return '$_temp0';
  }

  @override
  String get secretTypeAgain => 'Tik dit weer in';

  @override
  String get secretNoMatch => 'Die twee is nie dieselfde nie';

  @override
  String get secretShowPin => 'Wys PIN';

  @override
  String get secretShowPassword => 'Wys wagwoord';

  @override
  String get homeMyProfile => 'My profiel';

  @override
  String homeGreeting(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeWhatToDo => 'Wat wil u graag doen?';

  @override
  String get homeSosTitle => 'Ek het hulp nodig';

  @override
  String get homeSosSubtitle => 'Roep hulp of waarsku u familie';

  @override
  String get homeNoMedicines => 'Nog geen medisyne nie';

  @override
  String get homeNoMedicinesHint => 'Voeg een by om herinneringe te kry';

  @override
  String get homeAllMedicinesDone => 'Al die medisyne vir vandag is geneem';

  @override
  String homeDosesTaken(int taken, int total) {
    return '$taken van $total geneem';
  }

  @override
  String homeTimeFor(String medicine) {
    return 'Tyd vir $medicine';
  }

  @override
  String homeNextMedicine(String medicine) {
    return 'Volgende: $medicine';
  }

  @override
  String get homeCheckDose => 'Kontroleer';

  @override
  String homeRefillSoon(String medicine) {
    return 'Kry binnekort meer $medicine';
  }

  @override
  String homeDosesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Net $count dosisse oor',
      one: 'Net 1 dosis oor',
    );
    return '$_temp0';
  }

  @override
  String homeAppointmentWhen(String day, String time) {
    return '$day om $time';
  }

  @override
  String homeSpokenGreeting(String greeting, String name) {
    return '$greeting, $name.';
  }

  @override
  String homeSpokenToday(String date) {
    return 'Vandag is dit $date.';
  }

  @override
  String get homeSpokenNoMedicines => 'U het nog geen medisyne opgestel nie.';

  @override
  String get homeSpokenAllTaken => 'U het al u medisyne vir vandag geneem.';

  @override
  String homeSpokenDoseDue(String medicine, String time) {
    return 'Dit is tyd vir $medicine om $time.';
  }

  @override
  String homeSpokenDoseDueWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'Dit is tyd vir $medicine, $dosage, om $time.';
  }

  @override
  String homeSpokenDoseNext(String medicine, String time) {
    return 'U volgende medisyne is $medicine om $time.';
  }

  @override
  String homeSpokenDoseNextWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'U volgende medisyne is $medicine, $dosage, om $time.';
  }

  @override
  String homeSpokenRefill(String medicine) {
    return 'Onthou om binnekort meer $medicine te kry.';
  }

  @override
  String homeSpokenAppointment(String doctor, String day, String time) {
    return 'U volgende afspraak is met $doctor, $day om $time.';
  }

  @override
  String get lockEnterPin => 'Tik u PIN in';

  @override
  String get lockPinTooShort => 'U PIN het ten minste 4 syfers.';

  @override
  String lockPinWrong(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'Nog $left kanse',
      one: 'Nog 1 kans',
    );
    return 'Daardie PIN is nie reg nie. $_temp0 voordat u kort moet wag.';
  }

  @override
  String get lockTooManyTries => 'Te veel verkeerde pogings.';

  @override
  String lockWait(String time) {
    return 'Te veel verkeerde pogings. Probeer weer oor $time.';
  }

  @override
  String lockPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count syfers ingetik',
      one: '1 syfer ingetik',
    );
    return '$_temp0';
  }

  @override
  String get lockUseBiometrics => 'Gebruik vingerafdruk of gesig';

  @override
  String get lockEmergency => 'Nood';

  @override
  String get lockForgotPin => 'PIN vergeet?';

  @override
  String lockCallNumber(String number) {
    return 'Bel $number';
  }

  @override
  String get lockMedicalIdHidden =>
      'Die Mediese ID is versteek terwyl die app gesluit is.';

  @override
  String get lockForgotTitle => 'U PIN vergeet?';

  @override
  String get lockForgotBody =>
      'Vir u privaatheid kan die PIN nie teruggekry word nie. U kan alles in die app uitvee en van voor af begin. As u \'n rugsteun gemaak het, kan u dit daarna in My profiel herstel.';

  @override
  String get lockEraseEverything => 'Vee alles uit en begin van voor af';

  @override
  String get lockEraseConfirm => 'Ja, vee alles uit';

  @override
  String get lockEraseWarning =>
      'Dit kan nie ongedaan gemaak word nie. Tik weer om te bevestig.';

  @override
  String get lockKeyDelete => 'Vee uit';

  @override
  String get lockKeyUnlock => 'Sluit oop';

  @override
  String get onboardingSkip => 'Slaan oor';

  @override
  String get onboardingGetStarted => 'Kom ons begin';

  @override
  String get onboardingMedicinesTitle => 'Moet nooit u medisyne mis nie';

  @override
  String get onboardingMedicinesText =>
      'Kry \'n herinnering wanneer elke dosis tyd is, en laat u familie weet as een gemis word.';

  @override
  String get onboardingAppointmentsTitle => 'Onthou u afsprake';

  @override
  String get onboardingAppointmentsText =>
      'Hou al u doktersbesoeke op een plek en kry \'n uur vooraf \'n herinnering.';

  @override
  String get onboardingHealthTitle => 'Hou u gesondheid dop';

  @override
  String get onboardingHealthText =>
      'Teken u bloeddruk, bloedsuiker, gewig en slaap aan, en sien hoe dit verander.';

  @override
  String get onboardingHospitalsTitle => 'Kry hulp naby';

  @override
  String get onboardingHospitalsText =>
      'Sien die naaste hospitale en klinieke, met aanwysings en telefoonnommers.';

  @override
  String get onboardingFamilyTitle => 'U familie is net een tik weg';

  @override
  String get onboardingFamilyText =>
      'Bel, SMS of maak \'n video-oproep na u familie, of stuur hulle u ligging in \'n noodgeval.';

  @override
  String get setupWelcome => 'Welkom by Elderly Care';

  @override
  String get setupIntro =>
      'Net \'n paar besonderhede om te begin. Alles bly op hierdie foon.';

  @override
  String get setupAboutYou => 'Oor u';

  @override
  String get setupYourName => 'U naam';

  @override
  String get setupNameRequired => 'Tik asseblief u naam in';

  @override
  String get setupYourPhone => 'U foonnommer (opsioneel)';

  @override
  String get setupEmergencyContact => 'Noodkontak';

  @override
  String get setupEmergencyContactInfo =>
      'Iemand wat ons vir u kan bel of SMS wanneer u hulp nodig het.';

  @override
  String get setupTheirName => 'Hulle naam';

  @override
  String get setupRelationship => 'Verwantskap';

  @override
  String get setupRelationshipHint => 'bv. Dogter';

  @override
  String get setupTheirPhone => 'Hulle foonnommer';

  @override
  String get setupTheirPhoneRequired => 'Tik asseblief hulle foonnommer in';

  @override
  String get setupAddMoreLater => 'U kan later nog familielede byvoeg.';

  @override
  String get legalDocTerms => 'Gebruiksvoorwaardes';

  @override
  String get legalDocMedical => 'Mediese vrywaring';

  @override
  String get legalDocPrivacy => 'Privaatheidsbeleid';

  @override
  String get legalDocAccessibility => 'Toeganklikheidsverklaring';

  @override
  String get legalDocCredits => 'Erkennings en kennisgewings van derdes';

  @override
  String get legalReadTerms => 'Lees die gebruiksvoorwaardes';

  @override
  String get legalReadPrivacy => 'Lees die privaatheidsbeleid';

  @override
  String get legalEnglishOnly =>
      'Hierdie dokument is net in Engels beskikbaar. Die Engelse weergawe is die bindende een.';

  @override
  String get legalHubTitle => 'Regsake en inligting';

  @override
  String get legalOpenSourceLicences => 'Oopbron-lisensies';

  @override
  String legalAppVersion(String version) {
    return 'Elderly Care, weergawe $version';
  }

  @override
  String legalVersion(String version) {
    return 'Weergawe $version';
  }

  @override
  String legalAcceptedOn(int version, String date) {
    return 'U het weergawe $version van hierdie dokumente op $date aanvaar.';
  }

  @override
  String get legalAgree =>
      'Ek stem in tot die Gebruiksvoorwaardes, en ek het die Mediese vrywaring en die Privaatheidsbeleid gelees';

  @override
  String get legalTickBox => 'Merk asseblief die blokkie om voort te gaan.';

  @override
  String get legalNotMedicalService =>
      'Elderly Care is nie \'n mediese diens nie. Bel 112 in \'n noodgeval.';

  @override
  String get legalReviewTitle => 'Lees asseblief ons voorwaardes deur';

  @override
  String get legalUpdatedTitle => 'Ons voorwaardes is bygewerk';

  @override
  String legalUpdateBody(int version, String date) {
    return 'Voordat u voortgaan, lees en aanvaar asseblief die Gebruiksvoorwaardes, die Mediese vrywaring en die Privaatheidsbeleid (weergawe $version, geldig vanaf $date). U inligting bly op hierdie toestel.';
  }

  @override
  String get medicinesTitle => 'Medisyne';

  @override
  String get medicinesAdd => 'Voeg medisyne by';

  @override
  String get medicinesEmptyTitle => 'Nog geen medisyne nie';

  @override
  String get medicinesEmptyMessage =>
      'Voeg u medisyne by, dan herinner ons u wanneer elke dosis tyd is.';

  @override
  String get medicinesTodaySchedule => 'Vandag se skedule';

  @override
  String medicinesTakenToday(int taken, int total) {
    return '$taken van $total geneem';
  }

  @override
  String get medicinesMine => 'My medisyne';

  @override
  String medicinesTimesADay(int count) {
    return '$count× per dag';
  }

  @override
  String get medicinesDisclaimer =>
      'Neem altyd u medisyne soos u dokter of apteker gesê het. Herinneringe kan soms laat wees, so moenie net daarop staatmaak nie.';

  @override
  String medicinesSupplyLow(int count) {
    return 'Net $count dosisse oor – tyd om meer te kry';
  }

  @override
  String medicinesSupplyLeft(int count, int days) {
    return '$count dosisse oor (omtrent $days dae)';
  }

  @override
  String medicinesLastWeek(int taken, int due) {
    return 'Laaste 7 dae: $taken van $due dosisse geneem';
  }

  @override
  String get medicinesLateTitle => 'Herinneringe kan laat kom';

  @override
  String get medicinesLateMessage =>
      'U foon spaar battery deur herinneringe uit te stel. Gee Elderly Care toestemming om u op die presiese tyd te herinner.';

  @override
  String get medicinesLateAllow => 'Laat betyds herinneringe toe';

  @override
  String get doseStatusTaken => 'Geneem';

  @override
  String get doseStatusNotTaken => 'Nie geneem nie';

  @override
  String get doseStatusOverdue => 'Laat';

  @override
  String get doseStatusDue => 'Nou tyd';

  @override
  String get doseStatusLater => 'Later';

  @override
  String doseRowSubtitle(String time, String status) {
    return '$time · $status';
  }

  @override
  String get doseCheck => 'Kontroleer';

  @override
  String get doseCheckTitle => 'Medisyne-kontrole';

  @override
  String doseCheckQuestion(String medicine) {
    return 'Het u u $medicine geneem?';
  }

  @override
  String doseCheckWhen(String day, String time) {
    return '$day om $time';
  }

  @override
  String get doseCheckYes => 'Ja, ek het dit geneem';

  @override
  String get doseCheckNo => 'Nee, nog nie';

  @override
  String get doseTellFamilyTitle => 'Laat u familie weet?';

  @override
  String doseTellFamilyMessage(String names, String medicine) {
    return 'Ons kan \'n SMS aan $names stuur om te sê dat u u $medicine gemis het.';
  }

  @override
  String get doseTellFamilySend => 'Stuur SMS';

  @override
  String doseMissedSms(String name, String medicine, String time) {
    return '$name het nie vandag $medicine ($time) geneem nie. Kyk asseblief hoe dit gaan.';
  }

  @override
  String doseMissedSmsNoName(String medicine, String time) {
    return 'Ek het nie vandag $medicine ($time) geneem nie. Kyk asseblief hoe dit met my gaan.';
  }

  @override
  String doseRecordedTaken(String medicine) {
    return 'Mooi so! $medicine aangeteken.';
  }

  @override
  String doseRecordedNotTaken(String medicine) {
    return 'Genoteer. $medicine nie geneem nie.';
  }

  @override
  String doseTakenFromNotification(String medicine) {
    return '$medicine as geneem aangeteken. Mooi so!';
  }

  @override
  String doseSnoozed(String medicine) {
    return 'Ons sal u oor 10 minute weer aan $medicine herinner.';
  }

  @override
  String get medicineEditTitle => 'Wysig medisyne';

  @override
  String get medicineEditSaveChanges => 'Stoor veranderinge';

  @override
  String get medicineEditSaveNew => 'Stoor herinnering';

  @override
  String get medicineEditDeleteTooltip => 'Vee medisyne uit';

  @override
  String medicineEditDeleteTitle(String medicine) {
    return 'Vee $medicine uit?';
  }

  @override
  String get medicineEditDeleteMessage =>
      'U sal nie meer herinneringe vir hierdie medisyne kry nie.';

  @override
  String medicineEditReminderSet(String medicine) {
    return 'Herinnering gestel vir $medicine';
  }

  @override
  String medicineEditSaved(String medicine) {
    return '$medicine gestoor';
  }

  @override
  String get medicineEditNameLabel => 'Naam van medisyne';

  @override
  String get medicineEditNameHint => 'bv. Metformin';

  @override
  String get medicineEditNameRequired =>
      'Tik asseblief die naam van die medisyne in';

  @override
  String get medicineEditDosageLabel => 'Hoeveel (opsioneel)';

  @override
  String get medicineEditDosageHint => 'bv. 1 pil, 500 mg';

  @override
  String get medicineEditSupplyLabel => 'Dosisse oor in die pakkie (opsioneel)';

  @override
  String get medicineEditSupplyHint => 'bv. 30';

  @override
  String get medicineEditSupplyHelper =>
      'Ons sal u laat weet wanneer dit tyd is om meer te kry.';

  @override
  String get medicineEditSupplyInvalid => 'Tik asseblief \'n heel getal in';

  @override
  String get medicineEditType => 'Soort';

  @override
  String get medicineEditHowOften => 'Hoeveel keer per dag?';

  @override
  String get medicineEditOnce => 'Een keer';

  @override
  String get medicineEditTwice => 'Twee keer';

  @override
  String get medicineEditThreeTimes => '3 keer';

  @override
  String get medicineEditAtWhatTimes => 'Op watter tye?';

  @override
  String medicineEditDoseNumber(int number) {
    return 'Dosis $number';
  }

  @override
  String medicineEditDoseTime(int number) {
    return 'Tyd vir dosis $number';
  }

  @override
  String get medicineEditChange => 'Verander';

  @override
  String get appointmentsTitle => 'Afsprake';

  @override
  String appointmentsUpcomingTab(int count) {
    return 'Komende ($count)';
  }

  @override
  String appointmentsPastTab(int count) {
    return 'Verby ($count)';
  }

  @override
  String get appointmentsAdd => 'Voeg afspraak by';

  @override
  String get appointmentsNoPast => 'Geen vorige afsprake nie';

  @override
  String get appointmentsNoUpcoming => 'Geen komende afsprake nie';

  @override
  String get appointmentsNoPastMessage =>
      'Afsprake skuif hierheen sodra hulle verby is.';

  @override
  String get appointmentsNoUpcomingMessage =>
      'Voeg u volgende doktersbesoek by, dan herinner ons u \'n uur vooraf.';

  @override
  String get appointmentsAttended => 'Bygewoon';

  @override
  String get appointmentEditTitle => 'Afspraak';

  @override
  String get appointmentEditNewTitle => 'Nuwe afspraak';

  @override
  String get appointmentEditSaveChanges => 'Stoor veranderinge';

  @override
  String get appointmentEditSaveNew => 'Stoor afspraak';

  @override
  String get appointmentEditDeleteTooltip => 'Vee afspraak uit';

  @override
  String get appointmentEditDeleteTitle => 'Vee afspraak uit?';

  @override
  String appointmentEditDeleteMessage(String doctor) {
    return 'U afspraak met $doctor sal verwyder word.';
  }

  @override
  String appointmentEditSaved(String doctor) {
    return 'Afspraak met $doctor gestoor';
  }

  @override
  String get appointmentEditDoctorLabel => 'Dokter se naam';

  @override
  String get appointmentEditDoctorHint => 'bv. Dr. Naidoo';

  @override
  String get appointmentEditDoctorRequired =>
      'Tik asseblief die dokter se naam in';

  @override
  String get appointmentEditSpecialtyLabel => 'Soort dokter (opsioneel)';

  @override
  String get appointmentEditSpecialtyHint => 'bv. Hartspesialis';

  @override
  String get appointmentEditPlaceLabel => 'Waar (opsioneel)';

  @override
  String get appointmentEditPlaceHint => 'Hospitaal, kliniek of huisbesoek';

  @override
  String get appointmentEditWhen => 'Wanneer';

  @override
  String get appointmentEditChange => 'Verander';

  @override
  String get appointmentEditNotesLabel => 'Notas (opsioneel)';

  @override
  String get appointmentEditNotesHint =>
      'Vrae om te vra, dinge om saam te bring…';

  @override
  String get appointmentEditAttended => 'Ek het hierdie afspraak bygewoon';

  @override
  String get notesTitle => 'Notas';

  @override
  String get notesNew => 'Nuwe nota';

  @override
  String get notesEmptyTitle => 'Nog geen notas nie';

  @override
  String get notesEmptyMessage =>
      'Skryf dinge neer om te onthou, vrae vir die dokter, of enigiets anders.';

  @override
  String notesUpdated(String day) {
    return 'Bygewerk $day';
  }

  @override
  String notesImportantUpdated(String day) {
    return 'Belangrik · Bygewerk $day';
  }

  @override
  String get noteEditTitle => 'Wysig nota';

  @override
  String get noteEditSave => 'Stoor nota';

  @override
  String get noteEditSaved => 'Nota gestoor';

  @override
  String get noteEditDeleteTooltip => 'Vee nota uit';

  @override
  String get noteEditDeleteTitle => 'Vee hierdie nota uit?';

  @override
  String noteEditDeleteMessage(String title) {
    return '\"$title\" sal verwyder word.';
  }

  @override
  String get noteEditTitleLabel => 'Titel';

  @override
  String get noteEditTitleRequired => 'Tik asseblief \'n titel in';

  @override
  String get noteEditBodyLabel => 'Nota';

  @override
  String get noteEditHowImportant => 'Hoe belangrik is dit?';

  @override
  String get noteEditImportant => 'Belangrik';

  @override
  String get noteEditNormal => 'Gewoon';

  @override
  String get healthIntro =>
      'Hou rekord van u lesings, en tik dan op Deel om \'n opsomming aan u dokter te stuur.';

  @override
  String get healthDisclaimer =>
      'Die wenke hier is algemene inligting vir volwassenes, nie mediese advies nie. Vra u dokter watter lesings vir u reg is. As u baie siek voel, bel 112.';

  @override
  String get healthNoReadings => 'Nog geen lesings nie';

  @override
  String healthShareSubject(String name) {
    return 'Gesondheidsopsomming van $name';
  }

  @override
  String get healthShareSubjectNoName => 'My gesondheidsopsomming';

  @override
  String get healthShareTitle =>
      'Stuur \'n opsomming van die laaste 30 dae aan u dokter';

  @override
  String get healthShareAsPdf => 'As \'n PDF-dokument';

  @override
  String get healthShareAsPdfSubtitle => 'Netjiese tabelle, maklik om te druk';

  @override
  String get healthShareAsText => 'As \'n boodskap';

  @override
  String get healthShareAsTextSubtitle => 'Gewone teks vir e-pos of WhatsApp';

  @override
  String get trackingAddReading => 'Voeg lesing by';

  @override
  String get trackingFirstReading => 'Voeg u eerste lesing by om te begin.';

  @override
  String get trackingOneMore =>
      'Voeg nog een lesing by om \'n grafiek te sien.';

  @override
  String get trackingReadings => 'Lesings';

  @override
  String get trackingDeleteReading => 'Vee lesing uit';

  @override
  String get trackingDeleteReadingTitle => 'Vee lesing uit?';

  @override
  String trackingDeleteReadingMessage(String reading, String day) {
    return '$reading op $day';
  }

  @override
  String trackingChartLabel(int count, String type, String latest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Grafiek van $type vir die laaste $count lesings. Nuutste $latest.',
    );
    return '$_temp0';
  }

  @override
  String trackingFieldRequired(String field) {
    return 'Tik asseblief $field in';
  }

  @override
  String get trackingEnterNumber => 'Tik asseblief \'n getal in';

  @override
  String trackingOutOfRange(String min, String max) {
    return 'Moet tussen $min en $max wees';
  }

  @override
  String trackingReadingSaved(String type) {
    return 'Lesing vir $type gestoor';
  }

  @override
  String get trackingSaveReading => 'Stoor lesing';

  @override
  String trackingNewReadingTitle(String type) {
    return 'Nuwe lesing: $type';
  }

  @override
  String get trackingChangeTime => 'Verander';

  @override
  String get trackingNotes => 'Notas (opsioneel)';

  @override
  String get trackingNotesHint => 'bv. ná ontbyt';

  @override
  String get documentTakePhoto => 'Neem \'n foto';

  @override
  String get documentChooseFromGallery => 'Kies uit galery';

  @override
  String get documentPickFailed => 'Kon nie die kamera of galery oopmaak nie.';

  @override
  String get documentAdd => 'Voeg dokument by';

  @override
  String get documentNoneTitle => 'Nog geen dokumente nie';

  @override
  String get documentNoneMessage =>
      'Neem foto\'s van voorskrifte, toetsuitslae en mediese fonds-kaarte sodat u dit byderhand het.';

  @override
  String get documentSearch => 'Soek dokumente';

  @override
  String documentNoMatch(String query) {
    return 'Niks pas by \"$query\" nie.';
  }

  @override
  String get documentSaved => 'Dokument gestoor';

  @override
  String get documentSave => 'Stoor dokument';

  @override
  String get documentName => 'Naam';

  @override
  String get documentNameHint => 'bv. Bloedtoets Maart';

  @override
  String get documentNameRequired =>
      'Tik asseblief \'n naam in sodat u dit later kan kry';

  @override
  String get documentDelete => 'Vee dokument uit';

  @override
  String documentDeleteTitle(String name) {
    return 'Vee $name uit?';
  }

  @override
  String get documentDeleteMessage =>
      'Hierdie foto sal uit die app verwyder word.';

  @override
  String get hospitalRefresh => 'Herlaai';

  @override
  String hospitalEmergencyCall(String number) {
    return 'Noodgeval? Bel $number';
  }

  @override
  String get hospitalSearching => 'Soek hospitale naby u…';

  @override
  String get hospitalSearchFailed => 'Kon nie soek nie';

  @override
  String get hospitalCheckInternet =>
      'Kyk asseblief of u internet werk en probeer weer.';

  @override
  String get hospitalTryAgain => 'Probeer weer';

  @override
  String get hospitalNoneFound => 'Niks binne 10 km gevind nie';

  @override
  String get hospitalNoneFoundMessage =>
      'Bel die nommer hierbo in \'n noodgeval.';

  @override
  String hospitalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plekke binne 10 km',
      one: '1 plek binne 10 km',
    );
    return '$_temp0';
  }

  @override
  String get hospitalListNote =>
      'Hierdie lys kom van OpenStreetMap en is dalk nie volledig of op datum nie. Nie elke plek het \'n noodeenheid nie: bel eers as u kan.';

  @override
  String get hospitalAttribution => 'Data © OpenStreetMap-bydraers';

  @override
  String hospitalDistanceMeters(int meters) {
    return '$meters m weg';
  }

  @override
  String hospitalDistanceKm(String km) {
    return '$km km weg';
  }

  @override
  String get hospitalDirections => 'Aanwysings';

  @override
  String get sosTitle => 'Hoe kan ons help?';

  @override
  String get sosCallEmergency => 'Bel nooddienste';

  @override
  String sosDial(String number) {
    return 'Skakel $number';
  }

  @override
  String get sosAlertFamily => 'Waarsku my familie';

  @override
  String get sosAlertFamilySubtitle => 'SMS almal my ligging';

  @override
  String get sosShowMedicalId => 'Wys my Mediese ID';

  @override
  String get sosShowMedicalIdSubtitle =>
      'Allergieë, medisyne en kontakte vir helpers';

  @override
  String sosCallPerson(String name) {
    return 'Bel $name';
  }

  @override
  String get sosAddFamilyFirst =>
      'Voeg \'n familielid by sodat ons weet wie om te waarsku.';

  @override
  String get sosAddFamily => 'Voeg familie by';

  @override
  String get sosFindingLocation => 'Soek u ligging…';

  @override
  String sosSendingWithoutLocation(String problem) {
    return '$problem Stuur sonder ligging.';
  }

  @override
  String get sosLocationUnavailable =>
      'Ligging nie beskikbaar nie. Stuur sonder ligging.';

  @override
  String sosAlertSms(String name) {
    return '$name het hulp nodig en het Elderly Care gevra om u te waarsku.';
  }

  @override
  String sosAlertSmsWithLocation(String name, String link) {
    return '$name het hulp nodig en het Elderly Care gevra om u te waarsku. Huidige ligging: $link';
  }

  @override
  String get sosAlertSmsNoName =>
      'Ek het hulp nodig en het Elderly Care gevra om u te waarsku.';

  @override
  String sosAlertSmsNoNameWithLocation(String link) {
    return 'Ek het hulp nodig en het Elderly Care gevra om u te waarsku. Huidige ligging: $link';
  }

  @override
  String get familyAddPerson => 'Voeg persoon by';

  @override
  String get familyNoneTitle => 'Nog geen familie bygevoeg nie';

  @override
  String get familyNoneMessage =>
      'Voeg die mense by wat na u omsien, sodat u hulle vinnig kan bereik.';

  @override
  String get familyAlertEveryone => 'Waarsku almal met my ligging';

  @override
  String familyEditPerson(String name) {
    return 'Wysig $name';
  }

  @override
  String relativeSaved(String name) {
    return '$name gestoor';
  }

  @override
  String relativeRemoveTitle(String name) {
    return 'Verwyder $name?';
  }

  @override
  String get relativeRemoveMessage =>
      'Hulle sal nie meer in \'n noodgeval gewaarsku word nie.';

  @override
  String get relativeEditTitle => 'Wysig familielid';

  @override
  String get relativeAddTitle => 'Voeg familielid by';

  @override
  String get relativeRemove => 'Verwyder familielid';

  @override
  String get relativeName => 'Naam';

  @override
  String get relativeNameRequired => 'Tik asseblief \'n naam in';

  @override
  String get relativeRelationship => 'Verwantskap (opsioneel)';

  @override
  String get relativeRelationshipHint => 'bv. Seun, Buurvrou, Verpleegster';

  @override
  String get relativePhone => 'Foonnommer';

  @override
  String get relativePhoneRequired => 'Tik asseblief \'n foonnommer in';

  @override
  String get relativePhoneTooShort => 'Daardie nommer lyk te kort';

  @override
  String get relativeEmail => 'E-pos (opsioneel)';

  @override
  String get videoHeading => 'Sien en praat met u familie';

  @override
  String get videoExplanation =>
      'Die oproep maak oop in u blaaier of in die Jitsi Meet-app. Dit is gratis en u het nie \'n rekening nodig nie.';

  @override
  String get videoTextFamily => 'SMS die skakel aan my familie';

  @override
  String get videoAddFamilyFirst => 'Voeg eers familie by';

  @override
  String get videoVoiceOnly => 'Net klank (geen kamera)';

  @override
  String get videoStartMuted => 'Begin met mikrofoon af';

  @override
  String get videoStart => 'Begin video-oproep';

  @override
  String get videoOpenFailed => 'Kon nie die video-oproep oopmaak nie.';

  @override
  String videoInviteSms(String name, String link) {
    return '$name wil graag \'n video-oproep maak. Sluit hier aan: $link';
  }

  @override
  String get locationOff =>
      'Ligging is afgeskakel. Skakel dit asseblief aan in u foon se instellings.';

  @override
  String get locationNoPermission =>
      'Elderly Care het toestemming nodig om u ligging te sien.';

  @override
  String get locationNotFound => 'Ons kon nie u ligging vind nie.';

  @override
  String get shareBackupPickerTitle => 'Kies u Elderly Care-rugsteun';
}
