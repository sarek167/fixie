class EndpointConstants {
  static const String clusterIP = "10.96.0.1";
  static const String userManagementPort = "31293";
  static const String taskManagementPort = "31414";
  static const String loginEndpoint =
      "http://$clusterIP:$userManagementPort/user_management/login/";
  static const String registerEndpoint =
      "http://$clusterIP:$userManagementPort/user_management/register/";
  static const String logoutEndpoint =
      "http://$clusterIP:$userManagementPort/user_management/logout/";
  static const String refreshTokenEndpoint =
      "http://$clusterIP:$userManagementPort/user_management/token_refresh/";
  static const String getUserPathsEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/get_user_paths/";
  static const String getPopularPathsEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/get_popular_paths/";
  static const String getPathByTitleEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/get_path_by_title";
  static const String postTaskAnswerEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/post_task_answer/";
  static const String postAssignPathEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/post_assign_path/";
  static const String getStreakEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/get_streak/";
  static const String getDailyTasksEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/get_daily_tasks/";
  static const String getDailyTasksStatusEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/get_daily_tasks_status/";
  static const String getDailyTaskByDateEndpoint =
      "http://$clusterIP:$taskManagementPort/task_management/post_daily_tasks/";

  static const String baseUserEndpoint =
      "http://$clusterIP:$userManagementPort/user_management/";

  static const String refreshTokenSuffix = "token_refresh/";
}
