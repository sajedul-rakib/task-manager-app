import 'package:flutter/material.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/login_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/app_elevated_button.dart';
import 'package:task_manager_project/ui/screen/widgets/asking_have_account.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/input_form_field.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/text_title.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailETController = TextEditingController();
  TextEditingController firstNameETController = TextEditingController();
  TextEditingController lastNameETController = TextEditingController();
  TextEditingController mobileETController = TextEditingController();
  TextEditingController passwordETController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  Future<void> signIn() async {
    _inProgress = true;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      final result = await NetworkUtils.postMethod(Urls.registration, body: {
        "email": emailETController.text.trim(),
        "firstName": firstNameETController.text.trim(),
        "lastName": lastNameETController.text.trim(),
        "mobile": mobileETController.text.trim(),
        "password": passwordETController.text
      });
      if (mounted) {
        if (result != null && result['status'] == 'success') {
          showToastMessage(
            context,
            "Registration successfully",
          );
          emailETController.clear();
          firstNameETController.clear();
          lastNameETController.clear();
          mobileETController.clear();
          passwordETController.clear();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LogInScreen()));
          _inProgress = false;
          setState(() {});
        } else {
          showToastMessage(context, "Registration failed!Try Again", true);
          _inProgress = false;
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                      title: 'Join with Us',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFormField(
                      hintText: "Email",
                      controller: emailETController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter your validate email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFormField(
                      hintText: "First Name",
                      controller: firstNameETController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter your validate email";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFormField(
                      hintText: "Last Name",
                      controller: lastNameETController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter your last name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFormField(
                      hintText: "Mobile",
                      controller: mobileETController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter your phone number";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFormField(
                      hintText: "Password",
                      controller: passwordETController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter a unique password";
                        } else {
                          return null;
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
                                size: 24,
                              ),
                        onTap: () async {
                          signIn();
                        }),
                    const SizedBox(
                      height: 12,
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
      ),
    );
  }
}
