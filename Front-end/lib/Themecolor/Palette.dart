import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  // Primary colors
  static const Color primaryBlue = Color(0xff4A90E2);
  static const Color primaryPurple = Color(0xff7B61FF);

  // Main theme color (used by ThemeData)
  static const Color Kmain = primaryBlue;

  // Main gradient (used for buttons, highlights)
  static const LinearGradient mainGradient = LinearGradient(
    colors: [
      primaryBlue,
      primaryPurple,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const Color Ksecondary = Color(0xFFf48668);

  /// Secondary Shades
  static const Color KmainLight1 = Color(0xff74A8E9);
  static const Color KmainLight2 = Color(0xff9FC0F0);

// Darker shades
  static const Color KmainDark1 = Color(0xff3A78C1);
  static const Color KmainDark2 = Color(0xff2B5E9E);

  // Secondary colors
  // static const Color Ksecondary = Color(0xFFf48668);
  static const Color Kwhite = Color(0xFFFDF0D5);
  static const Color Kblack = Colors.black;
  static const Color Kgrey = Colors.grey;

  // Extra UI colors (optional but useful)
  static const Color background = Color(0xFFF7F9FC);
  static const Color card = Colors.white;
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
}

class RSHRMSTheme {
  ThemeData hrapptheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: Palette.background,

    // Color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.Kmain,
      brightness: Brightness.light,
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
      backgroundColor: Palette.KmainDark1,
      foregroundColor: Colors.black,
    ),

    // Bottom bar
    // bottomAppBarTheme: BottomAppBarTheme(
    //   color: Colors.grey[100],
    // ),

    // Card theme
    cardTheme: const CardThemeData(
      color: Palette.card,
      elevation: 6,
      shadowColor: Colors.black12,
    ),

    // Text theme
    textTheme: GoogleFonts.poppinsTextTheme(
      Typography.blackCupertino,
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
  );

  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.Kmain,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 4,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
  );
}
