import 'package:flutter/material.dart';
import 'package:task_manager_project/data/DataModel/task_data_model.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/widgets/delete_task_dialog.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/single_task_component.dart';
import 'package:task_manager_project/ui/screen/widgets/status_change_bottom_sheet.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({Key? key}) : super(key: key);

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _inProgress = false;
  TaskDataModel taskDataModel = TaskDataModel();

  @override
  void initState() {
    getCompleteTask();
    super.initState();
  }

  Future<void> getCompleteTask() async {
    _inProgress = true;
    setState(() {});
    final response = await NetworkUtils.getMethod(Urls.completeTaskApiUrl);

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
                  return getCompleteTask();
                },
                child: ListView.builder(
                  itemCount: taskDataModel.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      child: SingleTaskComponent(
                        statusColor: Colors.green,
                        statusText: 'Complete',
                        taskDate:
                            taskDataModel.data?[index].createdDate ?? 'Unknown',
                        subTitleText:
                            taskDataModel.data?[index].description ?? 'Unknown',
                        titleText:
                            taskDataModel.data?[index].title ?? 'Unknown',
                        onDeleteTask: () {
                          deleteTaskDialog(taskDataModel.data?[index].sId ?? '',
                              getCompleteTask, context);
                        },
                        onChangeStatus: () {
                          showChageTaskStatus(
                              context,
                              taskDataModel.data?[index].sId ?? " ",
                              getCompleteTask);
                        },
                      ),
                    );
                  },
                )));
  }
}
