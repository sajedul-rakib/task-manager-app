import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_project/data/auth_user_data.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/splash_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/app_elevated_button.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/input_form_field.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/text_title.dart';
import 'package:get/get.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController _emailETController = TextEditingController();
  final TextEditingController _firstNameETController = TextEditingController();
  final TextEditingController _lastNameETController = TextEditingController();
  final TextEditingController _mobileETController = TextEditingController();
  final TextEditingController _passwordETController = TextEditingController();

  bool _inProgress = false;
  bool isHidePassword = true;
  bool isVisiblePassword = false;
  XFile? pickedImage;
  String? base64Image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailETController.text = AuthUtils.email ?? '';
    _firstNameETController.text = AuthUtils.firstName ?? '';
    _lastNameETController.text = AuthUtils.lastName ?? '';
    _mobileETController.text = AuthUtils.mobile ?? '';
  }

  void updateProfile() async {
    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    _inProgress = true;
    setState(() {});

    Map<String, String> body = {
      "firstName": _firstNameETController.text.trim(),
      "lastName": _lastNameETController.text.trim(),
      "mobile": _mobileETController.text.trim(),
      "photo": base64Image ?? ' '
    };

    if (_passwordETController.text.isNotEmpty) {
      body['password'] = _passwordETController.text;
    }

    final response =
        await NetworkUtils.postMethod(Urls.profileUpdate, body: body);

    if (response != null && response['status'] == 'success') {
      showToastMessage("Profile update successfully");
      await AuthUtils.clearLoggedUserData();

      Get.offAll(const SplashScreen());
    } else {
      showToastMessage("Profile update failed", true);
    }

    _inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ScreenBackground(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  const TitleText(title: "Update Profile"),
                  const SizedBox(
                    height: 8,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              imagePicker();
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      )),
                                  child: Text(
                                    'Photo',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        )),
                                    child: Text(
                                      pickedImage?.name ?? '',
                                      maxLines: 1,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InputFormField(
                            hintText: "Email",
                            controller: _emailETController,
                            readOnly: true,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InputFormField(
                            hintText: "First name",
                            controller: _firstNameETController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InputFormField(
                              hintText: "Last name",
                              controller: _lastNameETController),
                          const SizedBox(
                            height: 16,
                          ),
                          InputFormField(
                              hintText: "Mobile",
                              controller: _mobileETController),
                          const SizedBox(
                            height: 16,
                          ),
                          InputFormField(
                            hintText: "Password",
                            controller: _passwordETController,
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
                            isObscure: isHidePassword,
                            isVisiblePassword: isVisiblePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            changeShowPasswordState: () {
                              isHidePassword = !isHidePassword;
                              isVisiblePassword = !isVisiblePassword;
                              setState(() {});
                            },
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedSubmitButton(
                      child: _inProgress
                          ? customCircularProgressIndicator()
                          : const Icon(Icons.arrow_circle_right_outlined),
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? true) {
                          updateProfile();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void imagePicker() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  pickedImage =
                      await ImagePicker().pickImage(source: ImageSource.camera);

                  if (pickedImage != null) {
                    setState(() {});
                    Get.back();
                  }
                },
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
              ),
              ListTile(
                onTap: () async {
                  pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (pickedImage != null) {
                    setState(() {});
                    Get.back();
                  }
                },
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
              ),
            ],
          ));
        });
  }
}
