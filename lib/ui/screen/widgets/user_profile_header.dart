import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_project/data/auth_user_data.dart';
import 'package:task_manager_project/ui/screen/login_screen.dart';
import 'package:task_manager_project/ui/screen/profile_update_screen.dart';
import 'package:task_manager_project/ui/screen/widgets/show_toast_message.dart';

class UsersHeader extends StatelessWidget {
  const UsersHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Colors.grey,
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
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LogInScreen()),
              (route) => false);
          await AuthUtils.clearLoggedUserData();
          showToastMessage(context, "Log out successfully");
        },
      ),
      tileColor: Colors.green.shade400,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfileUpdateScreen()));
      },
    );
  }
}
