import 'package:flutter/material.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/account_recover_screen/pin_code_verify_screen.dart';
import 'package:task_manager_project/ui/screen/login_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/app_elevated_button.dart';
import 'package:task_manager_project/ui/screen/widgets/asking_have_account.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/input_form_field.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/text_title.dart';

import '../widgets/subtitle_text.dart';

class AccountRecoverByMail extends StatefulWidget {
  const AccountRecoverByMail({Key? key}) : super(key: key);

  @override
  State<AccountRecoverByMail> createState() => _AccountRecoverByMailState();
}

class _AccountRecoverByMailState extends State<AccountRecoverByMail> {
  bool _inProgress = false;
  TextEditingController emailETController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(title: "Your Email Address"),
                const SubtitleText(
                  subtitleTextTitle:
                      'A 6 digit verification pin will send to your email address',
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formKey,
                  child: InputFormField(
                    hintText: "Email",
                    controller: emailETController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your valid mail that use to when you created your account";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedSubmitButton(
                    child: _inProgress
                        ? customCircularProgressIndicator()
                        : const Icon(
                            Icons.arrow_circle_right_outlined,
                            size: 24,
                          ),
                    onTap: () async {
                      if (_formKey.currentState?.validate() ?? true) {
                        _inProgress = true;
                        setState(() {});
                        final response = await NetworkUtils.getMethod(
                            Urls.recoverAccountByEmail(
                                emailETController.text.trim()));

                        if (mounted) {
                          if (response != null &&
                              response['status'] == 'success') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PinVerificationScreen(
                                        email: emailETController.text.trim(),
                                      )),
                            );
                          }

                          _inProgress = false;
                          setState(() {});
                        }
                      }
                    }),
                const SizedBox(
                  height: 24,
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
