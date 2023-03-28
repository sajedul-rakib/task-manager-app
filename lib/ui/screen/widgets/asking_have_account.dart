import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/ui/screen/utils/text_style.dart';

class AskingHaveAccount extends StatelessWidget {
  const AskingHaveAccount({
    super.key,
    required this.questionTitle,
    required this.doThat, required this.onPress,
  });

  final String questionTitle;
  final String doThat;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(questionTitle,style: subtitleTextStyle,),
        TextButton(
            onPressed: onPress,
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            child: Text(
              doThat,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.green)),
            ))
      ],
    );
  }
}
