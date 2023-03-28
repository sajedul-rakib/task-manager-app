import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/data/auth_user_data.dart';
import 'package:task_manager_project/ui/screen/login_screen.dart';
import 'package:task_manager_project/ui/screen/profile_update_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';
import 'package:get/get.dart';

class UsersHeader extends StatelessWidget {
  const UsersHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? base64Image = AuthUtils.photo;
    var imageDecode = const Base64Decoder().convert(base64Image!);
    return ListTile(
      leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.memory(
              imageDecode,
              fit: BoxFit.fitWidth,
            ),
          )),
      title: Text(
        "${AuthUtils.firstName ?? ''} ${AuthUtils.lastName ?? ''}",
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18)),
      ),
      subtitle: Text(
        AuthUtils.email ?? "Unknown",
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white70)),
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
        onPressed: () {
          Future.delayed(const Duration(seconds: 2)).then((value) async {
            await AuthUtils.clearLoggedUserData();
            Get.offAll(const LogInScreen());
            showToastMessage("Log out successfully");
          });
        },
      ),
      tileColor: Colors.green.shade400,
      onTap: () {
        Get.to(const ProfileUpdateScreen());
      },
    );
  }
}
