import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle textStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
        fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black));

final TextStyle subtitleTextStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
  fontWeight: FontWeight.w600,
  letterSpacing: .5,
  fontSize: 14,
  color: Colors.grey,
));

TextStyle statusBarTextStyle(fontSize, fontColor) {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: fontSize, color: fontColor, fontWeight: FontWeight.w600));
}
