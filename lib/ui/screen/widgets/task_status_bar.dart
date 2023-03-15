import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screen/utils/text_style.dart';

class TaskStatusContainer extends StatelessWidget {
  const TaskStatusContainer({
    super.key,
    required this.haveTask,
    required this.taskStatus,
  });

  final int haveTask;
  final String taskStatus;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    haveTask < 10
                        ? '0${haveTask.toString()}'
                        : haveTask.toString(),
                    style: statusBarTextStyle(20.0, Colors.black)),
                Text(taskStatus, style: statusBarTextStyle(12.0, Colors.black38))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
