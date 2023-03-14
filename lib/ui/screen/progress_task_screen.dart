import 'package:flutter/material.dart';
import 'package:task_manager_project/data/DataModel/task_data_model.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/widgets/delete_task_dialog.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/single_task_component.dart';
import 'package:task_manager_project/ui/screen/widgets/status_change_bottom_sheet.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({Key? key}) : super(key: key);

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _inProgress = false;
  TaskDataModel taskDataModel = TaskDataModel();

  @override
  void initState() {
    getProgressTask();
    super.initState();
  }

  Future<void> getProgressTask() async {
    _inProgress = true;
    setState(() {});
    final response = await NetworkUtils.getMethod(Urls.progressTaskApiUrl);
    if (mounted) {
      if (response != null && response['status'] == 'success') {
        taskDataModel = TaskDataModel.fromJson(response);
      } else {
        showToastMessage(context, "Unable to get complete task", true);
      }
    }
    _inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: _inProgress
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: Colors.green,
                ),
              )
            : RefreshIndicator(
                color: Colors.green,
                onRefresh: () {
                  return getProgressTask();
                },
                child: ListView.builder(
                  itemCount: taskDataModel.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      child: SingleTaskComponent(
                        statusColor: Colors.pinkAccent,
                        statusText: 'Progress',
                        taskDate:
                            taskDataModel.data?[index].createdDate ?? 'Unknown',
                        subTitleText:
                            taskDataModel.data?[index].description ?? 'Unknown',
                        titleText:
                            taskDataModel.data?[index].title ?? 'Unknown',
                        onDeleteTask: () {
                          deleteTaskDialog(taskDataModel.data?[index].sId ?? '',
                              getProgressTask, context);
                        },
                        onChangeStatus: () {
                          showChageTaskStatus(
                              context,
                              taskDataModel.data?[index].sId ?? " ",
                              getProgressTask);
                        },
                      ),
                    );
                  },
                )));
  }
}
