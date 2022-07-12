import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocitymeter/themes/fordarkmode/darkcolors.dart';
import 'package:velocitymeter/themes/forlightmode/lightcolors.dart';

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: GoogleFonts.oxygenMonoTextTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColorDark: LightColors.black,
    scaffoldBackgroundColor: LightColors.bgColorlight,
    primaryColorLight: LightColors.bgColorlight,
  );
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
///////////////////////////////////
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.oxygenMonoTextTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColorDark: DarkColors.white,
    scaffoldBackgroundColor: DarkColors.bgColorDark,
    primaryColorLight: DarkColors.bgColorDark,
  );
}
