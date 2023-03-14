class Urls {
  static String baseUrl = 'https://task.teamrabbil.com/api/v1';
  static String registration = '$baseUrl/registration';
  static String login = '$baseUrl/login';
  static String createTask = '$baseUrl/createTask';
  static String newTaskApiUrl = '$baseUrl/listTaskByStatus/New';
  static String completeTaskApiUrl = '$baseUrl/listTaskByStatus/Complete';
  static String progressTaskApiUrl = '$baseUrl/listTaskByStatus/Progress';
  static String cancelledTaskApiUrl = '$baseUrl/listTaskByStatus/Cancelled';
  static String taskStatusCount = '$baseUrl/taskStatusCount';
  static String resetPassword = '$baseUrl/RecoverResetPass';
  static String profileUpdate = '$baseUrl/profileUpdate';

  static String deleteTask(id) => '$baseUrl/deleteTask/$id';

  static String changeStatus(String taskId, String status) =>
      "$baseUrl/updateTaskStatus/$taskId/$status";

  static recoverAccountByEmail(String email) =>
      '$baseUrl/RecoverVerifyEmail/$email';

  static String recoverOptVerifyUrl(String email, String otp) {
    return '$baseUrl/RecoverVerifyOTP/$email/$otp';
  }
}
