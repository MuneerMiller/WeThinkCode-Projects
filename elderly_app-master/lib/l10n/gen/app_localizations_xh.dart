// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Xhosa (`xh`).
class AppLocalizationsXh extends AppLocalizations {
  AppLocalizationsXh([String locale = 'xh']) : super(locale);

  @override
  String get appTitle => 'Elderly Care';

  @override
  String get commonCancel => 'Rhoxisa';

  @override
  String get commonSave => 'Gcina';

  @override
  String get commonDelete => 'Cima';

  @override
  String get commonEdit => 'Hlela';

  @override
  String get commonClose => 'Vala';

  @override
  String get commonContinue => 'Qhubeka';

  @override
  String get commonBack => 'Buyela';

  @override
  String get commonNext => 'Okulandelayo';

  @override
  String get commonDone => 'Kugqityiwe';

  @override
  String get commonRemove => 'Susa';

  @override
  String get commonCall => 'Fowuna';

  @override
  String get commonText => 'Thumela i-SMS';

  @override
  String get commonShare => 'Thumela';

  @override
  String get commonToday => 'Namhlanje';

  @override
  String get commonTomorrow => 'Ngomso';

  @override
  String get commonYesterday => 'Izolo';

  @override
  String get commonReadAloud => 'Funda ngokuvakalayo';

  @override
  String get commonStopReading => 'Yeka ukufunda';

  @override
  String get commonReadMedicalDisclaimer => 'Funda isilumkiso sezempilo';

  @override
  String get greetingMorning => 'Ntsasa entle';

  @override
  String get greetingAfternoon => 'Emva kwemini emnandi';

  @override
  String get greetingEvening => 'Ngokuhlwa okumnandi';

  @override
  String get languageTitle => 'Ulwimi';

  @override
  String get languageSystem => 'Njengefowuni yam';

  @override
  String get languageReviewNote =>
      'Le nguqulelo intsha. Ukuba kukho into efundeka ngendlela engaqhelekanga, nceda nisazise ukuze siyiphucule.';

  @override
  String get languageEnglishOnlyNote =>
      'Amaxwebhu asemthethweni nezishwankathelo zikagqirha wenu zibhalwe ngesiNgesi.';

  @override
  String get featureMedicines => 'Amayeza';

  @override
  String get featureMedicinesSubtitle => 'Izikhumbuzo needosi';

  @override
  String get featureAppointments => 'Amadinga';

  @override
  String get featureAppointmentsSubtitle => 'Ukubona ugqirha';

  @override
  String get featureHealth => 'Impilo yam';

  @override
  String get featureHealthSubtitle => 'BP, iswekile, ubunzima, ubuthongo';

  @override
  String get featureFamily => 'Usapho lwam';

  @override
  String get featureFamilySubtitle => 'Fowuna, SMS, yazisa';

  @override
  String get featureHospitals => 'Izibhedlele ezikufutshane';

  @override
  String get featureHospitalsSubtitle => 'Fumana indlela';

  @override
  String get featureVideoCall => 'Umnxeba wevidiyo';

  @override
  String get featureVideoCallSubtitle => 'Bonani usapho lwenu';

  @override
  String get featureDocuments => 'Amaxwebhu';

  @override
  String get featureDocumentsSubtitle => 'Iipreskripshini neengxelo';

  @override
  String get featureNotes => 'Amanqaku';

  @override
  String get featureNotesSubtitle => 'Izinto zokukhumbula';

  @override
  String get medicineTypeTablet => 'Ipilisi';

  @override
  String get medicineTypeCapsule => 'Ikhapsyuli';

  @override
  String get medicineTypeSyrup => 'Isiraphu';

  @override
  String get medicineTypeDrops => 'Amathontsi';

  @override
  String get medicineTypeInjection => 'Isitofu';

  @override
  String get medicineTypeInhaler => 'Impompo';

  @override
  String get medicineTypeOther => 'Enye';

  @override
  String get trackerBloodPressure => 'Uxinzelelo lwegazi';

  @override
  String get trackerBloodPressureTip =>
      'Uxinzelelo lwegazi olusempilweni lungaphantsi kwe-120/80 mmHg.';

  @override
  String get trackerBloodSugar => 'Iswekile egazini';

  @override
  String get trackerBloodSugarTip =>
      'Xa ningekatyi nto, iswekile ye-70–100 mg/dL iqhelekile.';

  @override
  String get trackerWeight => 'Ubunzima';

  @override
  String get trackerWeightTip =>
      'Linganisani ubunzima benu ngexesha elifanayo yonke imihla.';

  @override
  String get trackerSleep => 'Ubuthongo';

  @override
  String get trackerSleepTip =>
      'Uninzi lwabantu abadala lufuna iiyure ezi-7–8 zokulala.';

  @override
  String get trackerFieldSystolic => 'Systolic (inani eliphezulu)';

  @override
  String get trackerFieldDiastolic => 'Diastolic (inani elisezantsi)';

  @override
  String get trackerFieldPulse => 'Ukubetha kwentliziyo';

  @override
  String get trackerFieldGlucose => 'Iswekile egazini';

  @override
  String get trackerFieldWeight => 'Ubunzima';

  @override
  String get trackerFieldHours => 'Iiyure zokulala';

  @override
  String get trackerFieldMinutes => 'Imizuzu eyongezelelweyo';

  @override
  String trackerSleepValue(num hours, num minutes) {
    return '$hours h $minutes min';
  }

  @override
  String notifyDoseTitle(String medicine) {
    return 'Lixesha le-$medicine';
  }

  @override
  String get notifyDoseBody => 'Cofa \"Ndiyithathile\" xa sele niyithathile.';

  @override
  String notifyDoseBodyWithDosage(String dosage) {
    return 'Thathani $dosage, emva koko nicofe \"Ndiyithathile\".';
  }

  @override
  String notifyFollowUpTitle(String medicine) {
    return 'Ngaba niyithathile i-$medicine yenu?';
  }

  @override
  String notifyFollowUpBody(String time) {
    return 'Ibifanele ithathwe ngo-$time. Nceda nisazise ukuze irekhodi yenu ichaneke.';
  }

  @override
  String get notifySnoozeBody => 'Siyanikhumbuza kwakhona, njengoko nicelile.';

  @override
  String get notifyAppointmentTitle => 'Idinga emva kweyure enye';

  @override
  String get notifyActionTaken => 'Ndiyithathile';

  @override
  String get notifyActionSnooze => 'Emva kwe-10 min';

  @override
  String get notifyActionNotYet => 'Andikayithathi';

  @override
  String get notifyMedicineChannel => 'Izikhumbuzo zamayeza';

  @override
  String get notifyMedicineChannelDescription =>
      'Inikhumbuza xa lixesha lokuthatha iyeza';

  @override
  String get notifyAppointmentChannel => 'Izikhumbuzo zamadinga';

  @override
  String get notifyAppointmentChannelDescription =>
      'Inikhumbuza iyure enye ngaphambi kwedinga likagqirha';

  @override
  String get languageChoose => 'Khetha ulwimi';

  @override
  String get profileTitle => 'Iprofayili yam';

  @override
  String get profileNotSet => 'Akukafakwa';

  @override
  String get profileShowMedicalId => 'Bonisa isazisi sam sezempilo';

  @override
  String get profileContact => 'Unxibelelwano';

  @override
  String get profilePhone => 'Ifowuni';

  @override
  String get profileEmail => 'I-imeyile';

  @override
  String get profileEmergencyNumber => 'Inombolo yongxamiseko';

  @override
  String get profileMedicalDetails => 'Iinkcukacha zezempilo';

  @override
  String get profileAge => 'Ubudala';

  @override
  String get profileGender => 'Isini';

  @override
  String get profileBloodGroup => 'Uhlobo lwegazi';

  @override
  String get profileHeight => 'Ubude';

  @override
  String get profileWeight => 'Ubunzima';

  @override
  String get profileUsualBloodPressure => 'Uxinzelelo lwegazi oluqhelekileyo';

  @override
  String get profileUsualBloodSugar => 'Iswekile egazini eqhelekileyo';

  @override
  String get profileAllergies => 'Ii-aleji';

  @override
  String get profileConditions => 'Izigulo';

  @override
  String get profileTextSize => 'Ubungakanani bombhalo';

  @override
  String get profileBackup => 'I-backup';

  @override
  String get profileThisApp => 'Le app';

  @override
  String get profilePrivacySecurity => 'Ubumfihlo nokhuseleko';

  @override
  String get profileAppLockOn => 'Isitshixo se-app sivuliwe';

  @override
  String get profileSetPinHint =>
      'Misela i-PIN, nibone indlela idatha yenu ekhuselwa ngayo';

  @override
  String get profileLegalAbout => 'Ezomthetho nolwazi';

  @override
  String get profileLegalAboutSubtitle =>
      'Imiqathango, isilumkiso sezempilo, ubumfihlo, iilayisensi';

  @override
  String get profileEraseAll => 'Cima yonke idatha yam';

  @override
  String get profileEraseTitle => 'Cima yonke into?';

  @override
  String get profileEraseMessage =>
      'Onke amayeza, amadinga, imilinganiselo, amanqaku, amaxwebhu nabantu bosapho baya kucinywa. Oku akunakubuyiselwa.';

  @override
  String get profileEraseConfirm => 'Cima';

  @override
  String get profileSaved => 'Iprofayili igciniwe';

  @override
  String get profileSave => 'Gcina iprofayili';

  @override
  String get profileEditTitle => 'Hlela iprofayili';

  @override
  String get profileName => 'Igama';

  @override
  String get profileNameRequired => 'Nceda nifake igama lenu';

  @override
  String get profileEmergencyNumberHint =>
      'I-112 isebenza kuyo nayiphi na iselfowuni';

  @override
  String get profileEmergencyNumberRequired =>
      'Nceda nifake inombolo yongxamiseko';

  @override
  String get profileBloodGroupHint => 'umz. O+';

  @override
  String get profileBloodPressureHint => 'umz. 120/80';

  @override
  String get profileBloodSugarHint => 'umz. Iqhelekile';

  @override
  String get profileAllergiesHint => 'umz. Penicillin';

  @override
  String get profileConditionsHint =>
      'umz. Iswekile (Type 2), uxinzelelo lwegazi oluphezulu';

  @override
  String get profileTextSizeNormal => 'Eqhelekileyo';

  @override
  String get profileTextSizeLarge => 'Enkulu';

  @override
  String get profileTextSizeExtraLarge => 'Enkulu kakhulu';

  @override
  String get profileTextSizeExplain =>
      'Yenza wonke umbhalo kule app ube mkhulu. Yongeza kubungakanani bombhalo befowuni yenu.';

  @override
  String get backupProtectTitle => 'Khusela i-backup yenu?';

  @override
  String get backupProtectMessage =>
      'I-backup ineenkcukacha zempilo yenu. Iphasiwedi iyazigcina ziyimfihlo ukuba ifayile ingena ezandleni ezingalunganga. Yibhaleni phantsi: ngaphandle kwayo i-backup ayinakuvulwa.';

  @override
  String get backupPasswordLabel => 'Iphasiwedi ye-backup';

  @override
  String get backupNoPassword => 'Akukho phasiwedi';

  @override
  String get backupUsePassword => 'Sebenzisa iphasiwedi';

  @override
  String get backupShareSubject => 'I-backup ye-Elderly Care';

  @override
  String get backupReady =>
      'I-backup ilungile. Yigcineni kwindawo ekhuselekileyo, njenge-imeyile yenu okanye kwi-cloud.';

  @override
  String get backupFailed => 'Asikwazanga ukwenza i-backup.';

  @override
  String get backupRestoreTitle => 'Buyisela idatha kwi-backup?';

  @override
  String get backupRestoreMessage =>
      'Yonke into ekule app ngoku iza kutshintshwa ngento ekwifayile ye-backup.';

  @override
  String get backupChooseFile => 'Khetha ifayile';

  @override
  String get backupCouldNotReadFile => 'Asikwazanga ukufunda loo fayile.';

  @override
  String get backupProtectedMessage =>
      'Le backup ikhuselwe. Fakani iphasiwedi enayikhethayo xa beniyenza.';

  @override
  String get backupWrongPasswordRetry =>
      'Loo phasiwedi ayichanekanga. Nceda nizame kwakhona.';

  @override
  String get backupPasswordTitle => 'Iphasiwedi ye-backup';

  @override
  String get backupPassword => 'Iphasiwedi';

  @override
  String get backupRestore => 'Buyisela';

  @override
  String get backupRestored => 'I-backup ibuyiselwe';

  @override
  String get backupBackUp => 'Yenza i-backup yedatha yam';

  @override
  String get backupBackUpSubtitle =>
      'Gcina yonke into kwifayile eninokuyithumela kwi-imeyile yenu okanye niyigcine kwi-cloud.';

  @override
  String get backupRestoreFrom => 'Buyisela kwi-backup';

  @override
  String get backupRestoreFromSubtitle =>
      'Sebenzisani oku kwifowuni entsha ukuze nibuyise idatha yenu.';

  @override
  String get backupErrorNotBackup =>
      'Le fayile ayiyiyo i-backup ye-Elderly Care.';

  @override
  String get backupErrorTooLarge =>
      'Le fayile inkulu kakhulu ukuba ingaba yi-backup.';

  @override
  String get backupErrorDamaged =>
      'Le backup yonakele, asikwazanga ukuyifunda.';

  @override
  String get backupErrorNoProfile => 'Le backup ayinayo iprofayili.';

  @override
  String get backupErrorUnknownProtection =>
      'Le backup isebenzisa indlela yokukhusela engaziwayo.';

  @override
  String get securityTitle => 'Ubumfihlo nokhuseleko';

  @override
  String get securityWrongPin => 'Loo PIN ayichanekanga.';

  @override
  String get securityTooManyAttempts =>
      'Nizame kaninzi ngendlela engachanekanga. Nceda nilinde kancinci, nize nizame kwakhona.';

  @override
  String get securityChoosePin => 'Khetha i-PIN';

  @override
  String get securityChoosePinMessage =>
      'Niza kuchwetheza le PIN ukuvula i-Elderly Care. Sebenzisani amanani asuka kwi-4 ukuya kwi-8 abanye abantu abangenakuwaqikelela.';

  @override
  String get securityNewPin => 'I-PIN entsha';

  @override
  String get securityPinUnavailable =>
      'Esi sixhobo asikwazi ukugcina i-PIN ngokukhuselekileyo, ngoko isitshixo se-app asifumaneki apha.';

  @override
  String get securityAppLockOn => 'Isitshixo se-app sivuliwe';

  @override
  String get securityAppLockOff => 'Isitshixo se-app sicinyiwe';

  @override
  String get securityEnterCurrentPin => 'Fakani i-PIN yenu yangoku.';

  @override
  String get securityCurrentPin => 'I-PIN yangoku';

  @override
  String get securityChangePin => 'Tshintsha i-PIN';

  @override
  String get securityTurnOffAppLock => 'Cima isitshixo se-app';

  @override
  String get securityAppLock => 'Isitshixo se-app';

  @override
  String get securityAppLockOnDetail =>
      'I-app icela i-PIN yenu xa ivulwa, nasemva kokuba ingasetyenziswanga imizuzu emi-2.';

  @override
  String get securityAppLockOffDetail =>
      'Nabani na obambe ifowuni yenu angazibona iinkcukacha zempilo yenu. I-PIN iyazigcina ziyimfihlo.';

  @override
  String get securityLockNow => 'Tshixa ngoku';

  @override
  String get securityTurnOff => 'Cima';

  @override
  String get securityLockWithPin => 'Tshixa nge-PIN';

  @override
  String get securityBiometrics => 'Vula ngomnwe okanye ngobuso';

  @override
  String get securityMedicalIdWhenLocked =>
      'Bonisa isazisi sezempilo xa itshixiwe';

  @override
  String get securityMedicalIdWhenLockedDetail =>
      'Ivumela abasebenzi be-ambulensi babone ii-aleji namayeza enu, kwaye bafowunele uncedo ngaphandle kwe-PIN yenu.';

  @override
  String get securityHowProtected => 'Indlela ulwazi lwenu olukhuselwa ngayo';

  @override
  String get securityEncrypted => 'Lufihliwe (encrypted) kwesi sixhobo';

  @override
  String get securityNotEncrypted => 'Alufihlwanga (encrypted) kwesi sixhobo';

  @override
  String get securityEncryptedDetail =>
      'Iinkcukacha zempilo yenu zixutywe ngesitshixo esigcinwe kwindawo ekhuselekileyo yesi sixhobo.';

  @override
  String get securityNotEncryptedDetail =>
      'Le bhrawuza ayinayo indawo yokugcina ekhuselekileyo. Sebenzisani i-app yefowuni, okanye nivule iwebhusayithi nge-https.';

  @override
  String get securityLocalOnly => 'Lugcinwe kwesi sixhobo kuphela';

  @override
  String get securityLocalOnlyDetail =>
      'Akukho akhawunti kwaye akukho seva. Akukho nto ithunyelwa kwi-intanethi, kwaye akukho zibhengezo okanye ukulandelwa.';

  @override
  String get securitySharedByChoice => 'Luthunyelwa kuphela xa nikhetha';

  @override
  String get securitySharedByChoiceDetail =>
      'Iminxeba nee-SMS zihamba ngefowuni yenu. Izishwankathelo zempilo nee-backup ziphuma kwi-app kuphela xa nizithumela.';

  @override
  String get securityHospitalSearch => 'Ukukhangela izibhedlele';

  @override
  String get securityHospitalSearchDetail =>
      'Ukuze kufunyanwe izibhedlele, indawo eningakuyo ithunyelwa kwinkonzo yasimahla ye-OpenStreetMap. Akukho nto yimbi ngani ithunyelwayo.';

  @override
  String get securityVideoCalls => 'Iminxeba yevidiyo';

  @override
  String get securityVideoCallsDetail =>
      'Iminxeba isebenzisa inkonzo yasimahla ye-Jitsi Meet kwigumbi labucala elinegama elide elingaqikelelekiyo. Ngabantu enibathumelele ilinki kuphela abanokungena.';

  @override
  String get securityNoCloudCopy => 'Akukho kopi ezenzekelayo kwi-cloud';

  @override
  String get securityNoCloudCopyDetail =>
      'Ifowuni ayiyikopi idatha yale app kwi-cloud. Sebenzisani \"Yenza i-backup yedatha yam\" kwiProfayili yam, ngcono ngephasiwedi.';

  @override
  String get securityReadPrivacyPolicy => 'Funda wonke umgaqo-nkqubo wabucala';

  @override
  String get securityEraseAnyTime =>
      'Ningacima yonke into nangaliphi na ixesha kwiProfayili yam.';

  @override
  String get medicalIdTitle => 'Isazisi sezempilo';

  @override
  String get medicalIdFooter =>
      'Gcinani iinkcukacha zenu zihlaziyiwe kwiProfayili yam.';

  @override
  String get medicalIdNotRecorded => 'Akubhalwanga';

  @override
  String get medicalIdAge => 'Ubudala';

  @override
  String get medicalIdBloodGroup => 'Uhlobo lwegazi';

  @override
  String get medicalIdAllergies => 'Ii-aleji';

  @override
  String get medicalIdConditions => 'Izigulo';

  @override
  String get medicalIdMedicines => 'Amayeza';

  @override
  String get medicalIdEmergencyContacts => 'Abantu bongxamiseko';

  @override
  String medicalIdCallContact(String name) {
    return 'Fowunela u-$name';
  }

  @override
  String medicalIdSpeakTitle(String name) {
    return 'Isazisi sezempilo sika-$name.';
  }

  @override
  String medicalIdSpeakAge(String age) {
    return 'Ubudala $age.';
  }

  @override
  String medicalIdSpeakBloodGroup(String group) {
    return 'Uhlobo lwegazi $group.';
  }

  @override
  String get medicalIdSpeakNoAllergies => 'Akukho aleji ibhaliweyo.';

  @override
  String medicalIdSpeakAllergies(String allergies) {
    return 'Ii-aleji: $allergies.';
  }

  @override
  String medicalIdSpeakConditions(String conditions) {
    return 'Izigulo: $conditions.';
  }

  @override
  String medicalIdSpeakMedicines(String medicines) {
    return 'Amayeza: $medicines.';
  }

  @override
  String medicalIdSpeakContact(String name, String phone) {
    return 'Umntu wongxamiseko: $name, $phone.';
  }

  @override
  String medicalIdSpeakContactWithRelationship(
    String name,
    String relationship,
    String phone,
  ) {
    return 'Umntu wongxamiseko: $name, $relationship, $phone.';
  }

  @override
  String get secretOk => 'Kulungile';

  @override
  String secretMinDigits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sebenzisa ubuncinane amanani angama-$count',
      one: 'Sebenzisa ubuncinane inani eli-1',
    );
    return '$_temp0';
  }

  @override
  String secretMinCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sebenzisa ubuncinane oonobumba aba-$count',
      one: 'Sebenzisa ubuncinane unobumba o-1',
    );
    return '$_temp0';
  }

  @override
  String get secretTypeAgain => 'Phinda uyichwetheze';

  @override
  String get secretNoMatch => 'Ezi zimbini azifani';

  @override
  String get secretShowPin => 'Bonisa i-PIN';

  @override
  String get secretShowPassword => 'Bonisa iphasiwedi';

  @override
  String get homeMyProfile => 'Iprofayili yam';

  @override
  String homeGreeting(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeWhatToDo => 'Ningathanda ukwenza ntoni?';

  @override
  String get homeSosTitle => 'Ndifuna uncedo';

  @override
  String get homeSosSubtitle => 'Biza uncedo okanye nazise usapho';

  @override
  String get homeNoMedicines => 'Akukabikho mayeza';

  @override
  String get homeNoMedicinesHint => 'Yongeza iyeza ukuze nifumane izikhumbuzo';

  @override
  String get homeAllMedicinesDone => 'Onke amayeza anamhlanje athathiwe';

  @override
  String homeDosesTaken(int taken, int total) {
    return 'Kuthathwe $taken kwezi-$total';
  }

  @override
  String homeTimeFor(String medicine) {
    return 'Lixesha le-$medicine';
  }

  @override
  String homeNextMedicine(String medicine) {
    return 'Elilandelayo: $medicine';
  }

  @override
  String get homeCheckDose => 'Jonga';

  @override
  String homeRefillSoon(String medicine) {
    return 'Landani i-$medicine kungekudala';
  }

  @override
  String homeDosesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kushiyeke iidosi ezi-$count kuphela',
      one: 'Kushiyeke idosi e-1 kuphela',
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
    return 'Namhlanje ngu-$date.';
  }

  @override
  String get homeSpokenNoMedicines => 'Aninawo amayeza amiselweyo.';

  @override
  String get homeSpokenAllTaken => 'Niwathathile onke amayeza enu anamhlanje.';

  @override
  String homeSpokenDoseDue(String medicine, String time) {
    return 'Lixesha le-$medicine ngo-$time.';
  }

  @override
  String homeSpokenDoseDueWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'Lixesha le-$medicine, $dosage, ngo-$time.';
  }

  @override
  String homeSpokenDoseNext(String medicine, String time) {
    return 'Iyeza lenu elilandelayo yi-$medicine ngo-$time.';
  }

  @override
  String homeSpokenDoseNextWithDosage(
    String medicine,
    String dosage,
    String time,
  ) {
    return 'Iyeza lenu elilandelayo yi-$medicine, $dosage, ngo-$time.';
  }

  @override
  String homeSpokenRefill(String medicine) {
    return 'Ningalibali ukulanda i-$medicine kungekudala.';
  }

  @override
  String homeSpokenAppointment(String doctor, String day, String time) {
    return 'Idinga lenu elilandelayo lino-$doctor, $day ngo-$time.';
  }

  @override
  String get lockEnterPin => 'Fakani i-PIN yenu';

  @override
  String get lockPinTooShort => 'I-PIN yenu inamanani amane ubuncinane.';

  @override
  String lockPinWrong(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'Kushiyeke amathuba angama-$left',
      one: 'Kushiyeke ithuba eli-1',
    );
    return 'Loo PIN ayichanekanga. $_temp0 ngaphambi kokuba nilinde kancinci.';
  }

  @override
  String get lockTooManyTries => 'Nizame kaninzi ngendlela engachanekanga.';

  @override
  String lockWait(String time) {
    return 'Nizame kaninzi ngendlela engachanekanga. Zamani kwakhona emva kwe-$time.';
  }

  @override
  String lockPinDigitsEntered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kufakwe amanani angama-$count',
      one: 'Kufakwe inani eli-1',
    );
    return '$_temp0';
  }

  @override
  String get lockUseBiometrics => 'Sebenzisa umnwe okanye ubuso';

  @override
  String get lockEmergency => 'Ingxamiseko';

  @override
  String get lockForgotPin => 'Nilibele i-PIN?';

  @override
  String lockCallNumber(String number) {
    return 'Fowunela i-$number';
  }

  @override
  String get lockMedicalIdHidden =>
      'Isazisi sezempilo sifihliwe xa i-app itshixiwe.';

  @override
  String get lockForgotTitle => 'Niyilibele i-PIN yenu?';

  @override
  String get lockForgotBody =>
      'Ukukhusela ubumfihlo benu, i-PIN ayinakubuyiswa. Ningacima yonke into kwi-app niqale kwakhona. Ukuba nayenza i-backup, ningayibuyisela emva koko kwiProfayili yam.';

  @override
  String get lockEraseEverything => 'Cima yonke into uqale kwakhona';

  @override
  String get lockEraseConfirm => 'Ewe, cima yonke into';

  @override
  String get lockEraseWarning =>
      'Oku akunakubuyiselwa. Cofa kwakhona ukuqinisekisa.';

  @override
  String get lockKeyDelete => 'Cima';

  @override
  String get lockKeyUnlock => 'Vula';

  @override
  String get onboardingSkip => 'Tsiba';

  @override
  String get onboardingGetStarted => 'Masiqale';

  @override
  String get onboardingMedicinesTitle => 'Ningaze niliphose iyeza';

  @override
  String get onboardingMedicinesText =>
      'Fumanani isikhumbuzo xa ixesha ledosi ngalinye lifikile, kwaye nazise usapho lwenu ukuba enye iphosiwe.';

  @override
  String get onboardingAppointmentsTitle => 'Khumbulani amadinga';

  @override
  String get onboardingAppointmentsText =>
      'Gcinani amadinga enu kagqirha kwindawo enye, kwaye nifumane isikhumbuzo iyure enye ngaphambili.';

  @override
  String get onboardingHealthTitle => 'Jongani impilo yenu';

  @override
  String get onboardingHealthText =>
      'Bhalani uxinzelelo lwegazi, iswekile egazini, ubunzima nobuthongo, nibone indlela ezitshintsha ngayo.';

  @override
  String get onboardingHospitalsTitle => 'Fumanani uncedo olukufutshane';

  @override
  String get onboardingHospitalsText =>
      'Bonani izibhedlele neekliniki ezikufutshane, kunye neendlela zokufika neenombolo zefowuni.';

  @override
  String get onboardingFamilyTitle => 'Usapho lukufutshane, ngokucofa kanye';

  @override
  String get onboardingFamilyText =>
      'Fowunelani usapho lwenu, nibathumelele i-SMS okanye nithethe nabo ngevidiyo, okanye nibathumelele indawo eningakuyo kungxamiseko.';

  @override
  String get setupWelcome => 'Namkelekile kwi-Elderly Care';

  @override
  String get setupIntro =>
      'Siza kucela iinkcukacha ezimbalwa nje ukuze niqale. Yonke into ihlala kule fowuni.';

  @override
  String get setupAboutYou => 'Malunga nani';

  @override
  String get setupYourName => 'Igama lenu';

  @override
  String get setupNameRequired => 'Nceda nifake igama lenu';

  @override
  String get setupYourPhone => 'Inombolo yenu yefowuni (asinyanzelekanga)';

  @override
  String get setupEmergencyContact => 'Umntu wongxamiseko';

  @override
  String get setupEmergencyContactInfo =>
      'Umntu esinokumfowunela okanye simthumelele i-SMS egameni lenu xa nifuna uncedo.';

  @override
  String get setupTheirName => 'Igama lakhe';

  @override
  String get setupRelationship => 'Nizalana njani';

  @override
  String get setupRelationshipHint => 'umz. Intombi';

  @override
  String get setupTheirPhone => 'Inombolo yakhe yefowuni';

  @override
  String get setupTheirPhoneRequired => 'Nceda nifake inombolo yakhe yefowuni';

  @override
  String get setupAddMoreLater => 'Ningongeza amalungu osapho amaninzi kamva.';

  @override
  String get legalDocTerms => 'Imiqathango yokusebenzisa';

  @override
  String get legalDocMedical => 'Isilumkiso sezempilo';

  @override
  String get legalDocPrivacy => 'Umgaqo-nkqubo wabucala';

  @override
  String get legalDocAccessibility => 'Ingxelo yokufikeleleka';

  @override
  String get legalDocCredits => 'Imbulelo nezaziso zabanye abantu';

  @override
  String get legalReadTerms => 'Funda imiqathango yokusebenzisa';

  @override
  String get legalReadPrivacy => 'Funda umgaqo-nkqubo wabucala';

  @override
  String get legalEnglishOnly =>
      'Eli xwebhu lifumaneka ngesiNgesi kuphela. Inguqulelo yesiNgesi yiyo esemthethweni.';

  @override
  String get legalHubTitle => 'Ezomthetho nolwazi';

  @override
  String get legalOpenSourceLicences => 'Iilayisensi ze-open-source';

  @override
  String legalAppVersion(String version) {
    return 'Elderly Care, inguqulelo $version';
  }

  @override
  String legalVersion(String version) {
    return 'Inguqulelo $version';
  }

  @override
  String legalAcceptedOn(int version, String date) {
    return 'Nayamkela inguqulelo $version yala maxwebhu ngo-$date.';
  }

  @override
  String get legalAgree =>
      'Ndiyavumelana neMiqathango yokusebenzisa, kwaye ndifundile iSilumkiso sezempilo noMgaqo-nkqubo wabucala';

  @override
  String get legalTickBox => 'Nceda niphawule ibhokisi ukuze niqhubeke.';

  @override
  String get legalNotMedicalService =>
      'I-Elderly Care ayiyonkonzo yezempilo. Kungxamiseko, fowunela i-112.';

  @override
  String get legalReviewTitle => 'Nceda nijonge imiqathango yethu';

  @override
  String get legalUpdatedTitle => 'Imiqathango yethu ihlaziyiwe';

  @override
  String legalUpdateBody(int version, String date) {
    return 'Ngaphambi kokuba niqhubeke, nceda nifunde kwaye namkele iMiqathango yokusebenzisa, iSilumkiso sezempilo noMgaqo-nkqubo wabucala (inguqulelo $version, isebenza ukususela ngo-$date). Ulwazi lwenu luhlala kwesi sixhobo.';
  }

  @override
  String get medicinesTitle => 'Amayeza';

  @override
  String get medicinesAdd => 'Yongeza iyeza';

  @override
  String get medicinesEmptyTitle => 'Akukabikho mayeza';

  @override
  String get medicinesEmptyMessage =>
      'Yongezani amayeza enu, kwaye siza kunikhumbuza xa ixesha ledosi ngalinye lifikile.';

  @override
  String get medicinesTodaySchedule => 'Uludwe lwanamhlanje';

  @override
  String medicinesTakenToday(int taken, int total) {
    return 'Kuthathwe $taken kwezi-$total';
  }

  @override
  String get medicinesMine => 'Amayeza am';

  @override
  String medicinesTimesADay(int count) {
    return '$count× ngemini';
  }

  @override
  String get medicinesDisclaimer =>
      'Soloko nithatha amayeza njengoko ugqirha okanye usokhemesti enixelele. Izikhumbuzo ngamanye amaxesha zingafika emva kwexesha, ngoko musani ukuthembela kuzo zodwa.';

  @override
  String medicinesSupplyLow(int count) {
    return 'Kushiyeke iidosi ezi-$count kuphela – lixesha lokufumana amanye';
  }

  @override
  String medicinesSupplyLeft(int count, int days) {
    return 'Kushiyeke iidosi ezi-$count (malunga neentsuku ezi-$days)';
  }

  @override
  String medicinesLastWeek(int taken, int due) {
    return 'Iintsuku ezi-7 ezidlulileyo: kuthathwe iidosi ezi-$taken kwezi-$due';
  }

  @override
  String get medicinesLateTitle => 'Izikhumbuzo zingafika emva kwexesha';

  @override
  String get medicinesLateMessage =>
      'Ifowuni yenu igcina ibhetri ngokulibazisa izikhumbuzo. Vumelani i-Elderly Care inikhumbuze ngexesha elichanekileyo.';

  @override
  String get medicinesLateAllow => 'Vumela izikhumbuzo ngexesha';

  @override
  String get doseStatusTaken => 'Ithathiwe';

  @override
  String get doseStatusNotTaken => 'Ayithathwanga';

  @override
  String get doseStatusOverdue => 'Ixesha ligqithile';

  @override
  String get doseStatusDue => 'Lixesha ngoku';

  @override
  String get doseStatusLater => 'Kamva';

  @override
  String doseRowSubtitle(String time, String status) {
    return '$time · $status';
  }

  @override
  String get doseCheck => 'Jonga';

  @override
  String get doseCheckTitle => 'Ukujonga iyeza';

  @override
  String doseCheckQuestion(String medicine) {
    return 'Ngaba niyithathile i-$medicine yenu?';
  }

  @override
  String doseCheckWhen(String day, String time) {
    return '$day ngo-$time';
  }

  @override
  String get doseCheckYes => 'Ewe, ndiyithathile';

  @override
  String get doseCheckNo => 'Hayi, andikayithathi';

  @override
  String get doseTellFamilyTitle => 'Nazise usapho lwenu?';

  @override
  String doseTellFamilyMessage(String names, String medicine) {
    return 'Singathumela i-SMS ku-$names sisithi aniyithathanga i-$medicine yenu.';
  }

  @override
  String get doseTellFamilySend => 'Thumela i-SMS';

  @override
  String doseMissedSms(String name, String medicine, String time) {
    return 'U-$name akayithathanga i-$medicine ($time) namhlanje. Nceda nimbuze ukuba unjani.';
  }

  @override
  String doseMissedSmsNoName(String medicine, String time) {
    return 'Andiyithathanga i-$medicine ($time) namhlanje. Nceda nindibuze ukuba ndinjani.';
  }

  @override
  String doseRecordedTaken(String medicine) {
    return 'Nenze kakuhle! I-$medicine ibhaliwe.';
  }

  @override
  String doseRecordedNotTaken(String medicine) {
    return 'Siqaphele. I-$medicine ayithathwanga.';
  }

  @override
  String doseTakenFromNotification(String medicine) {
    return 'I-$medicine ibhalwe njengethathiweyo. Nenze kakuhle!';
  }

  @override
  String doseSnoozed(String medicine) {
    return 'Siza kunikhumbuza nge-$medicine kwakhona emva kwemizuzu emi-10.';
  }

  @override
  String get medicineEditTitle => 'Hlela iyeza';

  @override
  String get medicineEditSaveChanges => 'Gcina utshintsho';

  @override
  String get medicineEditSaveNew => 'Gcina isikhumbuzo';

  @override
  String get medicineEditDeleteTooltip => 'Cima iyeza';

  @override
  String medicineEditDeleteTitle(String medicine) {
    return 'Cima i-$medicine?';
  }

  @override
  String get medicineEditDeleteMessage =>
      'Aniyi kuphinda nifumane izikhumbuzo zeli yeza.';

  @override
  String medicineEditReminderSet(String medicine) {
    return 'Isikhumbuzo simiselwe i-$medicine';
  }

  @override
  String medicineEditSaved(String medicine) {
    return 'I-$medicine igciniwe';
  }

  @override
  String get medicineEditNameLabel => 'Igama leyeza';

  @override
  String get medicineEditNameHint => 'umz. Metformin';

  @override
  String get medicineEditNameRequired => 'Nceda nifake igama leyeza';

  @override
  String get medicineEditDosageLabel => 'Kangakanani (asinyanzelekanga)';

  @override
  String get medicineEditDosageHint => 'umz. ipilisi e-1, 500 mg';

  @override
  String get medicineEditSupplyLabel =>
      'Iidosi ezishiyekileyo kwipakethi (asinyanzelekanga)';

  @override
  String get medicineEditSupplyHint => 'umz. 30';

  @override
  String get medicineEditSupplyHelper =>
      'Siza kunilumkisa xa lixesha lokufumana amanye.';

  @override
  String get medicineEditSupplyInvalid => 'Nceda nifake inani elipheleleyo';

  @override
  String get medicineEditType => 'Uhlobo';

  @override
  String get medicineEditHowOften => 'Kangaphi ngemini?';

  @override
  String get medicineEditOnce => 'Kanye';

  @override
  String get medicineEditTwice => 'Kabini';

  @override
  String get medicineEditThreeTimes => 'Kathathu';

  @override
  String get medicineEditAtWhatTimes => 'Ngawaphi amaxesha?';

  @override
  String medicineEditDoseNumber(int number) {
    return 'Idosi $number';
  }

  @override
  String medicineEditDoseTime(int number) {
    return 'Ixesha ledosi $number';
  }

  @override
  String get medicineEditChange => 'Tshintsha';

  @override
  String get appointmentsTitle => 'Amadinga';

  @override
  String appointmentsUpcomingTab(int count) {
    return 'Azayo ($count)';
  }

  @override
  String appointmentsPastTab(int count) {
    return 'Adlulileyo ($count)';
  }

  @override
  String get appointmentsAdd => 'Yongeza idinga';

  @override
  String get appointmentsNoPast => 'Akukho madinga adlulileyo';

  @override
  String get appointmentsNoUpcoming => 'Akukho madinga azayo';

  @override
  String get appointmentsNoPastMessage =>
      'Amadinga afika apha xa sele egqityiwe.';

  @override
  String get appointmentsNoUpcomingMessage =>
      'Yongezani idinga lenu elilandelayo nogqirha, kwaye siza kunikhumbuza iyure enye ngaphambili.';

  @override
  String get appointmentsAttended => 'Ndaya';

  @override
  String get appointmentEditTitle => 'Idinga';

  @override
  String get appointmentEditNewTitle => 'Idinga elitsha';

  @override
  String get appointmentEditSaveChanges => 'Gcina utshintsho';

  @override
  String get appointmentEditSaveNew => 'Gcina idinga';

  @override
  String get appointmentEditDeleteTooltip => 'Cima idinga';

  @override
  String get appointmentEditDeleteTitle => 'Cima idinga?';

  @override
  String appointmentEditDeleteMessage(String doctor) {
    return 'Idinga lenu no-$doctor liza kususwa.';
  }

  @override
  String appointmentEditSaved(String doctor) {
    return 'Idinga no-$doctor ligciniwe';
  }

  @override
  String get appointmentEditDoctorLabel => 'Igama likagqirha';

  @override
  String get appointmentEditDoctorHint => 'umz. Gqr. Naidoo';

  @override
  String get appointmentEditDoctorRequired => 'Nceda nifake igama likagqirha';

  @override
  String get appointmentEditSpecialtyLabel =>
      'Uhlobo lukagqirha (asinyanzelekanga)';

  @override
  String get appointmentEditSpecialtyHint => 'umz. Ugqirha wentliziyo';

  @override
  String get appointmentEditPlaceLabel => 'Phi (asinyanzelekanga)';

  @override
  String get appointmentEditPlaceHint => 'Isibhedlele, ikliniki okanye ekhaya';

  @override
  String get appointmentEditWhen => 'Nini';

  @override
  String get appointmentEditChange => 'Tshintsha';

  @override
  String get appointmentEditNotesLabel => 'Amanqaku (asinyanzelekanga)';

  @override
  String get appointmentEditNotesHint => 'Imibuzo yokubuza, izinto zokuphatha…';

  @override
  String get appointmentEditAttended => 'Ndaya kweli dinga';

  @override
  String get notesTitle => 'Amanqaku';

  @override
  String get notesNew => 'Inqaku elitsha';

  @override
  String get notesEmptyTitle => 'Akukabikho manqaku';

  @override
  String get notesEmptyMessage =>
      'Bhalani izinto zokukhumbula, imibuzo yokubuza ugqirha, okanye nantoni na enye.';

  @override
  String notesUpdated(String day) {
    return 'Ihlaziywe $day';
  }

  @override
  String notesImportantUpdated(String day) {
    return 'Kubalulekile · Ihlaziywe $day';
  }

  @override
  String get noteEditTitle => 'Hlela inqaku';

  @override
  String get noteEditSave => 'Gcina inqaku';

  @override
  String get noteEditSaved => 'Inqaku ligciniwe';

  @override
  String get noteEditDeleteTooltip => 'Cima inqaku';

  @override
  String get noteEditDeleteTitle => 'Cima eli nqaku?';

  @override
  String noteEditDeleteMessage(String title) {
    return '\"$title\" liza kususwa.';
  }

  @override
  String get noteEditTitleLabel => 'Isihloko';

  @override
  String get noteEditTitleRequired => 'Nceda nifake isihloko';

  @override
  String get noteEditBodyLabel => 'Inqaku';

  @override
  String get noteEditHowImportant => 'Libaluleke kangakanani?';

  @override
  String get noteEditImportant => 'Libalulekile';

  @override
  String get noteEditNormal => 'Eliqhelekileyo';

  @override
  String get healthIntro =>
      'Bhalani imilinganiselo yenu, emva koko nicofe Thumela ukuze nithumelele ugqirha wenu isishwankathelo.';

  @override
  String get healthDisclaimer =>
      'Iingcebiso ezilapha lulwazi ngokubanzi lwabantu abadala, asingomcebiso wezempilo. Buzani ugqirha wenu ukuba yeyiphi imilinganiselo efanelekileyo kuni. Ukuba niziva ningaphilanga kakhulu, fowunelani i-112.';

  @override
  String get healthNoReadings => 'Akukabikho milinganiselo';

  @override
  String healthShareSubject(String name) {
    return 'Isishwankathelo sempilo sika-$name';
  }

  @override
  String get healthShareSubjectNoName => 'Isishwankathelo sempilo yam';

  @override
  String get healthShareTitle =>
      'Thumelelani ugqirha wenu isishwankathelo seentsuku ezingama-30 ezidlulileyo';

  @override
  String get healthShareAsPdf => 'Njengoxwebhu lwe-PDF';

  @override
  String get healthShareAsPdfSubtitle =>
      'Iitafile ezicocekileyo, kulula ukuziprinta';

  @override
  String get healthShareAsText => 'Njengomyalezo';

  @override
  String get healthShareAsTextSubtitle =>
      'Umbhalo nje we-imeyile okanye we-WhatsApp';

  @override
  String get trackingAddReading => 'Yongeza umlinganiselo';

  @override
  String get trackingFirstReading =>
      'Yongezani umlinganiselo wenu wokuqala ukuze niqale ukulandela.';

  @override
  String get trackingOneMore =>
      'Yongezani omnye umlinganiselo ukuze nibone itshati.';

  @override
  String get trackingReadings => 'Imilinganiselo';

  @override
  String get trackingDeleteReading => 'Cima umlinganiselo';

  @override
  String get trackingDeleteReadingTitle => 'Cima umlinganiselo?';

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
          'Itshati ye-$type yemilinganiselo emi-$count yokugqibela. Owokugqibela ngu-$latest.',
    );
    return '$_temp0';
  }

  @override
  String trackingFieldRequired(String field) {
    return 'Nceda nifake: $field';
  }

  @override
  String get trackingEnterNumber => 'Nceda nifake inani';

  @override
  String trackingOutOfRange(String min, String max) {
    return 'Kufanele libe phakathi kwe-$min ne-$max';
  }

  @override
  String trackingReadingSaved(String type) {
    return 'Umlinganiselo we-$type ugciniwe';
  }

  @override
  String get trackingSaveReading => 'Gcina umlinganiselo';

  @override
  String trackingNewReadingTitle(String type) {
    return 'Umlinganiselo omtsha we-$type';
  }

  @override
  String get trackingChangeTime => 'Tshintsha';

  @override
  String get trackingNotes => 'Amanqaku (asinyanzelekanga)';

  @override
  String get trackingNotesHint => 'umz. emva kwesidlo sakusasa';

  @override
  String get documentTakePhoto => 'Thatha ifoto';

  @override
  String get documentChooseFromGallery => 'Khetha kwi-gallery';

  @override
  String get documentPickFailed =>
      'Asikwazanga ukuvula ikhamera okanye i-gallery.';

  @override
  String get documentAdd => 'Yongeza uxwebhu';

  @override
  String get documentNoneTitle => 'Akukabikho maxwebhu';

  @override
  String get documentNoneMessage =>
      'Thathani iifoto zeepreskripshini, iziphumo zovavanyo namakhadi e-medical aid ukuze zibe kufutshane.';

  @override
  String get documentSearch => 'Khangela amaxwebhu';

  @override
  String documentNoMatch(String query) {
    return 'Akukho nto ifana no-\"$query\".';
  }

  @override
  String get documentSaved => 'Uxwebhu lugciniwe';

  @override
  String get documentSave => 'Gcina uxwebhu';

  @override
  String get documentName => 'Igama';

  @override
  String get documentNameHint => 'umz. Uvavanyo lwegazi, Matshi';

  @override
  String get documentNameRequired =>
      'Nceda nifake igama ukuze nilufumane kamva';

  @override
  String get documentDelete => 'Cima uxwebhu';

  @override
  String documentDeleteTitle(String name) {
    return 'Cima $name?';
  }

  @override
  String get documentDeleteMessage => 'Le foto iza kususwa kwi-app.';

  @override
  String get hospitalRefresh => 'Hlaziya';

  @override
  String hospitalEmergencyCall(String number) {
    return 'Ingxamiseko? Fowunela i-$number';
  }

  @override
  String get hospitalSearching => 'Sikhangela izibhedlele ezikufutshane nani…';

  @override
  String get hospitalSearchFailed => 'Asikwazanga ukukhangela';

  @override
  String get hospitalCheckInternet =>
      'Nceda nijonge unxibelelwano lwenu lwe-intanethi, nize nizame kwakhona.';

  @override
  String get hospitalTryAgain => 'Zama kwakhona';

  @override
  String get hospitalNoneFound => 'Akukho nto ifunyenweyo kwi-10 km';

  @override
  String get hospitalNoneFoundMessage =>
      'Kungxamiseko, fowunelani inombolo engentla.';

  @override
  String hospitalCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iindawo ezi-$count kwi-10 km',
      one: 'Indawo e-1 kwi-10 km',
    );
    return '$_temp0';
  }

  @override
  String get hospitalListNote =>
      'Olu luhlu lusuka kwi-OpenStreetMap kwaye lusenokungapheleli okanye lungahlaziywanga. Ayizizo zonke iindawo ezinecandelo longxamiseko: fowunani kuqala ukuba niyakwazi.';

  @override
  String get hospitalAttribution => 'Idatha © abanegalelo be-OpenStreetMap';

  @override
  String hospitalDistanceMeters(int meters) {
    return '$meters m ukusuka apha';
  }

  @override
  String hospitalDistanceKm(String km) {
    return '$km km ukusuka apha';
  }

  @override
  String get hospitalDirections => 'Indlela';

  @override
  String get sosTitle => 'Singanceda njani?';

  @override
  String get sosCallEmergency => 'Fowunela iinkonzo zongxamiseko';

  @override
  String sosDial(String number) {
    return 'Cofa i-$number';
  }

  @override
  String get sosAlertFamily => 'Yazisa usapho lwam';

  @override
  String get sosAlertFamilySubtitle =>
      'Thumelela bonke indawo endikuyo nge-SMS';

  @override
  String get sosShowMedicalId => 'Bonisa isazisi sam sezempilo';

  @override
  String get sosShowMedicalIdSubtitle =>
      'Ii-aleji, amayeza nabantu bongxamiseko, kwabo banceda';

  @override
  String sosCallPerson(String name) {
    return 'Fowunela u-$name';
  }

  @override
  String get sosAddFamilyFirst =>
      'Yongezani ilungu losapho ukuze sazi ukuba sazise bani.';

  @override
  String get sosAddFamily => 'Yongeza usapho';

  @override
  String get sosFindingLocation => 'Sifuna indawo eningakuyo…';

  @override
  String sosSendingWithoutLocation(String problem) {
    return '$problem Siyathumela ngaphandle kwendawo.';
  }

  @override
  String get sosLocationUnavailable =>
      'Indawo ayifumaneki. Siyathumela ngaphandle kwayo.';

  @override
  String sosAlertSms(String name) {
    return 'U-$name udinga uncedo, kwaye ucele i-Elderly Care ukuba inazise.';
  }

  @override
  String sosAlertSmsWithLocation(String name, String link) {
    return 'U-$name udinga uncedo, kwaye ucele i-Elderly Care ukuba inazise. Indawo akuyo ngoku: $link';
  }

  @override
  String get sosAlertSmsNoName =>
      'Ndidinga uncedo, kwaye ndicele i-Elderly Care ukuba inazise.';

  @override
  String sosAlertSmsNoNameWithLocation(String link) {
    return 'Ndidinga uncedo, kwaye ndicele i-Elderly Care ukuba inazise. Indawo endikuyo ngoku: $link';
  }

  @override
  String get familyAddPerson => 'Yongeza umntu';

  @override
  String get familyNoneTitle => 'Akukabikho bantu bosapho';

  @override
  String get familyNoneMessage =>
      'Yongezani abantu abanikhathalelayo ukuze nikwazi ukubafikelela ngokukhawuleza.';

  @override
  String get familyAlertEveryone => 'Yazisa wonke umntu ngendawo endikuyo';

  @override
  String familyEditPerson(String name) {
    return 'Hlela u-$name';
  }

  @override
  String relativeSaved(String name) {
    return 'U-$name ugciniwe';
  }

  @override
  String relativeRemoveTitle(String name) {
    return 'Susa u-$name?';
  }

  @override
  String get relativeRemoveMessage => 'Akasayi kuphinda aziswe kungxamiseko.';

  @override
  String get relativeEditTitle => 'Hlela ilungu losapho';

  @override
  String get relativeAddTitle => 'Yongeza ilungu losapho';

  @override
  String get relativeRemove => 'Susa ilungu losapho';

  @override
  String get relativeName => 'Igama';

  @override
  String get relativeNameRequired => 'Nceda nifake igama';

  @override
  String get relativeRelationship => 'Nizalana njani (asinyanzelekanga)';

  @override
  String get relativeRelationshipHint => 'umz. Unyana, Ummelwane, Unesi';

  @override
  String get relativePhone => 'Inombolo yefowuni';

  @override
  String get relativePhoneRequired => 'Nceda nifake inombolo yefowuni';

  @override
  String get relativePhoneTooShort => 'Le nombolo ibonakala imfutshane kakhulu';

  @override
  String get relativeEmail => 'I-imeyile (asinyanzelekanga)';

  @override
  String get videoHeading => 'Bonani nithethe nosapho lwenu';

  @override
  String get videoExplanation =>
      'Umnxeba uvuleka kwibhrawuza yenu okanye kwi-app ye-Jitsi Meet. Ngowasimahla kwaye awudingi akhawunti.';

  @override
  String get videoTextFamily => 'Thumela usapho lwam ilinki nge-SMS';

  @override
  String get videoAddFamilyFirst => 'Yongeza usapho kuqala';

  @override
  String get videoVoiceOnly => 'Ilizwi kuphela (akukho khamera)';

  @override
  String get videoStartMuted => 'Qala imakrofoni icinyiwe';

  @override
  String get videoStart => 'Qala umnxeba wevidiyo';

  @override
  String get videoOpenFailed => 'Asikwazanga ukuvula umnxeba wevidiyo.';

  @override
  String videoInviteSms(String name, String link) {
    return 'U-$name ufuna ukuthetha nani ngevidiyo. Ngenani apha: $link';
  }

  @override
  String get locationOff =>
      'Indawo icinyiwe. Nceda niyivule kwiisetingi zefowuni yenu.';

  @override
  String get locationNoPermission =>
      'I-Elderly Care idinga imvume yokubona indawo eningakuyo.';

  @override
  String get locationNotFound => 'Asikwazanga ukufumana indawo eningakuyo.';

  @override
  String get shareBackupPickerTitle => 'Khetha i-backup yenu ye-Elderly Care';

  @override
  String setupStepOf(int step, int total) {
    return 'Inyathelo $step kwa-$total';
  }

  @override
  String get setupSkip => 'Tsiba';

  @override
  String get setupFinish => 'Gqiba';

  @override
  String get setupNickname => 'Ningathanda sinibize ngokuthini?';

  @override
  String get setupNicknameHint => 'umz. Makhulu, Tatomkhulu okanye Mama Mbeki';

  @override
  String get setupNicknameHelp =>
      'Ukuba niyishiya ingabhalwanga, siza kusebenzisa igama lenu lokuqala.';

  @override
  String get setupReadingTitle => 'Ngaba oku kulula ukufunda?';

  @override
  String get setupReadingBody =>
      'Khethani ubungakanani bombhalo obunilungeleyo. Ningabutshintsha nangaliphi na ixesha kwiProfayili yam.';

  @override
  String get setupReadingSample => 'Lixesha lepilisi yenu yoxinzelelo lwegazi.';

  @override
  String get setupHelpTitle => 'Ningathanda ukuncedwa ngantoni?';

  @override
  String get setupHelpBody =>
      'Khethani ezininzi kangangoko nifuna. Ziya kuvela kuqala kwisikrini senu sasekhaya, kwaye yonke enye into iya kuhlala ikhona.';

  @override
  String get setupDayTitle => 'Sixeleleni ngosuku lwenu';

  @override
  String get setupDayBody =>
      'Siza kunicebisa ngamaxesha amayeza ahambelana nosuku lwenu.';

  @override
  String get setupWakeUp => 'Ndidla ngokuvuka ngo';

  @override
  String get setupBedtime => 'Ndidla ngokulala ngo';

  @override
  String setupDaySuggestion(String times) {
    return 'Amaxesha amayeza acetyiswayo: $times';
  }

  @override
  String get setupHealthTitle => 'Iinkcukacha ezimbalwa zempilo';

  @override
  String get setupHealthBody =>
      'Ezi ziya kwiSazisi senu sezempilo, ukuze abasebenzi be-ambulensi noogqirha banincede ngokukhawuleza. Ningakutsiba oku, nizongeze kamva.';

  @override
  String get setupBloodGroupUnknown => 'Andazi';

  @override
  String setupFinishTitle(String name) {
    return 'Yonke into ilungile, $name!';
  }

  @override
  String get setupFinishBody =>
      'Nantsi into esiniselele yona. Nceda nifunde kwaye namkele imiqathango yethu ukuze nigqibe.';

  @override
  String setupSummaryName(String name) {
    return 'Siza kunibiza ngokuthi $name.';
  }

  @override
  String setupSummaryFirst(String features) {
    return 'Isikrini senu sasekhaya siqala ngezi: $features.';
  }

  @override
  String setupSummaryContact(String name) {
    return 'U-$name ngumntu wenu wongxamiseko.';
  }

  @override
  String get setupSummaryNoContact =>
      'Akukabikho mntu wongxamiseko. Ningamongeza ku-\"Usapho lwam\".';

  @override
  String get startTitle => 'Masiqale';

  @override
  String get startBody =>
      'Amanyathelo ambalwa okuqala ukuze le app inincede kakuhle.';

  @override
  String get startAllDone => 'Yonke into ilungile';

  @override
  String get startAllDoneBody => 'Nenze kakuhle! Ningakuvala oku ngoku.';

  @override
  String get startAddMedicine => 'Yongezani iyeza lenu lokuqala';

  @override
  String get startAddAppointment =>
      'Yongezani idinga lenu elilandelayo kugqirha';

  @override
  String get startAddFamily => 'Yongezani umntu wosapho lwenu';

  @override
  String get startAddPin => 'Khuselani i-app nge-PIN';

  @override
  String get profileMadeForYou => 'Okwenzelwe nina';

  @override
  String get profileCallMe => 'Sinibiza ngokuthi';

  @override
  String get profileMyDay => 'Usuku lwam';

  @override
  String profileMyDayValue(String wake, String bed) {
    return 'Ndivuka ngo-$wake, ndilala ngo-$bed';
  }

  @override
  String get profileHomeFirst => 'Okuqala kwisikrini sam sasekhaya';

  @override
  String get profileHomeFirstNone => 'Yonke into, ngendlela eqhelekileyo';
}
