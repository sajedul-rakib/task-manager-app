import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static String? firstName, lastName, email, mobile, photo, token;

//save user data on shared preferences
  static Future loggedUserData(
      loggedUserFirstName,
      loggedUserLastName,
      loggedUserMail,
      loggedUserMobile,
      loggedUserPhoto,
      loggedUserToken) async {
    SharedPreferences sharePreference = await SharedPreferences.getInstance();
    await sharePreference.setString("token", loggedUserToken);
    await sharePreference.setString("firstName", loggedUserFirstName);
    await sharePreference.setString("lastName", loggedUserLastName);
    await sharePreference.setString("email", loggedUserMail);
    await sharePreference.setString("mobile", loggedUserMobile);
    await sharePreference.setString("photo", loggedUserPhoto);
    token = loggedUserToken;
    firstName = loggedUserFirstName;
    lastName = loggedUserLastName;
    email = loggedUserMail;
    mobile = loggedUserMobile;
    photo = loggedUserPhoto;
  }

  //check user are logged in
  static Future<bool> isUserLogged() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userToken = sharedPreferences.getString("token");
    if (userToken == null) {
      return false;
    } else {
      return true;
    }
  }

  //Get Logged user data
  static Future<void> getLoggedUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    firstName = sharedPreferences.getString("firstName");
    lastName = sharedPreferences.getString("lastName");
    email = sharedPreferences.getString("email");
    mobile = sharedPreferences.getString("mobile");
    photo = sharedPreferences.getString("photo");
  }

  //clear logged user data
  static Future<void> clearLoggedUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
