import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/ui/screen/utils/text_style.dart';

class SingleTaskComponent extends StatelessWidget {
  const SingleTaskComponent({
    super.key,
    required this.titleText,
    required this.subTitleText,
    required this.statusText,
    required this.statusColor,
    required this.taskDate,
    required this.onChangeStatus,
    required this.onDeleteTask,
  });

  final String titleText;
  final String subTitleText;
  final String statusText;
  final Color statusColor;
  final String taskDate;
  final VoidCallback onChangeStatus;
  final VoidCallback onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5/2,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black)),
              ),
              Text(
                subTitleText,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5)),
              ),
              Text(
                taskDate,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      statusText,
                      style: statusBarTextStyle(14.0, Colors.white),
                    ),
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Row(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          onChangeStatus();
                        },
                        icon: const Icon(Icons.edit_calendar_outlined),
                        color: Colors.green,
                      ),
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            onDeleteTask();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
