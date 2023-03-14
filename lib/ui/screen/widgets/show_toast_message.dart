import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showToastMessage(BuildContext context, String msg, [bool isError = false]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: GoogleFonts.poppins(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          color: Colors.white),
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
    duration: const Duration(seconds: 1),
  ));
}
