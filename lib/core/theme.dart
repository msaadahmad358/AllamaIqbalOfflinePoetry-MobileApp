import 'package:flutter/material.dart';

class BookTone {
  final Color bg;
  final Color fg;
  const BookTone(this.bg, this.fg);
  bool get hasLightText => fg.computeLuminance() > 0.6;
}

class AppTheme {
  static const background = Color(0xFFF5F5F2);
  static const surface = Color(0xFFFFFFFF);

  static const ink = Color(0xFF14181F);
  static const onInk = Color(0xFFFFFFFF);

  static const border = Color(0xFFE4E4DF);
  static const divider = Color(0xFFEBEBE6);

  static const textPrimary = ink;
  static const textSecondary = Color(0xFF59616C);
  static const textMuted = Color(0xFF959CA6);

  static const accent = Color(0xFF2F5BD3);
  static const onAccent = Color(0xFFFFFFFF);

  static const urduFont = 'JameelNoori';

  static const tones = [
    BookTone(Color(0xFF2F5BD3), Colors.white), // lapis
    BookTone(Color(0xFF1F8F6F), Colors.white), // emerald
    BookTone(Color(0xFFF2B33D), ink), // saffron
    BookTone(Color(0xFFD1466B), Colors.white), // rose
    BookTone(Color(0xFF7B4BB5), Colors.white), // amethyst
    BookTone(Color(0xFF138A9A), Colors.white), // teal
    BookTone(Color(0xFFF0683F), Colors.white), // coral
    BookTone(Color(0xFF3A3F9E), Colors.white), // indigo
    BookTone(Color(0xFF6E8B3D), Colors.white), // moss
    BookTone(Color(0xFF58AEE6), ink), // sky
    BookTone(Color(0xFF2B2F3A), Colors.white), // graphite
  ];

  static BookTone toneFor(String key, [int fallback = 0]) {
    final m = RegExp(r'\d+').firstMatch(key);
    final n = m != null ? int.parse(m.group(0)!) - 1 : fallback;
    return tones[n.abs() % tones.length];
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      splashColor: accent.withOpacity(0.06),
      highlightColor: accent.withOpacity(0.04),
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.light,
        primary: accent,
        onPrimary: onAccent,
        surface: surface,
        onSurface: textPrimary,
      ),
      dividerTheme:
          const DividerThemeData(color: divider, thickness: 1, space: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: Colors.transparent,
        strokeWidth: 2,
      ),
      sliderTheme: const SliderThemeData(
        trackHeight: 3,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accent.withOpacity(0.2),
        selectionHandleColor: accent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: const TextStyle(color: onInk, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class AppText {
  static TextStyle urdu(double size,
          {Color color = AppTheme.textPrimary, double height = 1.9}) =>
      TextStyle(
        fontFamily: AppTheme.urduFont,
        fontSize: size,
        height: height,
        color: color,
      );

  static TextStyle sans(double size,
          {Color color = AppTheme.textSecondary,
          FontWeight weight = FontWeight.w400,
          double spacing = 0.1,
          double height = 1.4}) =>
      TextStyle(
        fontSize: size,
        color: color,
        fontWeight: weight,
        letterSpacing: spacing,
        height: height,
      );

  static TextStyle serif(double size,
          {Color color = AppTheme.textPrimary,
          FontWeight weight = FontWeight.w400,
          FontStyle style = FontStyle.normal,
          double height = 1.5}) =>
      TextStyle(
        fontFamily: 'serif',
        fontSize: size,
        color: color,
        fontWeight: weight,
        fontStyle: style,
        height: height,
      );
}
