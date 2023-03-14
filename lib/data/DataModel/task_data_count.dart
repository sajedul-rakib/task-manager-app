import 'dart:math';

import '../network_utils.dart';
import '../urls.dart';
import 'task_status_count_data_model.dart';

class TaskDataCount {
  static int? newTask, completeTask, progressTask, cancelTask;
  static TaskStatusCountDataModel taskStatusCountDataModel =
      TaskStatusCountDataModel();

  static Future<void> getTaskStatusCountApi() async {
    final result = await NetworkUtils.getMethod(
      Urls.taskStatusCount,
    );
    if (result != null) {
      taskStatusCountDataModel = TaskStatusCountDataModel.fromJson(result);
    }
  }

  TaskDataCount() { {
    taskStatusCountDataModel.data?.forEach((element) {
      if (element.sId == "New") {
        newTask = element.sum;
      } else if (element.sId == 'Complete') {
        completeTask = element.sum;
      } else if (element.sId == 'Pogress') {
        progressTask = element.sum;
      } else if (element.sId == 'Cancelled') {
        cancelTask = element.sum;
      }
    });
    print(taskStatusCountDataModel.data);
    print(completeTask);
    print(newTask);
    print(progressTask);
    print(cancelTask);
  }
}
