import 'package:flutter/material.dart';
import 'package:task_manager_project/data/DataModel/task_data_model.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/widgets/delete_task_dialog.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/single_task_component.dart';
import 'package:task_manager_project/ui/screen/widgets/status_change_bottom_sheet.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({Key? key}) : super(key: key);

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  bool _inProgress = false;
  TaskDataModel taskDataModel = TaskDataModel();

  @override
  void initState() {
    getCancelTask();
    super.initState();
  }

  Future<void> getCancelTask() async {
    _inProgress = true;
    setState(() {});
    final response = await NetworkUtils.getMethod(Urls.cancelledTaskApiUrl);

    if (response != null && response['status'] == 'success') {
      taskDataModel = TaskDataModel.fromJson(response);
    } else {
      showToastMessage("Unable to get complete task", true);
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
                  return getCancelTask();
                },
                child: ListView.builder(
                  itemCount: taskDataModel.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      child: SingleTaskComponent(
                        statusColor: Colors.red,
                        statusText: 'Cancel',
                        taskDate:
                            taskDataModel.data?[index].createdDate ?? 'Unknown',
                        subTitleText:
                            taskDataModel.data?[index].description ?? 'Unknown',
                        titleText:
                            taskDataModel.data?[index].title ?? 'Unknown',
                        onDeleteTask: () {
                          deleteTaskDialog(taskDataModel.data?[index].sId ?? '',
                              getCancelTask, context);
                        },
                        onChangeStatus: () {
                          showChageTaskStatus(
                              context,
                              taskDataModel.data?[index].sId ?? " ",
                              getCancelTask);
                        },
                      ),
                    );
                  },
                )));
  }
}
