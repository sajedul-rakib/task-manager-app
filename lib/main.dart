import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screen/splash_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const TaskManager());
}

class TaskManager extends StatefulWidget {
  const TaskManager({Key? key}) : super(key: key);

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
