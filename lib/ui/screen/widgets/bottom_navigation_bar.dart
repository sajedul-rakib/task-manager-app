import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screen/cancel_task_screen.dart';
import 'package:task_manager_project/ui/screen/complete_task_screen.dart';
import 'package:task_manager_project/ui/screen/home_screen.dart';
import 'package:task_manager_project/ui/screen/progress_task_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/user_profile_header.dart';
import 'package:get/get.dart';
import '../create_new_task_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    super.key,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

int _currentScreen = 0;
final List<Widget> _screens = [
  const HomeScreen(),
  const CompleteTaskScreen(),
  const CancelTaskScreen(),
  const ProgressTaskScreen()
];

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.green,
          elevation: 5,
          onTap: (index) {
            // print(index);
            _currentScreen = index;
            setState(() {});
          },
          currentIndex: _currentScreen,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rounded), label: "New Task"),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_rounded), label: "Completed"),
            BottomNavigationBarItem(
                icon: Icon(Icons.close_rounded), label: "Canceled"),
            BottomNavigationBarItem(
                icon: Icon(Icons.coffee_rounded), label: "Progress"),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            Get.to(const CreateNewTaskScreen());
          },
          child: const Icon(
            Icons.add,
            size: 36,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const UsersHeader(),
              Expanded(child: _screens[_currentScreen])
            ],
          ),
        ),
      ),
    );
  }
}
