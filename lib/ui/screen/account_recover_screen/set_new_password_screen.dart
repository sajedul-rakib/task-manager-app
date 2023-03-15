import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/login_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/app_elevated_button.dart';
import 'package:task_manager_project/ui/screen/widgets/asking_have_account.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/input_form_field.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/subtitle_text.dart';
import 'package:task_manager_project/ui/screen/widgets/text_title.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({Key? key, required this.email, required this.otp})
      : super(key: key);
  final String email, otp;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool _inProgress = false;
  TextEditingController setPassETController = TextEditingController();
  TextEditingController confirmPassETController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(title: "Set Password"),
                  const SubtitleText(
                      subtitleTextTitle:
                          "Minimum password length 8 character with Letter and Number combination"),
                  const SizedBox(
                    height: 24,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputFormField(
                            hintText: "New Password",
                            controller: setPassETController,
                            isObscure: true,
                            validator: (String? value) {
                              if (value?.isEmpty ?? true) {
                                return "Enter a unique password";
                              } else {
                                if (value != null &&
                                    !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                        .hasMatch(value)) {
                                  return "Enter password at least 8 characters with mix up \nCapital letter,normal letter and aslo special character";
                                } else {
                                  null;
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InputFormField(
                            hintText: "Confirm Password",
                            controller: confirmPassETController,
                            validator: (String? value) {
                              if ((value?.isEmpty ?? true) ||
                                  (value ?? '') != setPassETController.text) {
                                return "Password mismatch";
                              } else {
                                return null;
                              }
                            },
                            isObscure: true,
                          ),
                        ],
                      )),
                  const SizedBox(height: 16),
                  ElevatedSubmitButton(
                      child: _inProgress
                          ? customCircularProgressIndicator()
                          : Text(
                              "Confirm",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ),
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? true) {
                          _inProgress = true;
                          setState(() {});
                          final response = await NetworkUtils.postMethod(
                              Urls.resetPassword,
                              body: {
                                "email": widget.email,
                                "OTP": widget.otp,
                                "password": confirmPassETController.text
                              });
                          if (mounted) {
                            if (response != null &&
                                response['status'] == 'success') {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LogInScreen()),
                                  (route) => false);
                              showToastMessage(
                                  context, "Reset password successfully");
                            } else {
                              showToastMessage(
                                  context, "Reset password failed", true);
                            }
                          }
                          _inProgress = false;
                          setState(() {});
                        }
                      }),
                  const SizedBox(
                    height: 40,
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
      ),
    );
  }
}
