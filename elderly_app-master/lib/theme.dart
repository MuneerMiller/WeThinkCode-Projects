import 'package:flutter/material.dart';

/// Calm, high-contrast theme with large type and generous touch targets,
/// tuned for older eyes and hands.
class AppTheme {
  static const seed = Color(0xFF1B6B5F);
  static const sos = Color(0xFFC62828);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      surface: brightness == Brightness.light ? const Color(0xFFFBF8F3) : null,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Lexend',
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
    final text = base.textTheme.copyWith(
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.textTheme.titleSmall?.copyWith(fontSize: 17),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 19, height: 1.4),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        fontSize: 17,
        height: 1.4,
      ),
      bodySmall: base.textTheme.bodySmall?.copyWith(fontSize: 15),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    const buttonSize = Size(64, 58);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 14);

    return base.copyWith(
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
        iconTheme: const IconThemeData(size: 28),
        actionsIconTheme: const IconThemeData(size: 28),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 14,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        titleTextStyle: text.titleMedium?.copyWith(color: scheme.onSurface),
        subtitleTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        iconColor: scheme.onSurfaceVariant,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: text.labelLarge,
          side: BorderSide(color: scheme.outline, width: 1.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 52),
          textStyle: text.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedTextStyle: text.labelLarge,
        extendedSizeConstraints: const BoxConstraints(
          minHeight: 64,
          minWidth: 64,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        labelStyle: text.bodyLarge,
        floatingLabelStyle: text.bodyLarge?.copyWith(color: scheme.primary),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          minimumSize: const Size(48, 54),
          textStyle: text.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(labelStyle: text.bodyMedium),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: text.bodyLarge?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: text.headlineSmall?.copyWith(color: scheme.onSurface),
        contentTextStyle: text.bodyLarge?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
    );
  }
}

/// The app's main areas, each with its own accent colour.
enum Feature {
  medicines(
    'Medicines',
    'Reminders & doses',
    Icons.medication_rounded,
    Color(0xFFB45309),
  ),
  appointments(
    'Appointments',
    'Doctor visits',
    Icons.event_available_rounded,
    Color(0xFF7C3AED),
  ),
  health(
    'Health tracker',
    'BP, sugar, weight, sleep',
    Icons.monitor_heart_rounded,
    Color(0xFF2563EB),
  ),
  family(
    'My family',
    'Call, text & alert',
    Icons.family_restroom_rounded,
    Color(0xFFBE185D),
  ),
  hospitals(
    'Hospitals nearby',
    'Find & get directions',
    Icons.local_hospital_rounded,
    Color(0xFF15803D),
  ),
  videoCall(
    'Video call',
    'See your family',
    Icons.video_call_rounded,
    Color(0xFF0E7490),
  ),
  documents(
    'Documents',
    'Prescriptions & reports',
    Icons.folder_copy_rounded,
    Color(0xFF8B5E34),
  ),
  notes(
    'Notes',
    'Things to remember',
    Icons.sticky_note_2_rounded,
    Color(0xFF4D7C0F),
  );

  const Feature(this.label, this.subtitle, this.icon, this.color);
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  ColorScheme scheme(Brightness b) =>
      ColorScheme.fromSeed(seedColor: color, brightness: b);
}

/// Re-themes a feature's screen around its accent colour.
class FeatureTheme extends StatelessWidget {
  const FeatureTheme({super.key, required this.feature, required this.child});
  final Feature feature;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = feature.scheme(theme.brightness);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: s.primary,
          onPrimary: s.onPrimary,
          primaryContainer: s.primaryContainer,
          onPrimaryContainer: s.onPrimaryContainer,
          secondaryContainer: s.secondaryContainer,
          onSecondaryContainer: s.onSecondaryContainer,
        ),
        floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
          backgroundColor: s.primary,
          foregroundColor: s.onPrimary,
        ),
      ),
      child: child,
    );
  }
}
