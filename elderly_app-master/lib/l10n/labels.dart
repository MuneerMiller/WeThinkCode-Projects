import '../data/models.dart';
import '../theme.dart';
import 'gen/app_localizations.dart';

// Translated names for the app's fixed lists. The English names on the
// enums themselves are kept for the doctor summaries, which stay in English.

extension FeatureL10n on Feature {
  String title(AppLocalizations l) => switch (this) {
    Feature.medicines => l.featureMedicines,
    Feature.appointments => l.featureAppointments,
    Feature.health => l.featureHealth,
    Feature.family => l.featureFamily,
    Feature.hospitals => l.featureHospitals,
    Feature.videoCall => l.featureVideoCall,
    Feature.documents => l.featureDocuments,
    Feature.notes => l.featureNotes,
  };

  String description(AppLocalizations l) => switch (this) {
    Feature.medicines => l.featureMedicinesSubtitle,
    Feature.appointments => l.featureAppointmentsSubtitle,
    Feature.health => l.featureHealthSubtitle,
    Feature.family => l.featureFamilySubtitle,
    Feature.hospitals => l.featureHospitalsSubtitle,
    Feature.videoCall => l.featureVideoCallSubtitle,
    Feature.documents => l.featureDocumentsSubtitle,
    Feature.notes => l.featureNotesSubtitle,
  };
}

extension MedicineTypeL10n on MedicineType {
  String title(AppLocalizations l) => switch (this) {
    MedicineType.tablet => l.medicineTypeTablet,
    MedicineType.capsule => l.medicineTypeCapsule,
    MedicineType.syrup => l.medicineTypeSyrup,
    MedicineType.drops => l.medicineTypeDrops,
    MedicineType.injection => l.medicineTypeInjection,
    MedicineType.inhaler => l.medicineTypeInhaler,
    MedicineType.other => l.medicineTypeOther,
  };
}

extension TrackerTypeL10n on TrackerType {
  String title(AppLocalizations l) => switch (this) {
    TrackerType.bloodPressure => l.trackerBloodPressure,
    TrackerType.bloodSugar => l.trackerBloodSugar,
    TrackerType.weight => l.trackerWeight,
    TrackerType.sleep => l.trackerSleep,
  };

  String hint(AppLocalizations l) => switch (this) {
    TrackerType.bloodPressure => l.trackerBloodPressureTip,
    TrackerType.bloodSugar => l.trackerBloodSugarTip,
    TrackerType.weight => l.trackerWeightTip,
    TrackerType.sleep => l.trackerSleepTip,
  };
}

extension TrackerFieldL10n on TrackerField {
  String title(AppLocalizations l) => switch (key) {
    'systolic' => l.trackerFieldSystolic,
    'diastolic' => l.trackerFieldDiastolic,
    'pulse' => l.trackerFieldPulse,
    'glucose' => l.trackerFieldGlucose,
    'weight' => l.trackerFieldWeight,
    'hours' => l.trackerFieldHours,
    'minutes' => l.trackerFieldMinutes,
    _ => label,
  };
}

extension TrackerEntryL10n on TrackerEntry {
  /// [TrackerEntry.display] with translated units where they are words.
  String displayIn(AppLocalizations l) => switch (type) {
    TrackerType.sleep => l.trackerSleepValue(
      values['hours'] ?? 0,
      values['minutes'] ?? 0,
    ),
    _ => display,
  };
}
