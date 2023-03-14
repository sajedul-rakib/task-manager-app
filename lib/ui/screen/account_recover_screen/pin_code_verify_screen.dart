import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/account_recover_screen/set_new_password_screen.dart';
import 'package:task_manager_project/ui/screen/login_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/app_elevated_button.dart';
import 'package:task_manager_project/ui/screen/widgets/asking_have_account.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/subtitle_text.dart';
import 'package:task_manager_project/ui/screen/widgets/text_title.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({Key? key, required this.email})
      : super(key: key);

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  bool _inProgress = false;
  TextEditingController pinFormETController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(title: "Pin Verification"),
                const SubtitleText(
                    subtitleTextTitle:
                        "A 6 digit verification code will send to your email address"),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formKey,
                  child: PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      activeColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedColor: Colors.green,
                      selectedFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.grey.shade400,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: pinFormETController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter 6 digit verification code that's are already send on your email";
                      } else {
                        return null;
                      }
                    },
                    onCompleted: (v) {
                      log("Completed");
                    },
                    onChanged: (value) {},
                    appContext: context,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedSubmitButton(
                    child: _inProgress
                        ? customCircularProgressIndicator()
                        : Text(
                            "Verify",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                    onTap: () async {
                      if (_formKey.currentState?.validate() ?? true) {
                        _inProgress = true;
                        setState(() {});
                        final response = await NetworkUtils.getMethod(
                            Urls.recoverOptVerifyUrl(
                                widget.email, pinFormETController.text));
                        if (mounted) {
                          if (response != null &&
                              response['status'] == 'success') {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetNewPasswordScreen(
                                          email: widget.email,
                                          otp: pinFormETController.text,
                                        )),
                                (route) => false);
                          }
                          _inProgress = false;
                          setState(() {});
                        }
                      }
                    }),
                const SizedBox(
                  height: 16,
                ),
                AskingHaveAccount(
                    questionTitle: "Have account?",
                    doThat: "Sign In",
                    callback: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()),
                          (route) => false);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
