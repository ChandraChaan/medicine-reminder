import 'package:flutter/material.dart';

/// Colours for dose states. Always shown together with an icon and words,
/// never by colour alone.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.taken,
    required this.onTaken,
    required this.missed,
    required this.onMissed,
    required this.snooze,
    required this.onSnooze,
    required this.due,
    required this.onDue,
  });

  final Color taken;
  final Color onTaken;
  final Color missed;
  final Color onMissed;
  final Color snooze;
  final Color onSnooze;
  final Color due;
  final Color onDue;

  static StatusColors of(BuildContext context) =>
      Theme.of(context).extension<StatusColors>()!;

  @override
  StatusColors copyWith() => this;

  @override
  StatusColors lerp(StatusColors? other, double t) => other ?? this;
}

/// High-contrast light theme with large type, made for older eyes.
ThemeData buildAppTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0B5563),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD3EEF2),
    onPrimaryContainer: Color(0xFF032A31),
    secondary: Color(0xFF6A3E00),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFE2BF),
    onSecondaryContainer: Color(0xFF2A1700),
    error: Color(0xFFA4161A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFFFCF7),
    onSurface: Color(0xFF15181A),
    onSurfaceVariant: Color(0xFF3B4246),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8F4EE),
    surfaceContainer: Color(0xFFF2EEE8),
    surfaceContainerHigh: Color(0xFFECE8E2),
    surfaceContainerHighest: Color(0xFFE6E2DC),
    outline: Color(0xFF5C6468),
    outlineVariant: Color(0xFFB9C0C3),
  );
  const status = StatusColors(
    taken: Color(0xFF1B6B2F),
    onTaken: Colors.white,
    missed: Color(0xFFA4161A),
    onMissed: Colors.white,
    snooze: Color(0xFFFFC94D),
    onSnooze: Color(0xFF1F1500),
    due: Color(0xFF0B5563),
    onDue: Colors.white,
  );
  final base = ThemeData(colorScheme: scheme, useMaterial3: true);
  final text = base.textTheme
      .copyWith(
        displaySmall: base.textTheme.displaySmall?.copyWith(
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 20),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 18),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      )
      .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
  const buttonSize = Size(64, 60);
  const buttonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  return base.copyWith(
    textTheme: text,
    scaffoldBackgroundColor: scheme.surface,
    extensions: const [status],
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      titleTextStyle: text.headlineSmall,
      toolbarHeight: 68,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: buttonSize,
        padding: buttonPadding,
        textStyle: text.titleLarge,
        shape: buttonShape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: buttonSize,
        padding: buttonPadding,
        textStyle: text.titleMedium,
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: scheme.outline, width: 2),
        shape: buttonShape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        textStyle: text.titleMedium,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLowest,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant, width: 1.5),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: text.titleMedium,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding: const EdgeInsets.all(18),
      labelStyle: text.titleMedium,
      hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: text.titleMedium,
      subtitleTextStyle: text.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
      minVerticalPadding: 12,
    ),
    switchTheme: const SwitchThemeData(
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
  );
}
