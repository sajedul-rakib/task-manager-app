import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/widgets/app_elevated_button.dart';
import 'package:task_manager_project/ui/screen/widgets/bottom_navigation_bar.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/input_form_field.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/text_title.dart';

class CreateNewTaskScreen extends StatefulWidget {
  const CreateNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewTaskScreen> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen> {
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController subjectETController = TextEditingController();
    TextEditingController descriptionETController = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a new task",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: ScreenBackground(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleText(
                        title: 'Add New Task',
                      ),
                      InputFormField(
                        hintText: "Subject",
                        controller: subjectETController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter your task subject";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputFormField(
                        hintText: "Description",
                        controller: descriptionETController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter about your task subject";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 7,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedSubmitButton(
                          child: inProgress
                              ? customCircularProgressIndicator()
                              : const Icon(
                                  Icons.arrow_circle_right_outlined,
                                  size: 32,
                                ),
                          onTap: () async {
                            inProgress = true;
                            setState(() {});
                            if (formKey.currentState?.validate() ?? true) {
                              final result = await NetworkUtils.postMethod(
                                  Urls.createTask,
                                  body: {
                                    "title": subjectETController.text.trim(),
                                    "description":
                                        descriptionETController.text.trim(),
                                    "status": "New"
                                  });
                              if (mounted) {
                                if (result != null &&
                                    result["status"] == 'success') {
                                  subjectETController.clear();
                                  descriptionETController.clear();
                                  showToastMessage(
                                      context, "New task added successfully");

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavigation()),
                                      (route) => false);
                                } else {
                                  showToastMessage(context,
                                      "New task added failed!Try again", true);
                                }
                                inProgress = false;
                                setState(() {});
                              }
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
