class EndpointConstants {
  static const String base = "72.144.98.53.nip.io";
  // static const String clusterIP = "10.0.2.2";
  // static const String userManagementPort = "8000";
  // static const String taskManagementPort = "8001";
  // static const String avatarManagementPort = "8002";
  static const String loginEndpoint =
      "http://$base/user_management/login/";
  static const String registerEndpoint =
      "http://$base/user_management/register/";
  static const String logoutEndpoint =
      "http://$base/user_management/logout/";
  static const String refreshTokenEndpoint =
      "http://$base/user_management/token_refresh/";
  static const String patchUserDataEndpoint =
      "http://$base/user_management/change_user_data/";
  static const String getUserPathsEndpoint =
      "http://$base/task_management/get_user_paths/";
  static const String getPopularPathsEndpoint =
      "http://$base/task_management/get_popular_paths/";
  static const String getPathByTitleEndpoint =
      "http://$base/task_management/get_path_by_title";
  static const String postTaskAnswerEndpoint =
      "http://$base/task_management/post_task_answer/";
  static const String postAssignPathEndpoint =
      "http://$base/task_management/post_assign_path/";
  static const String getStreakEndpoint =
      "http://$base/task_management/get_streak/";
  static const String getDailyTasksEndpoint =
      "http://$base/task_management/get_daily_tasks/";
  static const String getDailyTasksStatusEndpoint =
      "http://$base/task_management/get_daily_tasks_status/";
  static const String getDailyTaskByDateEndpoint =
      "http://$base/task_management/post_daily_tasks/";

  static const String getUserAvatarOptionsEndpoint =
      "http://$base/avatar_management/get_user_avatar_elem/";
  static const String getAvatarStateEndpoint =
      "http://$base/avatar_management/get_avatar_state/";
  static const String putAvatarStateEndpoint =
      "http://$base/avatar_management/put_avatar_state/";

  static const String baseUserEndpoint =
      "http://$base/user_management/";

  static const String refreshTokenSuffix = "token_refresh/";

  static const String wsNotificationsBase = "ws://72.144.98.53.nip.io/ws/notifications/";

}
