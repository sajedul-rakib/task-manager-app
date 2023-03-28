import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/data/auth_user_data.dart';
import 'package:task_manager_project/ui/screen/login_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/bottom_navigation_bar.dart';
import 'package:task_manager_project/ui/screen/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  //init state
  void initState() {
    Future.delayed(const Duration(seconds: 2))
        .then((value) => checkUserAreLogged());
    super.initState();
  }

  //check user are logged
  void checkUserAreLogged() async {
    AuthUtils.getLoggedUserData();
    final isUserLogged = await AuthUtils.isUserLogged();

    if (isUserLogged) {
      Get.offAll(const BottomNavigation());
    } else {
      Get.offAll(const LogInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: Center(
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              width: 160,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }
}
