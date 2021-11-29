import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextTheme mTextTheme = TextTheme(
  headline1: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF000000),
  ),
  headline3: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF000000),
  ),
  subtitle1: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF000000),
  ),
  subtitle2: GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF000000),
  ),
  bodyText1: GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF000000),
  ),
  bodyText2: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.black,
  ),
);

final ElevatedButtonThemeData mElevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(StadiumBorder()),
    backgroundColor: MaterialStateProperty.all(
      Color(0xFF9DB6CB),
    ),
    textStyle: MaterialStateProperty.all(
      GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: 15),
    ),
  ),
);
