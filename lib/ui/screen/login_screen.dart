import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/data/auth_user_data.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/account_recover_screen/account_recover_by_mail_screen.dart';
import 'package:task_manager_project/ui/screen/signup_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/app_elevated_button.dart';
import 'package:task_manager_project/ui/screen/widgets/asking_have_account.dart';
import 'package:task_manager_project/ui/screen/widgets/bottom_navigation_bar.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/input_form_field.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/text_title.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LogInScreen> {
  TextEditingController emailETController = TextEditingController();
  TextEditingController passwordETController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  Future<void> logIn() async {
    _inProgress = true;
    setState(() {});
    if (_formKey.currentState?.validate() ?? false) {
      final result = await NetworkUtils.postMethod(Urls.login, body: {
        "email": emailETController.text.trim(),
        "password": passwordETController.text
      });

      if (result != null && result['status'] == 'success') {
        emailETController.clear();
        passwordETController.clear();
        //save user data on shared_preferences
        await AuthUtils.loggedUserData(
            result["data"]["firstName"],
            result["data"]["lastName"],
            result["data"]["email"],
            result["data"]["mobile"],
            result["data"]["photo"],
            result["token"]);
        if (mounted) {
          //success toast  message
          showToastMessage(context, "Log in successfully");
          //Navigate to MainBottomNavigation
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigation()),
              (route) => false);
        }
        _inProgress = false;
        setState(() {});
      } else {
        if (mounted) {
          showToastMessage(context, "Enter your valid email & password", true);
        }
      }
      _inProgress = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
            child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(
                  title: "Get Start With",
                ),
                const SizedBox(
                  height: 8.0,
                ),
                InputFormField(
                    hintText: "Email",
                    controller: emailETController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your email";
                      } else {
                        if (value != null && EmailValidator.validate(value)) {
                          null;
                        } else {
                          return "Enter your valid email";
                        }
                      }
                    }),
                const SizedBox(
                  height: 16.0,
                ),
                InputFormField(
                  hintText: "Password",
                  controller: passwordETController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Enter your password";
                    }
                  },
                  isObscure: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedSubmitButton(
                    child: _inProgress
                        ? customCircularProgressIndicator()
                        : const Icon(
                            Icons.arrow_circle_right_outlined,
                            size: 32,
                          ),
                    onTap: () async {
                      logIn();
                    }),
                const SizedBox(
                  height: 32,
                ),
                Center(
                    child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AccountRecoverByMail()));
                        },
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600)),
                        )),
                    AskingHaveAccount(
                        questionTitle: 'Don\'t have account?',
                        doThat: 'Sign Up',
                        callback: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        })
                  ],
                )),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
