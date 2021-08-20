import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static String appName = 'Carnet de Vacunación - BO';

  static Color lightPrimary = Color(0xfff3eff5);
  static Color lightAccent = Color(0xff72b01d);
  static Color lightBackground = Color(0xfff3eff5);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xff72b01d);
  static Color darkBackground = Colors.black;

  static Color grey = Color(0xff454955);
  static Color textPrimary = Color(0xFF93DD2C);
  static Color textDark = Color(0xFF0D0A0B);

  static Color backgroundColor = Color(0xfff3eff5);

  static Color darkGreen = Color(0xFF3F7D20);
  static Color lightGreen = Color(0xFF72B01D);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      accentColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
      ),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 30.0;
}
