import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';

import '../../../data/network_utils.dart';
import '../../../data/urls.dart';

deleteTaskDialog(String id, VoidCallback cb, context,[VoidCallback? rf]) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Do you want to delete task?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    final response =
                        await NetworkUtils.getMethod(Urls.deleteTask(id));
                    if (response != null && response['status']=='success') {
                      showToastMessage(context, "Delete Task Successfully");
                    } else {
                      showToastMessage(context, "Unable to delete task");
                    }
                    Navigator.pop(context);
                    cb();
                    rf!();
                  },
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: GoogleFonts.poppins(
                        textStyle:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        fontWeight: FontWeight.w600),
                  )),
            ],
          ));
}
