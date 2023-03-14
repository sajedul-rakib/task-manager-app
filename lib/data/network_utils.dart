import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:task_manager_project/data/auth_user_data.dart';

class NetworkUtils {
  //Get request operation
  static Future<dynamic> getMethod(
    String url,
  ) async {
    final http.Response response = await http.get(
        Uri.parse(
          url,
        ),
        headers: {"token": AuthUtils.token ?? ""});
    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        log("Unauthorized");
      } else {
        log("Something went wrong");
      }
    } catch (e) {
      log("error $e");
    }
  }

  //Post request operation handle

  static Future<dynamic> postMethod(String url,
      {Map<String, String>? body}) async {
    http.Response response = await http.post(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "token": AuthUtils.token ?? ''
        },
        body: jsonEncode(body));

    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        log("Unauthorized");
      } else {
        log("Something went wrong");
      }
    } catch (e) {
      log("error $e");
    }
  }
}
