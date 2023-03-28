import 'package:flutter/material.dart';
import 'package:task_manager_project/data/DataModel/task_data_model.dart';
import 'package:task_manager_project/data/DataModel/task_status_count_data_model.dart';
import 'package:task_manager_project/data/DataModel/task_data_count.dart';
import 'package:task_manager_project/data/network_utils.dart';
import 'package:task_manager_project/data/urls.dart';
import 'package:task_manager_project/ui/screen/widgets/delete_task_dialog.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:task_manager_project/ui/screen/widgets/single_task_component.dart';
import 'package:task_manager_project/ui/screen/widgets/status_change_bottom_sheet.dart';
import 'package:task_manager_project/ui/screen/widgets/task_status_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? newTask,
      completeTask,
      progressTask,
      cancelTask; //this is local variable for store sum of task data
  bool _inProgress = false; //this is for progress indicator
  TaskDataCount taskDataCount = TaskDataCount();
  TaskDataModel taskDataModel = TaskDataModel(); //instance of task data model
  TaskStatusCountDataModel taskStatusCountDataModel =
      TaskStatusCountDataModel();

  @override
  void initState() {
    getTaskStatusCountApi();
    getNewTask();
    TaskDataCount.getTaskStatusCountApi();
    super.initState();
  }

  //get new task from api
  Future<void> getNewTask() async {
    _inProgress = true;
    setState(() {});
    final result = await NetworkUtils.getMethod(Urls.newTaskApiUrl);

    if (result != null && result["status"] == 'success') {
      taskDataModel = TaskDataModel.fromJson(result);
    } else {
      showToastMessage("Unable to fetch new task!Try again", true);
    }
    _inProgress = false;
    setState(() {});
  }

  //get task status count from api
  Future<void> getTaskStatusCountApi() async {
    final result = await NetworkUtils.getMethod(
      Urls.taskStatusCount,
    );
    if (result != null) {
      taskStatusCountDataModel = TaskStatusCountDataModel.fromJson(result);
    }
  }

  //push sum of task data of local variable
  void pushDataOnCountVariable() async {
    taskStatusCountDataModel.data?.forEach((element) {
      if (element.sId == "New") {
        newTask = element.sum;
      } else if (element.sId == "Complete") {
        completeTask = element.sum;
      } else if (element.sId == "Progress") {
        progressTask = element.sum;
      } else if (element.sId == "Cancelled") {
        cancelTask = element.sum;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //invoke pushDataOnCountVariable for store data of local variable
    pushDataOnCountVariable();
    return ScreenBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Column(
          children: [
            Row(
              children: [
                TaskStatusContainer(
                  haveTask: newTask ?? 0,
                  taskStatus: 'New',
                ),
                TaskStatusContainer(
                  haveTask: progressTask ?? 0,
                  taskStatus: 'Progress',
                ),
                TaskStatusContainer(
                  haveTask: completeTask ?? 0,
                  taskStatus: 'Complete',
                ),
                TaskStatusContainer(
                  haveTask: cancelTask ?? 0,
                  taskStatus: 'Cancelled',
                ),
              ],
            ),
            Expanded(
              child: _inProgress
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: Colors.green,
                      ),
                    )
                  : RefreshIndicator(
                      color: Colors.green,
                      onRefresh: () async {
                        getNewTask();
                      },
                      child: ListView.builder(
                        itemCount: taskDataModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SingleTaskComponent(
                            statusColor: Colors.blueAccent,
                            statusText: 'New',
                            taskDate: taskDataModel.data?[index].createdDate ??
                                'Unknown',
                            subTitleText:
                                taskDataModel.data?[index].description ??
                                    'Unknown',
                            titleText:
                                taskDataModel.data?[index].title ?? 'Unknown',
                            onDeleteTask: () {
                              deleteTaskDialog(
                                taskDataModel.data?[index].sId ?? '',
                                getNewTask,
                                context,
                                getTaskStatusCountApi,
                              );
                            },
                            onChangeStatus: () {
                              showChageTaskStatus(
                                  context,
                                  taskDataModel.data?[index].sId ?? " ",
                                  getNewTask,
                                  getTaskStatusCountApi);
                              getTaskStatusCountApi();
                            },
                          );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
