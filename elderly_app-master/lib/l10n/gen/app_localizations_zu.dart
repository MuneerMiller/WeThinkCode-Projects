// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Zulu (`zu`).
class AppLocalizationsZu extends AppLocalizations {
  AppLocalizationsZu([String locale = 'zu']) : super(locale);

  @override
  String get appTitle => 'Elderly Care';

  @override
  String get commonCancel => 'Khansela';

  @override
  String get commonSave => 'Londoloza';

  @override
  String get commonDelete => 'Susa';

  @override
  String get commonEdit => 'Lungisa';

  @override
  String get commonClose => 'Vala';

  @override
  String get commonContinue => 'Qhubeka';

  @override
  String get commonBack => 'Emuva';

  @override
  String get commonNext => 'Okulandelayo';

  @override
  String get commonDone => 'Kuqediwe';

  @override
  String get commonRemove => 'Khipha';

  @override
  String get commonCall => 'Shayela';

  @override
  String get commonText => 'I-SMS';

  @override
  String get commonShare => 'Thumela';

  @override
  String get commonToday => 'Namuhla';

  @override
  String get commonTomorrow => 'Kusasa';

  @override
  String get commonYesterday => 'Izolo';

  @override
  String get commonReadAloud => 'Ngifundele';

  @override
  String get commonStopReading => 'Yeka ukufunda';

  @override
  String get commonReadMedicalDisclaimer => 'Funda isexwayiso sezempilo';

  @override
  String get greetingMorning => 'Sanibonani ekuseni';

  @override
  String get greetingAfternoon => 'Sanibonani ntambama';

  @override
  String get greetingEvening => 'Sanibonani kusihlwa';

  @override
  String get languageTitle => 'Ulimi';

  @override
  String get languageSystem => 'Njengasefonini yami';

  @override
  String get languageReviewNote =>
      'Lokhu kuhumusha kusha. Uma kukhona okungazwakali kahle, ngicela nisitshele ukuze sikulungise.';

  @override
  String get languageEnglishOnlyNote =>
      'Amaphepha omthetho nemibiko eya kudokotela wenu kungesiNgisi.';

  @override
  String get featureMedicines => 'Imithi';

  @override
  String get featureMedicinesSubtitle => 'Izikhumbuzo nemithamo';

  @override
  String get featureAppointments => 'Ama-appointment';

  @override
  String get featureAppointmentsSubtitle => 'Ukubona udokotela';

  @override
  String get featureHealth => 'Impilo yami';

  @override
  String get featureHealthSubtitle => 'BP, ushukela, isisindo, ukulala';

  @override
  String get featureFamily => 'Umndeni wami';

  @override
  String get featureFamilySubtitle => 'Shayela, i-SMS nesexwayiso';

  @override
  String get featureHospitals => 'Izibhedlela eziseduze';

  @override
  String get featureHospitalsSubtitle => 'Thola nendlela yokufika';

  @override
  String get featureVideoCall => 'Ikholi yevidiyo';

  @override
  String get featureVideoCallSubtitle => 'Bonani umndeni wenu';

  @override
  String get featureDocuments => 'Amaphepha';

  @override
  String get featureDocumentsSubtitle => 'Ama-script nemiphumela';

  @override
  String get featureNotes => 'Amanothi';

  @override
  String get featureNotesSubtitle => 'Izinto zokukhumbula';

  @override
  String get medicineTypeTablet => 'Iphilisi';

  @override
  String get medicineTypeCapsule => 'Ikhepsuli';

  @override
  String get medicineTypeSyrup => 'Isiraphu';

  @override
  String get medicineTypeDrops => 'Amaconsi';

  @override
  String get medicineTypeInjection => 'Umjovo';

  @override
  String get medicineTypeInhaler => 'Impompo';

  @override
  String get medicineTypeOther => 'Okunye';

  @override
  String get trackerBloodPressure => 'Umfutho wegazi';

  @override
  String get trackerBloodPressureTip =>
      'Umfutho wegazi omuhle ungaphansi kuka-120/80 mmHg.';

  @override
  String get trackerBloodSugar => 'Ushukela egazini';

  @override
  String get trackerBloodSugarTip =>
      'Uma ningakadli lutho, ushukela ovamile u-70–100 mg/dL.';

  @override
  String get trackerWeight => 'Isisindo';

  @override
  String get trackerWeightTip =>
      'Zikaleni isisindo ngesikhathi esifanayo nsuku zonke.';

  @override
  String get trackerSleep => 'Ukulala';

  @override
  String get trackerSleepTip =>
      'Abantu abadala abaningi badinga ukulala amahora angu-7–8.';

  @override
  String get trackerFieldSystolic => 'I-systolic (inombolo engenhla)';

  @override
  String get trackerFieldDiastolic => 'I-diastolic (inombolo engezansi)';

  @override
  String get trackerFieldPulse => 'Ukushaya kwenhliziyo';

  @override
  String get trackerFieldGlucose => 'Ushukela egazini';

  @override
  String get trackerFieldWeight => 'Isisindo';

  @override
  String get trackerFieldHours => 'Amahora enilele ngawo';

  @override
  String get trackerFieldMinutes => 'Imizuzu engeziwe';

  @override
  String trackerSleepValue(num hours, num minutes) {
    return '$hours h $minutes min';
  }

  @override
  String notifyDoseTitle(String medicine) {
    return 'Isikhathi sika-$medicine';
  }

  @override
  String get notifyDoseBody =>
      'Cindezelani \"Ngiwuthathile\" uma senithathe umuthi.';

  @override
  String notifyDoseBodyWithDosage(String dosage) {
    return 'Thathani $dosage, bese nicindezela \"Ngiwuthathile\".';
  }

  @override
  String notifyFollowUpTitle(String medicine) {
    return 'Niyithathile i-$medicine?';
  }

  @override
  String notifyFollowUpBody(String time) {
    return 'Bekufanele niyithathe ngo-$time. Ngicela nisitshele ukuze umlando wenu uhlale ulungile.';
  }

  @override
  String get notifySnoozeBody => 'Siyanikhumbuza futhi, njengoba nicelile.';

  @override
  String get notifyAppointmentTitle => 'I-appointment ngemuva kwehora eli-1';

  @override
  String get notifyActionTaken => 'Ngiwuthathile';

  @override
  String get notifyActionSnooze => 'Emizuzwini eyi-10';

  @override
  String get notifyActionNotYet => 'Angikawuthathi';

  @override
  String get notifyMedicineChannel => 'Izikhumbuzo zemithi';

  @override
  String get notifyMedicineChannelDescription =>
      'Inikhumbuza uma sekuyisikhathi sokuthatha umuthi';

  @override
  String get notifyAppointmentChannel => 'Izikhumbuzo zama-appointment';

  @override
  String get notifyAppointmentChannelDescription =>
      'Inikhumbuza ihora elilodwa ngaphambi kwe-appointment kadokotela';

  @override
  String get languageChoose => 'Khethani ulimi';

  @override
  String get profileTitle => 'Iphrofayili yami';

  @override
  String get profileNotSet => 'Akufakiwe';

  @override
  String get profileShowMedicalId => 'Bonisa i-Medical ID yami';

  @override
  String get profileContact => 'Ukuxhumana';

  @override
  String get profilePhone => 'Ifoni';

  @override
  String get profileEmail => 'I-imeyili';

  @override
  String get profileEmergencyNumber => 'Inombolo yezimo eziphuthumayo';

  @override
  String get profileMedicalDetails => 'Imininingwane yezempilo';

  @override
  String get profileAge => 'Iminyaka';

  @override
  String get profileGender => 'Ubulili';

  @override
  String get profileBloodGroup => 'Uhlobo lwegazi';

  @override
  String get profileHeight => 'Ubude';

  @override
  String get profileWeight => 'Isisindo';

  @override
  String get profileUsualBloodPressure => 'Umfutho wegazi ovamile';

  @override
  String get profileUsualBloodSugar => 'Ushukela ovamile egazini';

  @override
  String get profileAllergies => 'Ama-allergy';

  @override
  String get profileConditions => 'Izifo enginazo';

  @override
  String get profileTextSize => 'Ubukhulu bombhalo';

  @override
  String get profileBackup => 'I-backup';

  @override
  String get profileThisApp => 'Le app';

  @override
  String get profilePrivacySecurity => 'Ubumfihlo nokuphepha';

  @override
  String get profileAppLockOn => 'Ukukhiya i-app kuvuliwe';

  @override
  String get profileSetPinHint =>
      'Faka i-PIN, nibone ukuthi imininingwane yenu ivikelwa kanjani';

  @override
  String get profileLegalAbout => 'Umthetho nemininingwane';

  @override
  String get profileLegalAboutSubtitle =>
      'Imigomo, isexwayiso sezempilo, ubumfihlo, amalayisense';

  @override
  String get profileEraseAll => 'Sula yonke idatha yami';

  @override
  String get profileEraseTitle => 'Kusulwe konke?';

  @override
  String get profileEraseMessage =>
      'Yonke imithi, ama-appointment, izilinganiso, amanothi, amaphepha nezinombolo zomndeni kuzosuswa. Lokhu ngeke kubuyiswe.';

  @override
  String get profileEraseConfirm => 'Sula';

  @override
  String get profileSaved => 'Iphrofayili ilondoloziwe';

  @override
  String get profileSave => 'Londoloza iphrofayili';

  @override
  String get profileEditTitle => 'Lungisa iphrofayili';

  @override
  String get profileName => 'Igama';

  @override
  String get profileNameRequired => 'Ngicela nifake igama lenu';

  @override
  String get profileEmergencyNumberHint =>
      'I-112 isebenza kunoma iyiphi ifoni ephathwayo';

  @override
  String get profileEmergencyNumberRequired =>
      'Ngicela nifake inombolo yezimo eziphuthumayo';

  @override
  String get profileBloodGroupHint => 'isib. O+';

  @override
  String get profileBloodPressureHint => 'isib. 120/80';

  @override
  String get profileBloodSugarHint => 'isib. Kujwayelekile';

  @override
  String get profileAllergiesHint => 'isib. I-Penicillin';

  @override
  String get profileConditionsHint =>
      'isib. Ushukela (uhlobo 2), i-BP ephezulu';

  @override
  String get profileTextSizeNormal => 'Okuvamile';

  @override
  String get profileTextSizeLarge => 'Okukhulu';

  @override
  String get profileTextSizeExtraLarge => 'Kakhulu';

  @override
  String get profileTextSizeExplain =>
      'Kwenza wonke umbhalo ku-app ube mkhulu. Kwengeza kubukhulu bombhalo befoni yenu.';

  @override
  String get backupProtectTitle => 'Niyafuna ukuvikela i-backup?';

  @override
  String get backupProtectMessage =>
      'I-backup inemininingwane yenu yezempilo. Iphasiwedi iyigcina iyimfihlo uma ifayela lingawela ezandleni ezingafanele. Yibhaleni phansi: ngaphandle kwayo i-backup ngeke ivuleke.';

  @override
  String get backupPasswordLabel => 'Iphasiwedi ye-backup';

  @override
  String get backupNoPassword => 'Ngaphandle kwephasiwedi';

  @override
  String get backupUsePassword => 'Sebenzisa iphasiwedi';

  @override
  String get backupShareSubject => 'I-backup ye-Elderly Care';

  @override
  String get backupReady =>
      'I-backup isilungile. Yigcineni endaweni ephephile, njenge-imeyili yenu noma i-cloud.';

  @override
  String get backupFailed => 'Asikwazanga ukwenza i-backup.';

  @override
  String get backupRestoreTitle => 'Nibuyise kusuka ku-backup?';

  @override
  String get backupRestoreMessage =>
      'Konke okuku-app manje kuzothathelwa indawo yilokho okusefayeleni le-backup.';

  @override
  String get backupChooseFile => 'Khetha ifayela';

  @override
  String get backupCouldNotReadFile => 'Asikwazanga ukufunda lelo fayela.';

  @override
  String get backupProtectedMessage =>
      'Le backup ivikelwe. Fakani iphasiwedi enayikhetha ngesikhathi niyenza.';

  @override
  String get backupWrongPasswordRetry =>
      'Leyo phasiwedi ayilungile. Ngicela nizame futhi.';

  @override
  String get backupPasswordTitle => 'Iphasiwedi ye-backup';

  @override
  String get backupPassword => 'Iphasiwedi';

  @override
  String get backupRestore => 'Buyisa';

  @override
  String get backupRestored => 'I-backup ibuyisiwe';

  @override
  String get backupBackUp => 'Yenza i-backup yedatha yami';

  @override
  String get backupBackUpSubtitle =>
      'Gcina konke efayeleni eningazithumelela lona nge-imeyili noma nikugcine ku-cloud.';

  @override
  String get backupRestoreFrom => 'Buyisa kusuka ku-backup';

  @override
  String get backupRestoreFromSubtitle =>
      'Sebenzisani lokhu efonini entsha ukuze nibuyise idatha yenu.';

  @override
  String get backupErrorNotBackup =>
      'Leli fayela akuyona i-backup ye-Elderly Care.';

  @override
  String get backupErrorTooLarge =>
      'Leli fayela likhulu kakhulu ukuba yi-backup.';

  @override
  String get backupErrorDamaged =>
      'Le backup yonakele, asikwazanga ukuyifunda.';

  @override
  String get backupErrorNoProfile => 'Le backup ayinayo iphrofayili.';

  @override
  String get backupErrorUnknownProtection =>
      'Le backup ivikelwe ngendlela le app engayazi.';

  @override
  String get securityTitle => 'Ubumfihlo nokuphepha';

  @override
  String get securityWrongPin => 'Leyo PIN ayilungile.';

  @override
  String get securityTooManyAttempts =>
      'Nizame kaningi kakhulu ngephutha. Ngicela nilinde kancane bese nizama futhi.';

  @override
  String get securityChoosePin => 'Khethani i-PIN';

  @override
  String get securityChoosePinMessage =>
      'Nizobhala le PIN ukuze nivule i-Elderly Care. Sebenzisani izinombolo ezi-4 kuya kwezi-8 abanye abangeke bazicabange.';

  @override
  String get securityNewPin => 'I-PIN entsha';

  @override
  String get securityPinUnavailable =>
      'Le divayisi ayikwazi ukugcina i-PIN ngokuphephile, ngakho ukukhiya i-app akutholakali lapha.';

  @override
  String get securityAppLockOn => 'Ukukhiya i-app kuvuliwe';

  @override
  String get securityAppLockOff => 'Ukukhiya i-app kuvaliwe';

  @override
  String get securityEnterCurrentPin => 'Fakani i-PIN yenu yamanje.';

  @override
  String get securityCurrentPin => 'I-PIN yamanje';

  @override
  String get securityChangePin => 'Shintsha i-PIN';

  @override
  String get securityTurnOffAppLock => 'Vala ukukhiya i-app';

  @override
  String get securityAppLock => 'Ukukhiya i-app';

  @override
  String get securityAppLockOnDetail =>
      'I-app icela i-PIN yenu uma ivuleka, nangemuva kokuthi ningayisebenzisanga imizuzu emi-2.';

  @override
  String get securityAppLockOffDetail =>
      'Noma ubani ophethe ifoni yenu angabona imininingwane yenu yezempilo. I-PIN iyigcina iyimfihlo.';

  @override
  String get securityLockNow => 'Khiya manje';

  @override
  String get securityTurnOff => 'Vala';

  @override
  String get securityLockWithPin => 'Khiya nge-PIN';

  @override
  String get securityBiometrics => 'Vula ngomunwe noma ngobuso';

  @override
  String get securityMedicalIdWhenLocked => 'Bonisa i-Medical ID uma ikhiyiwe';

  @override
  String get securityMedicalIdWhenLockedDetail =>
      'Kuvumela abasebenzi be-ambulensi babone ama-allergy nemithi yenu, futhi bashayele usizo ngaphandle kwe-PIN yenu.';

  @override
  String get securityHowProtected =>
      'Indlela imininingwane yenu evikelwa ngayo';

  @override
  String get securityEncrypted => 'Kubethelwe kule divayisi';

  @override
  String get securityNotEncrypted => 'Akubethelwe kule divayisi';

  @override
  String get securityEncryptedDetail =>
      'Imininingwane yenu yezempilo ixutshwa ngekhodi, ngesihluthulelo esigcinwe endaweni ephephile yale divayisi.';

  @override
  String get securityNotEncryptedDetail =>
      'Le browser ayinayo indawo yokugcina ephephile. Sebenzisani i-app yefoni, noma nivule iwebhusayithi nge-https.';

  @override
  String get securityLocalOnly => 'Kugcinwa kule divayisi kuphela';

  @override
  String get securityLocalOnlyDetail =>
      'Ayikho i-akhawunti futhi ayikho iseva. Akukho okuthunyelwa ku-inthanethi, futhi azikho izikhangiso noma ukulandelelwa.';

  @override
  String get securitySharedByChoice => 'Kuthunyelwa kuphela uma nikhetha';

  @override
  String get securitySharedByChoiceDetail =>
      'Amakholi nama-SMS ahamba ngefoni yenu. Imibiko yezempilo nama-backup aphuma ku-app kuphela uma niwathumela.';

  @override
  String get securityHospitalSearch => 'Ukusesha izibhedlela';

  @override
  String get securityHospitalSearchDetail =>
      'Ukuze kutholakale izibhedlela, indawo enikuyo ithunyelwa kwi-OpenStreetMap, okuyisevisi yamahhala. Akukho okunye ngani okuthunyelwayo.';

  @override
  String get securityVideoCalls => 'Amakholi evidiyo';

  @override
  String get securityVideoCallsDetail =>
      'Amakholi asebenzisa i-Jitsi Meet, isevisi yamahhala, egumbini eliyimfihlo elinegama elide elingahlelekile. Abantu enibathumelele isixhumanisi kuphela abangangena.';

  @override
  String get securityNoCloudCopy => 'Ayikho ikhophi ezenzakalelayo ku-cloud';

  @override
  String get securityNoCloudCopyDetail =>
      'Ifoni ayikopishi idatha yale app iyise ku-cloud. Sebenzisani \"Yenza i-backup yedatha yami\" ekhasini elithi Iphrofayili yami, kungcono nephasiwedi.';

  @override
  String get securityReadPrivacyPolicy => 'Funda yonke inqubomgomo yobumfihlo';

  @override
  String get securityEraseAnyTime =>
      'Ningasula konke noma nini ekhasini elithi Iphrofayili yami.';

  @override
  String get medicalIdTitle => 'I-Medical ID';

  @override
  String get medicalIdFooter =>
      'Gcinani imininingwane yenu isesikhathini ekhasini elithi Iphrofayili yami.';

  @override
  String get medicalIdNotRecorded => 'Akubhaliwe';

  @override
  String get medicalIdAge => 'Iminyaka';

  @override
  String get medicalIdBloodGroup => 'Uhlobo lwegazi';

  @override
  String get medicalIdAllergies => 'Ama-allergy';

  @override
  String get medicalIdConditions => 'Izifo';

  @override
  String get medicalIdMedicines => 'Imithi';

  @override
  String get medicalIdEmergencyContacts =>
      'Abantu bokuxhumana uma kuphuthumile';

  @override
  String medicalIdCallContact(String name) {
    return 'Shayela $name';
  }

  @override
  String medicalIdSpeakTitle(String name) {
    return 'I-Medical ID ka-$name.';
  }

  @override
  String medicalIdSpeakAge(String age) {
    return 'Iminyaka $age.';
  }

  @override
  String medicalIdSpeakBloodGroup(String group) {
    return 'Uhlobo lwegazi $group.';
  }

  @override
  String get medicalIdSpeakNoAllergies => 'Awekho ama-allergy abhaliwe.';

  @override
  String medicalIdSpeakAllergies(String allergies) {
    return 'Ama-allergy: $allergies.';
  }

  @override
  String medicalIdSpeakConditions(String conditions) {
    return 'Izifo: $conditions.';
  }

  @override
  String medicalIdSpeakMedicines(String medicines) {
    return 'Imithi: $medicines.';
  }

  @override
  String medicalIdSpeakContact(String name, String phone) {
    return 'Umuntu wokuxhumana uma kuphuthumile: $name, $phone.';
  }

  @override
  String medicalIdSpeakContactWithRelationship(
    String name,
    String relationship,
    String phone,
  ) {
    return 'Umuntu wokuxhumana uma kuphuthumile: $name, $relationship, $phone.';
  }

  @override
  String get secretOk => 'Kulungile';

  @override
  String secretMinDigits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sebenzisani okungenani izinombolo ezi-$count',
      one: 'Sebenzisani okungenani inombolo eyi-1',
    );
    return '$_temp0';
  }

  @override
  String secretMinCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sebenzisani okungenani izinhlamvu ezi-$count',
      one: 'Sebenzisani okungenani uhlamvu olu-1',
    );
    return '$_temp0';
  }

  @override
  String get secretTypeAgain => 'Bhalani futhi';

  @override
  String get secretNoMatch => 'Lezi ezimbili azifani';

  @override
  String get secretShowPin => 'Bonisa i-PIN';

  @override
  String get secretShowPassword => 'Bonisa iphasiwedi';

  @override
  String get homeMyProfile => 'Iphrofayili yami';

  @override
  String homeGreeting(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeWhatToDo => 'Ningathanda ukwenzani?';

  @override
  String get homeSosTitle => 'Ngidinga usizo';

  @override
  String get homeSosSubtitle => 'Shayelani usizo noma nixwayise umndeni';

  @override
  String get homeNoMedicines => 'Ayikho imithi okwamanje';

  @override
  String get homeNoMedicinesHint => 'Fakani umuthi ukuze nithole izikhumbuzo';

  @override
  String get homeAllMedicinesDone => 'Yonke imithi yanamuhla isithathiwe';

  @override
  String homeDosesTaken(int taken, int total) {
    return 'Kuthathwe $taken kwangu-$total';
  }

  @override
  String homeTimeFor(String medicine) {
    return 'Isikhathi sika-$medicine';
  }

  @override
  String homeNextMedicine(String medicine) {
    return 'Olandelayo: $medicine';
  }

  @override
  String get homeCheckDose => 'Hlola';

  @override
  String homeRefillSoon(String medicine) {
    return 'Landani i-$medicine futhi maduze';
  }

  @override
  String homeDosesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kusele imithamo engu-$count kuphela',
      one: 'Kusele umthamo o-1 kuphela',
    );
    return '$_temp0';
  }

  @override
  String homeAppointmentWhen(String day, String time) {
    return '$day ngo-$time';
  }

  @override
  String homeSpokenGreeting(String greeting, String name) {
    return '$greeting, $name.';
  }

  @override
  String homeSpokenToday(String date) {
    return 'Namuhla ngu-$date.';
  }

  @override
  String get homeSpokenNoMedicines => 'Anikafaki mithi.';

  @override
  String get homeSpokenAllTaken => 'Senithathe yonke imithi yenu yanamuhla.';

  @override
  String homeSpokenDoseDue(String medicine, String time) {
    return 'Yisikhathi sika-$medicine ngo-$time.';
  }

  @override
  String homeSpokenDoseDueWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'Yisikhathi sika-$medicine, $dosage, ngo-$time.';
  }

  @override
  String homeSpokenDoseNext(String medicine, String time) {
    return 'Umuthi wenu olandelayo ngu-$medicine ngo-$time.';
  }

  @override
  String homeSpokenDoseNextWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'Umuthi wenu olandelayo ngu-$medicine, $dosage, ngo-$time.';
  }

  @override
  String homeSpokenRefill(String medicine) {
    return 'Khumbulani ukulanda i-$medicine futhi maduze.';
  }

  @override
  String homeSpokenAppointment(String doctor, String day, String time) {
    return 'I-appointment yenu elandelayo ingeyokubona u-$doctor, $day ngo-$time.';
  }

  @override
  String get lockEnterPin => 'Fakani i-PIN yenu';

  @override
  String get lockPinTooShort => 'I-PIN yenu inezinombolo okungenani ezi-4.';

  @override
  String lockPinWrong(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'Kusele amathuba angu-$left',
      one: 'Kusele ithuba eli-1',
    );
    return 'Leyo PIN ayilungile. $_temp0 ngaphambi kokulinda kancane.';
  }

  @override
  String get lockTooManyTries => 'Nizame kaningi kakhulu ngephutha.';

  @override
  String lockWait(String time) {
    return 'Nizame kaningi kakhulu ngephutha. Zamani futhi ngemuva kuka-$time.';
  }

  @override
  String lockPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kufakwe izinombolo ezi-$count',
      one: 'Kufakwe inombolo eyi-1',
    );
    return '$_temp0';
  }

  @override
  String get lockUseBiometrics => 'Sebenzisa umunwe noma ubuso';

  @override
  String get lockEmergency => 'Kuphuthumile';

  @override
  String get lockForgotPin => 'Nikhohliwe i-PIN?';

  @override
  String lockCallNumber(String number) {
    return 'Shayela $number';
  }

  @override
  String get lockMedicalIdHidden =>
      'I-Medical ID ifihliwe ngesikhathi i-app ikhiyiwe.';

  @override
  String get lockForgotTitle => 'Niyikhohliwe i-PIN yenu?';

  @override
  String get lockForgotBody =>
      'Ukuze kuvikelwe ubumfihlo benu, i-PIN ayikwazi ukubuyiswa. Ningasula konke ku-app bese niqala kabusha. Uma nake nenza i-backup, ningayibuyisa emva kwalokho ekhasini elithi Iphrofayili yami.';

  @override
  String get lockEraseEverything => 'Sula konke, niqale kabusha';

  @override
  String get lockEraseConfirm => 'Yebo, sula konke';

  @override
  String get lockEraseWarning =>
      'Lokhu ngeke kubuyiswe. Cindezelani futhi ukuze niqinisekise.';

  @override
  String get lockKeyDelete => 'Susa';

  @override
  String get lockKeyUnlock => 'Vula';

  @override
  String get onboardingSkip => 'Yeqa';

  @override
  String get onboardingGetStarted => 'Asiqale';

  @override
  String get onboardingMedicinesTitle => 'Ningakhohlwa umuthi wenu';

  @override
  String get onboardingMedicinesText =>
      'Tholani isikhumbuzo uma isikhathi somthamo ngamunye sesifikile, futhi umndeni wenu wazi uma nikhohlwe owodwa.';

  @override
  String get onboardingAppointmentsTitle => 'Khumbulani ama-appointment';

  @override
  String get onboardingAppointmentsText =>
      'Gcinani ukubona kwenu udokotela endaweni eyodwa, futhi nithole isikhumbuzo ihora elilodwa ngaphambili.';

  @override
  String get onboardingHealthTitle => 'Landelelani impilo yenu';

  @override
  String get onboardingHealthText =>
      'Bhalani umfutho wegazi, ushukela egazini, isisindo nokulala, futhi nibone ukuthi kushintsha kanjani.';

  @override
  String get onboardingHospitalsTitle => 'Tholani usizo eduze';

  @override
  String get onboardingHospitalsText =>
      'Bonani izibhedlela namakliniki aseduze, nendlela yokufika nezinombolo zocingo.';

  @override
  String get onboardingFamilyTitle => 'Umndeni useduze njalo';

  @override
  String get onboardingFamilyText =>
      'Shayelani, thumelani i-SMS noma yenzani ikholi yevidiyo nomndeni wenu, noma nibathumelele indawo enikuyo uma kuphuthumile.';

  @override
  String get setupWelcome => 'Siyanamukela ku-Elderly Care';

  @override
  String get setupIntro =>
      'Imininingwane embalwa nje ukuze siqale. Konke kuhlala kule foni.';

  @override
  String get setupAboutYou => 'Ngani';

  @override
  String get setupYourName => 'Igama lenu';

  @override
  String get setupNameRequired => 'Ngicela nifake igama lenu';

  @override
  String get setupYourPhone => 'Inombolo yenu yefoni (uma nithanda)';

  @override
  String get setupEmergencyContact => 'Umuntu wokuxhumana uma kuphuthumile';

  @override
  String get setupEmergencyContactInfo =>
      'Umuntu esingamshayela noma simthumelele i-SMS uma nidinga usizo.';

  @override
  String get setupTheirName => 'Igama lakhe';

  @override
  String get setupRelationship => 'Uyini kini';

  @override
  String get setupRelationshipHint => 'isib. Indodakazi';

  @override
  String get setupTheirPhone => 'Inombolo yakhe yefoni';

  @override
  String get setupTheirPhoneRequired => 'Ngicela nifake inombolo yakhe yefoni';

  @override
  String get setupAddMoreLater =>
      'Ningengeza amalungu omndeni amaningi kamuva.';

  @override
  String get legalDocTerms => 'Imigomo Yokusebenzisa';

  @override
  String get legalDocMedical => 'Isexwayiso sezempilo';

  @override
  String get legalDocPrivacy => 'Inqubomgomo yobumfihlo';

  @override
  String get legalDocAccessibility => 'Isitatimende sokufinyeleleka';

  @override
  String get legalDocCredits => 'Ukubonga nezaziso zabanye';

  @override
  String get legalReadTerms => 'Funda imigomo yokusebenzisa';

  @override
  String get legalReadPrivacy => 'Funda inqubomgomo yobumfihlo';

  @override
  String get legalEnglishOnly =>
      'Leli phepha litholakala ngesiNgisi kuphela. Inguqulo yesiNgisi yiyo esemthethweni.';

  @override
  String get legalHubTitle => 'Umthetho nemininingwane';

  @override
  String get legalOpenSourceLicences => 'Amalayisense e-open-source';

  @override
  String legalAppVersion(String version) {
    return 'Elderly Care, inguqulo $version';
  }

  @override
  String legalVersion(String version) {
    return 'Inguqulo $version';
  }

  @override
  String legalAcceptedOn(int version, String date) {
    return 'Navuma inguqulo $version yala maphepha ngo-$date.';
  }

  @override
  String get legalAgree =>
      'Ngiyavuma iMigomo Yokusebenzisa, futhi ngifundile Isexwayiso sezempilo kanye neNqubomgomo yobumfihlo';

  @override
  String get legalTickBox => 'Ngicela nimake ibhokisi ukuze niqhubeke.';

  @override
  String get legalNotMedicalService =>
      'I-Elderly Care akuyona isevisi yezempilo. Uma kuphuthumile, shayelani u-112.';

  @override
  String get legalReviewTitle => 'Ngicela nifunde imigomo yethu';

  @override
  String get legalUpdatedTitle => 'Imigomo yethu ibuyekeziwe';

  @override
  String legalUpdateBody(int version, String date) {
    return 'Ngaphambi kokuqhubeka, ngicela nifunde futhi nivume iMigomo Yokusebenzisa, Isexwayiso sezempilo kanye neNqubomgomo yobumfihlo (inguqulo $version, esebenza kusukela ngo-$date). Imininingwane yenu ihlala kule divayisi.';
  }

  @override
  String get medicinesTitle => 'Imithi';

  @override
  String get medicinesAdd => 'Faka umuthi';

  @override
  String get medicinesEmptyTitle => 'Ayikho imithi okwamanje';

  @override
  String get medicinesEmptyMessage =>
      'Fakani imithi yenu, sizonikhumbuza uma isikhathi somthamo ngamunye sesifikile.';

  @override
  String get medicinesTodaySchedule => 'Uhlelo lwanamuhla';

  @override
  String medicinesTakenToday(int taken, int total) {
    return 'Kuthathwe $taken kwangu-$total';
  }

  @override
  String get medicinesMine => 'Imithi yami';

  @override
  String medicinesTimesADay(int count) {
    return '$count× ngosuku';
  }

  @override
  String get medicinesDisclaimer =>
      'Njalo thathani imithi njengoba udokotela noma usokhemisi enitshelile. Izikhumbuzo kwesinye isikhathi zingephuza, ngakho ningathembeli kuzo zodwa.';

  @override
  String medicinesSupplyLow(int count) {
    return 'Kusele imithamo engu-$count kuphela – sekuyisikhathi sokulanda omunye';
  }

  @override
  String medicinesSupplyLeft(int count, int days) {
    return 'Kusele imithamo engu-$count (cishe izinsuku ezingu-$days)';
  }

  @override
  String medicinesLastWeek(int taken, int due) {
    return 'Izinsuku ezi-7 ezedlule: kuthathwe imithamo engu-$taken kwengu-$due';
  }

  @override
  String get medicinesLateTitle => 'Izikhumbuzo zingafika sekwephuzile';

  @override
  String get medicinesLateMessage =>
      'Ifoni yenu yonga ibhethri ngokubambezela izikhumbuzo. Vumelani i-Elderly Care inikhumbuze ngesikhathi esiqondile.';

  @override
  String get medicinesLateAllow => 'Vumela izikhumbuzo ngesikhathi';

  @override
  String get doseStatusTaken => 'Ithathiwe';

  @override
  String get doseStatusNotTaken => 'Ayithathwanga';

  @override
  String get doseStatusOverdue => 'Sekwephuzile';

  @override
  String get doseStatusDue => 'Yisikhathi manje';

  @override
  String get doseStatusLater => 'Kamuva';

  @override
  String doseRowSubtitle(String time, String status) {
    return '$time · $status';
  }

  @override
  String get doseCheck => 'Hlola';

  @override
  String get doseCheckTitle => 'Ukuhlola umuthi';

  @override
  String doseCheckQuestion(String medicine) {
    return 'Niyithathile i-$medicine?';
  }

  @override
  String doseCheckWhen(String day, String time) {
    return '$day ngo-$time';
  }

  @override
  String get doseCheckYes => 'Yebo, ngiwuthathile';

  @override
  String get doseCheckNo => 'Cha, angikawuthathi';

  @override
  String get doseTellFamilyTitle => 'Sazise umndeni wenu?';

  @override
  String doseTellFamilyMessage(String names, String medicine) {
    return 'Singathumela i-SMS ku-$names sithi anithathanga i-$medicine.';
  }

  @override
  String get doseTellFamilySend => 'Thumela i-SMS';

  @override
  String doseMissedSms(String name, String medicine, String time) {
    return '$name akayithathanga i-$medicine ($time) namuhla. Ngicela umbheke.';
  }

  @override
  String doseMissedSmsNoName(String medicine, String time) {
    return 'Angiyithathanga i-$medicine ($time) namuhla. Ngicela ungibheke.';
  }

  @override
  String doseRecordedTaken(String medicine) {
    return 'Kuhle kakhulu! I-$medicine ibhaliwe.';
  }

  @override
  String doseRecordedNotTaken(String medicine) {
    return 'Kubhaliwe. I-$medicine ayithathwanga.';
  }

  @override
  String doseTakenFromNotification(String medicine) {
    return 'I-$medicine ibhalwe njengethathiwe. Kuhle kakhulu!';
  }

  @override
  String doseSnoozed(String medicine) {
    return 'Sizonikhumbuza nge-$medicine futhi emizuzwini eyi-10.';
  }

  @override
  String get medicineEditTitle => 'Lungisa umuthi';

  @override
  String get medicineEditSaveChanges => 'Londoloza izinguquko';

  @override
  String get medicineEditSaveNew => 'Londoloza isikhumbuzo';

  @override
  String get medicineEditDeleteTooltip => 'Susa umuthi';

  @override
  String medicineEditDeleteTitle(String medicine) {
    return 'Kususwe i-$medicine?';
  }

  @override
  String get medicineEditDeleteMessage =>
      'Ngeke nisazithola izikhumbuzo zalo muthi.';

  @override
  String medicineEditReminderSet(String medicine) {
    return 'Isikhumbuzo se-$medicine sisethiwe';
  }

  @override
  String medicineEditSaved(String medicine) {
    return 'I-$medicine ilondoloziwe';
  }

  @override
  String get medicineEditNameLabel => 'Igama lomuthi';

  @override
  String get medicineEditNameHint => 'isib. I-Metformin';

  @override
  String get medicineEditNameRequired => 'Ngicela nifake igama lomuthi';

  @override
  String get medicineEditDosageLabel => 'Kangakanani (uma nithanda)';

  @override
  String get medicineEditDosageHint => 'isib. iphilisi eli-1, 500 mg';

  @override
  String get medicineEditSupplyLabel =>
      'Imithamo esele ephaketheni (uma nithanda)';

  @override
  String get medicineEditSupplyHint => 'isib. 30';

  @override
  String get medicineEditSupplyHelper =>
      'Sizonixwayisa uma sekuyisikhathi sokulanda omunye umuthi.';

  @override
  String get medicineEditSupplyInvalid => 'Ngicela nifake inombolo ephelele';

  @override
  String get medicineEditType => 'Uhlobo';

  @override
  String get medicineEditHowOften => 'Kangaki ngosuku?';

  @override
  String get medicineEditOnce => 'Kanye';

  @override
  String get medicineEditTwice => 'Kabili';

  @override
  String get medicineEditThreeTimes => 'Kathathu';

  @override
  String get medicineEditAtWhatTimes => 'Ngaziphi izikhathi?';

  @override
  String medicineEditDoseNumber(int number) {
    return 'Umthamo $number';
  }

  @override
  String medicineEditDoseTime(int number) {
    return 'Isikhathi somthamo $number';
  }

  @override
  String get medicineEditChange => 'Shintsha';

  @override
  String get appointmentsTitle => 'Ama-appointment';

  @override
  String appointmentsUpcomingTab(int count) {
    return 'Ezizayo ($count)';
  }

  @override
  String appointmentsPastTab(int count) {
    return 'Ezedlule ($count)';
  }

  @override
  String get appointmentsAdd => 'Faka i-appointment';

  @override
  String get appointmentsNoPast => 'Awekho ama-appointment edlule';

  @override
  String get appointmentsNoUpcoming => 'Awekho ama-appointment azayo';

  @override
  String get appointmentsNoPastMessage =>
      'Ama-appointment azofika lapha uma esephelile.';

  @override
  String get appointmentsNoUpcomingMessage =>
      'Fakani ukubona kwenu udokotela okulandelayo, sizonikhumbuza ihora elilodwa ngaphambili.';

  @override
  String get appointmentsAttended => 'Ngiyile';

  @override
  String get appointmentEditTitle => 'I-appointment';

  @override
  String get appointmentEditNewTitle => 'I-appointment entsha';

  @override
  String get appointmentEditSaveChanges => 'Londoloza izinguquko';

  @override
  String get appointmentEditSaveNew => 'Londoloza i-appointment';

  @override
  String get appointmentEditDeleteTooltip => 'Susa i-appointment';

  @override
  String get appointmentEditDeleteTitle => 'Kususwe i-appointment?';

  @override
  String appointmentEditDeleteMessage(String doctor) {
    return 'I-appointment yenu no-$doctor izosuswa.';
  }

  @override
  String appointmentEditSaved(String doctor) {
    return 'I-appointment no-$doctor ilondoloziwe';
  }

  @override
  String get appointmentEditDoctorLabel => 'Igama likadokotela';

  @override
  String get appointmentEditDoctorHint => 'isib. uDkt. Naidoo';

  @override
  String get appointmentEditDoctorRequired =>
      'Ngicela nifake igama likadokotela';

  @override
  String get appointmentEditSpecialtyLabel =>
      'Uhlobo lukadokotela (uma nithanda)';

  @override
  String get appointmentEditSpecialtyHint => 'isib. Udokotela wenhliziyo';

  @override
  String get appointmentEditPlaceLabel => 'Kuphi (uma nithanda)';

  @override
  String get appointmentEditPlaceHint => 'Isibhedlela, ikliniki noma ekhaya';

  @override
  String get appointmentEditWhen => 'Nini';

  @override
  String get appointmentEditChange => 'Shintsha';

  @override
  String get appointmentEditNotesLabel => 'Amanothi (uma nithanda)';

  @override
  String get appointmentEditNotesHint => 'Imibuzo yokubuza, izinto zokuphatha…';

  @override
  String get appointmentEditAttended => 'Ngaya kule appointment';

  @override
  String get notesTitle => 'Amanothi';

  @override
  String get notesNew => 'Inothi entsha';

  @override
  String get notesEmptyTitle => 'Awekho amanothi okwamanje';

  @override
  String get notesEmptyMessage =>
      'Bhalani izinto zokukhumbula, imibuzo kadokotela, noma yini enye.';

  @override
  String notesUpdated(String day) {
    return 'Kubuyekezwe $day';
  }

  @override
  String notesImportantUpdated(String day) {
    return 'Kubalulekile · Kubuyekezwe $day';
  }

  @override
  String get noteEditTitle => 'Lungisa inothi';

  @override
  String get noteEditSave => 'Londoloza inothi';

  @override
  String get noteEditSaved => 'Inothi ilondoloziwe';

  @override
  String get noteEditDeleteTooltip => 'Susa inothi';

  @override
  String get noteEditDeleteTitle => 'Isuswe le nothi?';

  @override
  String noteEditDeleteMessage(String title) {
    return '\"$title\" izosuswa.';
  }

  @override
  String get noteEditTitleLabel => 'Isihloko';

  @override
  String get noteEditTitleRequired => 'Ngicela nifake isihloko';

  @override
  String get noteEditBodyLabel => 'Inothi';

  @override
  String get noteEditHowImportant => 'Ibaluleke kangakanani?';

  @override
  String get noteEditImportant => 'Kubalulekile';

  @override
  String get noteEditNormal => 'Okuvamile';

  @override
  String get healthIntro =>
      'Gcinani izilinganiso zenu, bese nicindezela okuthi Thumela ukuze nithumele udokotela wenu umbiko.';

  @override
  String get healthDisclaimer =>
      'Amacebiso alapha ngolwazi olujwayelekile lwabantu abadala, akuyona iseluleko sikadokotela. Buzani udokotela wenu ukuthi yiziphi izilinganiso ezinilungele. Uma nizizwa ningaphilile kakhulu, shayelani u-112.';

  @override
  String get healthNoReadings => 'Azikho izilinganiso okwamanje';

  @override
  String healthShareSubject(String name) {
    return 'Umbiko wezempilo ka-$name';
  }

  @override
  String get healthShareSubjectNoName => 'Umbiko wami wezempilo';

  @override
  String get healthShareTitle =>
      'Thumelani udokotela wenu umbiko wezinsuku ezingu-30 ezedlule';

  @override
  String get healthShareAsPdf => 'Njengephepha le-PDF';

  @override
  String get healthShareAsPdfSubtitle =>
      'Amathebula acocekile, kulula ukuphrinta';

  @override
  String get healthShareAsText => 'Njengomyalezo';

  @override
  String get healthShareAsTextSubtitle =>
      'Umbhalo nje we-imeyili noma i-WhatsApp';

  @override
  String get trackingAddReading => 'Faka isilinganiso';

  @override
  String get trackingFirstReading =>
      'Fakani isilinganiso senu sokuqala ukuze niqale ukulandelela.';

  @override
  String get trackingOneMore =>
      'Fakani esinye isilinganiso ukuze nibone ishadi.';

  @override
  String get trackingReadings => 'Izilinganiso';

  @override
  String get trackingDeleteReading => 'Susa isilinganiso';

  @override
  String get trackingDeleteReadingTitle => 'Sisuswe isilinganiso?';

  @override
  String trackingDeleteReadingMessage(String reading, String day) {
    return '$reading, $day';
  }

  @override
  String trackingChartLabel(int count, String type, String latest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$type: ishadi lezilinganiso ezingu-$count zokugcina. Esakamuva: $latest.',
    );
    return '$_temp0';
  }

  @override
  String trackingFieldRequired(String field) {
    return 'Ngicela nifake: $field';
  }

  @override
  String get trackingEnterNumber => 'Ngicela nifake inombolo';

  @override
  String trackingOutOfRange(String min, String max) {
    return 'Kufanele kube phakathi kuka-$min no-$max';
  }

  @override
  String trackingReadingSaved(String type) {
    return '$type: isilinganiso silondoloziwe';
  }

  @override
  String get trackingSaveReading => 'Londoloza isilinganiso';

  @override
  String trackingNewReadingTitle(String type) {
    return 'Isilinganiso esisha: $type';
  }

  @override
  String get trackingChangeTime => 'Shintsha';

  @override
  String get trackingNotes => 'Amanothi (uma nithanda)';

  @override
  String get trackingNotesHint => 'isib. ngemuva kokudla kwasekuseni';

  @override
  String get documentTakePhoto => 'Thatha isithombe';

  @override
  String get documentChooseFromGallery => 'Khetha kugalari';

  @override
  String get documentPickFailed => 'Asikwazanga ukuvula ikhamera noma igalari.';

  @override
  String get documentAdd => 'Faka iphepha';

  @override
  String get documentNoneTitle => 'Awekho amaphepha okwamanje';

  @override
  String get documentNoneMessage =>
      'Thathani izithombe zama-script, imiphumela yokuhlolwa namakhadi e-medical aid ukuze kube seduze njalo.';

  @override
  String get documentSearch => 'Sesha amaphepha';

  @override
  String documentNoMatch(String query) {
    return 'Akukho okufana no-\"$query\".';
  }

  @override
  String get documentSaved => 'Iphepha lilondoloziwe';

  @override
  String get documentSave => 'Londoloza iphepha';

  @override
  String get documentName => 'Igama';

  @override
  String get documentNameHint => 'isib. Ukuhlolwa kwegazi kaMashi';

  @override
  String get documentNameRequired =>
      'Ngicela nifake igama ukuze nilithole kamuva';

  @override
  String get documentDelete => 'Susa iphepha';

  @override
  String documentDeleteTitle(String name) {
    return 'Kususwe $name?';
  }

  @override
  String get documentDeleteMessage => 'Lesi sithombe sizosuswa ku-app.';

  @override
  String get hospitalRefresh => 'Vuselela';

  @override
  String hospitalEmergencyCall(String number) {
    return 'Kuphuthumile? Shayela $number';
  }

  @override
  String get hospitalSearching => 'Sifuna izibhedlela eziseduze nani…';

  @override
  String get hospitalSearchFailed => 'Asikwazanga ukusesha';

  @override
  String get hospitalCheckInternet =>
      'Ngicela nihlole i-inthanethi yenu bese nizama futhi.';

  @override
  String get hospitalTryAgain => 'Zama futhi';

  @override
  String get hospitalNoneFound =>
      'Akutholakalanga lutho ngaphakathi kuka-10 km';

  @override
  String get hospitalNoneFoundMessage =>
      'Uma kuphuthumile, shayelani inombolo engenhla.';

  @override
  String hospitalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Izindawo ezingu-$count ngaphakathi kuka-10 km',
      one: 'Indawo eyi-1 ngaphakathi kuka-10 km',
    );
    return '$_temp0';
  }

  @override
  String get hospitalListNote =>
      'Lolu hlu luvela ku-OpenStreetMap futhi lungahle lungaphelele noma lube ludala. Akuzona zonke izindawo ezinewodi yezimo eziphuthumayo: shayelani kuqala uma nikwazi.';

  @override
  String get hospitalAttribution => 'Idatha © abanikeli be-OpenStreetMap';

  @override
  String hospitalDistanceMeters(int meters) {
    return '$meters m kusuka lapha';
  }

  @override
  String hospitalDistanceKm(String km) {
    return '$km km kusuka lapha';
  }

  @override
  String get hospitalDirections => 'Indlela';

  @override
  String get sosTitle => 'Singanisiza kanjani?';

  @override
  String get sosCallEmergency => 'Shayela usizo oluphuthumayo';

  @override
  String sosDial(String number) {
    return 'Shayela $number';
  }

  @override
  String get sosAlertFamily => 'Xwayisa umndeni wami';

  @override
  String get sosAlertFamilySubtitle =>
      'Thumela wonke umuntu i-SMS yendawo engikuyo';

  @override
  String get sosShowMedicalId => 'Bonisa i-Medical ID yami';

  @override
  String get sosShowMedicalIdSubtitle =>
      'Ama-allergy, imithi nezinombolo zabasizi';

  @override
  String sosCallPerson(String name) {
    return 'Shayela $name';
  }

  @override
  String get sosAddFamilyFirst =>
      'Fakani ilungu lomndeni ukuze sazi ukuthi sixwayise bani.';

  @override
  String get sosAddFamily => 'Faka umndeni';

  @override
  String get sosFindingLocation => 'Sithola indawo enikuyo…';

  @override
  String sosSendingWithoutLocation(String problem) {
    return '$problem Sithumela ngaphandle kwendawo.';
  }

  @override
  String get sosLocationUnavailable =>
      'Indawo ayitholakali. Sithumela ngaphandle kwayo.';

  @override
  String sosAlertSms(String name) {
    return '$name udinga usizo, ucele i-Elderly Care ikwazise.';
  }

  @override
  String sosAlertSmsWithLocation(String name, String link) {
    return '$name udinga usizo, ucele i-Elderly Care ikwazise. Ukhona lapha manje: $link';
  }

  @override
  String get sosAlertSmsNoName =>
      'Ngidinga usizo, ngicele i-Elderly Care ikwazise.';

  @override
  String sosAlertSmsNoNameWithLocation(String link) {
    return 'Ngidinga usizo, ngicele i-Elderly Care ikwazise. Ngikhona lapha manje: $link';
  }

  @override
  String get familyAddPerson => 'Faka umuntu';

  @override
  String get familyNoneTitle => 'Akekho owomndeni ofakiwe okwamanje';

  @override
  String get familyNoneMessage =>
      'Fakani abantu abanibhekayo ukuze nikwazi ukubathola ngokushesha.';

  @override
  String get familyAlertEveryone => 'Xwayisa wonke umuntu ngendawo engikuyo';

  @override
  String familyEditPerson(String name) {
    return 'Lungisa $name';
  }

  @override
  String relativeSaved(String name) {
    return '$name ulondoloziwe';
  }

  @override
  String relativeRemoveTitle(String name) {
    return 'Kukhishwe $name?';
  }

  @override
  String get relativeRemoveMessage => 'Ngeke esaxwayiswa uma kuphuthumile.';

  @override
  String get relativeEditTitle => 'Lungisa ilungu lomndeni';

  @override
  String get relativeAddTitle => 'Faka ilungu lomndeni';

  @override
  String get relativeRemove => 'Khipha ilungu lomndeni';

  @override
  String get relativeName => 'Igama';

  @override
  String get relativeNameRequired => 'Ngicela nifake igama';

  @override
  String get relativeRelationship => 'Uyini kini (uma nithanda)';

  @override
  String get relativeRelationshipHint => 'isib. Indodana, Umakhelwane, Unesi';

  @override
  String get relativePhone => 'Inombolo yefoni';

  @override
  String get relativePhoneRequired => 'Ngicela nifake inombolo yefoni';

  @override
  String get relativePhoneTooShort => 'Leyo nombolo ibukeka imfushane kakhulu';

  @override
  String get relativeEmail => 'I-imeyili (uma nithanda)';

  @override
  String get videoHeading => 'Bonani nikhulume nomndeni wenu';

  @override
  String get videoExplanation =>
      'Ikholi ivuleka ku-browser yenu noma ku-app ye-Jitsi Meet. Yamahhala futhi ayidingi i-akhawunti.';

  @override
  String get videoTextFamily => 'Thumela umndeni wami isixhumanisi nge-SMS';

  @override
  String get videoAddFamilyFirst => 'Qala ngokufaka umndeni';

  @override
  String get videoVoiceOnly => 'Izwi kuphela (ngaphandle kwekhamera)';

  @override
  String get videoStartMuted => 'Qala imakrofoni ivaliwe';

  @override
  String get videoStart => 'Qala ikholi yevidiyo';

  @override
  String get videoOpenFailed => 'Asikwazanga ukuvula ikholi yevidiyo.';

  @override
  String videoInviteSms(String name, String link) {
    return '$name ufuna ikholi yevidiyo nawe. Ngena lapha: $link';
  }

  @override
  String get locationOff =>
      'Indawo ivaliwe. Ngicela niyivule kuzilungiselelo zefoni yenu.';

  @override
  String get locationNoPermission =>
      'I-Elderly Care idinga imvume yokubona indawo enikuyo.';

  @override
  String get locationNotFound => 'Asikwazanga ukuthola indawo enikuyo.';

  @override
  String get shareBackupPickerTitle => 'Khethani i-backup yenu ye-Elderly Care';

  @override
  String setupStepOf(int step, int total) {
    return 'Isinyathelo $step kwezingu-$total';
  }

  @override
  String get setupSkip => 'Yeqa';

  @override
  String get setupFinish => 'Qeda';

  @override
  String get setupNickname => 'Ningathanda sinibize ngokuthini?';

  @override
  String get setupNicknameHint => 'isib. Gogo, Mkhulu noma Mama Dlamini';

  @override
  String get setupNicknameHelp =>
      'Uma ningabhali lutho, sizosebenzisa igama lenu.';

  @override
  String get setupReadingTitle => 'Ingabe lokhu kulula ukukufunda?';

  @override
  String get setupReadingBody =>
      'Khethani ubukhulu bombhalo obunilungele. Ningabushintsha noma nini ekhasini elithi Iphrofayili yami.';

  @override
  String get setupReadingSample => 'Yisikhathi sephilisi lenu lomfutho wegazi.';

  @override
  String get setupHelpTitle => 'Ningathanda usizo ngani?';

  @override
  String get setupHelpBody =>
      'Khethani okuningi ngendlela enithanda ngayo. Kuzovela kuqala ekhasini lenu lasekhaya, futhi konke okunye kuzohlala khona.';

  @override
  String get setupDayTitle => 'Sitsheleni ngosuku lwenu';

  @override
  String get setupDayBody =>
      'Sizoniphakamisela izikhathi zemithi ezihambisana nosuku lwenu.';

  @override
  String get setupWakeUp => 'Ngivame ukuvuka ngo';

  @override
  String get setupBedtime => 'Ngivame ukulala ngo';

  @override
  String setupDaySuggestion(String times) {
    return 'Izikhathi zemithi esiziphakamisayo: $times';
  }

  @override
  String get setupHealthTitle => 'Imininingwane embalwa yezempilo';

  @override
  String get setupHealthBody =>
      'Lokhu kufakwa ku-Medical ID yenu, ukuze abasebenzi be-ambulensi nodokotela banisize ngokushesha. Ningakweqa lokhu bese nikufaka kamuva.';

  @override
  String get setupBloodGroupUnknown => 'Angazi';

  @override
  String setupFinishTitle(String name) {
    return 'Konke sekulungile, $name!';
  }

  @override
  String get setupFinishBody =>
      'Nakhu esinilungiselele khona. Ngicela nifunde futhi nivume imigomo yethu ukuze niqede.';

  @override
  String setupSummaryName(String name) {
    return 'Sizonibiza ngo-$name.';
  }

  @override
  String setupSummaryFirst(String features) {
    return 'Ekhasini lenu lasekhaya kuqala: $features.';
  }

  @override
  String setupSummaryContact(String name) {
    return '$name ungumuntu wenu wokuxhumana uma kuphuthumile.';
  }

  @override
  String get setupSummaryNoContact =>
      'Akukabi bikho umuntu wokuxhumana uma kuphuthumile. Ningamfaka ekhasini elithi Umndeni wami.';

  @override
  String get startTitle => 'Asiqale';

  @override
  String get startBody =>
      'Izinyathelo ezimbalwa zokuqala ukuze i-app inisebenzele kahle.';

  @override
  String get startAllDone => 'Konke sekulungile';

  @override
  String get startAllDoneBody => 'Nenze kahle! Ningakuvala lokhu manje.';

  @override
  String get startAddMedicine => 'Fakani umuthi wenu wokuqala';

  @override
  String get startAddAppointment =>
      'Fakani ukubona kwenu udokotela okulandelayo';

  @override
  String get startAddFamily => 'Fakani ilungu lomndeni wenu';

  @override
  String get startAddPin => 'Vikelani i-app nge-PIN';

  @override
  String get profileMadeForYou => 'Kwenzelwe nina';

  @override
  String get profileCallMe => 'Sinibiza ngokuthi';

  @override
  String get profileMyDay => 'Usuku lwami';

  @override
  String profileMyDayValue(String wake, String bed) {
    return 'Ukuvuka ngo-$wake, ukulala ngo-$bed';
  }

  @override
  String get profileHomeFirst => 'Okuqala ekhasini lami lasekhaya';

  @override
  String get profileHomeFirstNone => 'Konke, ngohlelo olujwayelekile';
}
