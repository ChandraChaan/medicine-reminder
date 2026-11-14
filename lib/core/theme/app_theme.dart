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

/// The colours of an old push-button home phone: ivory plastic body, cream
/// keys with a darker lower edge, a green-black display, a deep green talk
/// key and a red help key.
@immutable
class PhoneColors extends ThemeExtension<PhoneColors> {
  const PhoneColors({
    required this.body,
    required this.bodyShade,
    required this.onBody,
    required this.onBodyMuted,
    required this.key,
    required this.keyEdge,
    required this.onKey,
    required this.display,
    required this.displayEdge,
    required this.onDisplay,
    required this.onDisplayMuted,
    required this.talk,
    required this.talkEdge,
    required this.onTalk,
    required this.listening,
    required this.help,
    required this.helpEdge,
    required this.onHelp,
  });

  final Color body;
  final Color bodyShade;
  final Color onBody;
  final Color onBodyMuted;
  final Color key;
  final Color keyEdge;
  final Color onKey;
  final Color display;
  final Color displayEdge;
  final Color onDisplay;
  final Color onDisplayMuted;
  final Color talk;
  final Color talkEdge;
  final Color onTalk;
  final Color listening;
  final Color help;
  final Color helpEdge;
  final Color onHelp;

  static PhoneColors of(BuildContext context) =>
      Theme.of(context).extension<PhoneColors>()!;

  @override
  PhoneColors copyWith() => this;

  @override
  PhoneColors lerp(PhoneColors? other, double t) => other ?? this;
}

const _phone = PhoneColors(
  body: Color(0xFFEAE0C8),
  bodyShade: Color(0xFFD6C9AA),
  onBody: Color(0xFF241E14),
  onBodyMuted: Color(0xFF574C38),
  key: Color(0xFFFBF8F0),
  keyEdge: Color(0xFFB4A584),
  onKey: Color(0xFF1F1A12),
  display: Color(0xFF1F2B25),
  displayEdge: Color(0xFF0E1511),
  onDisplay: Color(0xFFDDF2CF),
  onDisplayMuted: Color(0xFFA9C29C),
  talk: Color(0xFF2E5B4E),
  talkEdge: Color(0xFF173329),
  onTalk: Color(0xFFFFFFFF),
  listening: Color(0xFFE59A2F),
  help: Color(0xFFB0261C),
  helpEdge: Color(0xFF6E1610),
  onHelp: Color(0xFFFFFFFF),
);

/// High-contrast light theme with large type, made for older eyes, in the
/// colours of the push-button phone ([PhoneColors]).
ThemeData buildAppTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2E5B4E),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFCFE6DC),
    onPrimaryContainer: Color(0xFF0B231B),
    secondary: Color(0xFF6B5418),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFF3E3B5),
    onSecondaryContainer: Color(0xFF261A00),
    error: Color(0xFFB0261C),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD5),
    onErrorContainer: Color(0xFF410001),
    surface: Color(0xFFEAE0C8),
    onSurface: Color(0xFF241E14),
    onSurfaceVariant: Color(0xFF574C38),
    surfaceContainerLowest: Color(0xFFFBF8F0),
    surfaceContainerLow: Color(0xFFF3ECDC),
    surfaceContainer: Color(0xFFEDE5D2),
    surfaceContainerHigh: Color(0xFFE2D7BC),
    surfaceContainerHighest: Color(0xFFD6C9AA),
    outline: Color(0xFF7F7259),
    outlineVariant: Color(0xFFC9BB98),
  );
  const status = StatusColors(
    taken: Color(0xFF1B6B2F),
    onTaken: Colors.white,
    missed: Color(0xFFB0261C),
    onMissed: Colors.white,
    snooze: Color(0xFFFFC94D),
    onSnooze: Color(0xFF1F1500),
    due: Color(0xFF2E5B4E),
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
    extensions: const [status, _phone],
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      extendedTextStyle: text.titleMedium,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _phone.display,
      contentTextStyle: text.bodyLarge?.copyWith(color: _phone.onDisplay),
    ),
  );
}
