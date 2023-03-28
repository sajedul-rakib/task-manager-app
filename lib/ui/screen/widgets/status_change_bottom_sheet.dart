import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/ui/screen/widgets/custom_progress_indicator.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';

import '../../../data/network_utils.dart';
import '../../../data/urls.dart';
import 'app_elevated_button.dart';

showChageTaskStatus(context, String taskId, VoidCallback cb,
    [VoidCallback? rf]) {
  bool _inProgress = false;

  String groupTaskValue = "New";
  showBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, changeState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Mark as: ",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: Colors.grey)),
                  ),
                ),
                RadioListTile(
                    activeColor: Colors.green,
                    value: 'New',
                    groupValue: groupTaskValue,
                    title: Text(
                      "New",
                      style: GoogleFonts.poppins(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (state) {
                      groupTaskValue = state!;
                      changeState(() {});
                    }),
                RadioListTile(
                    activeColor: Colors.green,
                    value: 'Complete',
                    groupValue: groupTaskValue,
                    title: Text(
                      "Complete",
                      style: GoogleFonts.poppins(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (state) {
                      groupTaskValue = state!;
                      changeState(() {});
                    }),
                RadioListTile(
                    activeColor: Colors.green,
                    value: 'Progress',
                    groupValue: groupTaskValue,
                    title: Text(
                      "Progress",
                      style: GoogleFonts.poppins(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (state) {
                      groupTaskValue = state!;
                      changeState(() {});
                    }),
                RadioListTile(
                    activeColor: Colors.green,
                    value: 'Cancelled',
                    groupValue: groupTaskValue,
                    title: Text(
                      "Cancelled",
                      style: GoogleFonts.poppins(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (state) {
                      groupTaskValue = state!;
                      changeState(() {});
                    }),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedSubmitButton(
                      child: _inProgress
                          ? customCircularProgressIndicator()
                          : const Text("Change Status"),
                      onTap: () async {
                        _inProgress = true;
                        final response = await NetworkUtils.getMethod(
                            Urls.changeStatus(taskId, groupTaskValue));
                        if (response != null &&
                            response['status'] == 'success') {
                          showToastMessage(
                             "Change status successfully");
                          Navigator.pop(context);
                          cb();
                          rf!();
                        } else {
                          showToastMessage( "Unable to change status");
                        }
                        _inProgress = false;
                      }),
                )
              ],
            );
          },
        );
      });
}
