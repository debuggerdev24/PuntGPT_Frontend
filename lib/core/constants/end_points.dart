class EndPoints {
  EndPoints._();

  //* account section
  static const String userRegister = "/accounts/register/";
  static const String userLogin = "/accounts/login/";
  static const String forgotPassword = "/accounts/forgot-password/";
  static String verifyToken({required String id}) =>
      "/accounts/verify-reset-token/$id/";
  static String resetPassword({required String id}) =>
      "/accounts/reset-password/$id/";
  static const String profile = "/accounts/profile/";
  static const String updateProfile = "/accounts/profile/update/";
  static const String updatePassword = "/accounts/change-password/";
  static const String getSubscriptionPlans = "/subscription/subscription-plan/";
  static const String refreshToken = "/accounts/token/refresh/";
  static const String logOut = "/accounts/logout/";

  //* horse-race section
  static String trackDetails = "/horse-race/track-displaying/";
  static String distanceDetails = "/horse-race/distance-displaying/";
  static String searchFilterDetails = "/horse-race/search-filter-display/";
  static String barrierDetails = "/horse-race/barrier-display/";

  static String getUpcomingMeetings({
    required String jumpFilter,
    String? track,
  }) =>
      "/horse-race/upcoming-runners/?jump=$jumpFilter${(track != null) ? "&track=$track" : ""}";

  static String createSaveSearch = "/horse-race/saved-search/";
  static String getAllSaveSearch = "/horse-race/saved-search/";
  static String getSearchDetails({required String id}) =>
      "/horse-race/saved-search/$id/";

  static String editSaveSearch({required String id}) =>
      "/horse-race/saved-search/$id/";

  static String deleteSaveSearch({required String id}) =>
      "/horse-race/saved-search/$id/";

  static const String tipSlipCreation = "/horse-race/tip-slip/";
  static const String getAlltipSlipCreation = "/horse-race/tip-slip";

  static String getSingleTipSlipDetails({required String id}) {
    return "/horse-race/tip-slip/$id/";
  }

  static String deleteTipSlip({required String id}) {
    return "/horse-race/tip-slip/$id/";
  }

  //* Calssic formGuide view
  static String getClassicFormGuide({required String jumpFilter}) =>
      "/horse-race/classic-form-guide/?jump=$jumpFilter";

  static const String nextToGo = "/horse-race/next-to-go/";
  // static String getMeetingWithRaceDetail({required String meetingId}) =>
  //     "/horse-race/race-detail/?meeting_id=$meetingId";

  static String getMeetingraceList({required String meetingId}) =>
      "/horse-race/meetings/$meetingId/races/";

  static String getRaceFieldDetail({required String id}) =>
      "/horse-race/races/$id/field/";

  static String getTipsAndAnalysis({required String meetingId}) =>
      "/horse-race/races/$meetingId/tips/";

  //* display

  static const String getTrackDisplay = "/horse-race/track-displaying/";
  static const String getDistanceDisplay = "/horse-race/distance-displaying/";
  static const String getSearchDisplay = "/horse-race/search-filter-display/";

  //* notification
  static const String notification = "/chat-group/notification/";
  static const String deleteSingleNotification = "/chat-group/notification/";
  static const String deleteAllNotification =
      "/chat-group/notification/clear-all/";

  //* chat group
  static const String createChatGroup = "/chat-group/create-group/";
  static String chatGroupInvitation({required String id}) =>
      "/chat-group/invite-user-to-group/$id/";
  static String getUserInviteList({required String groupId}) =>
      "/chat-group/invitation-user-list/?group_id=$groupId";
  static String acceptInvitation({required String id}) =>
      "/chat-group/invite/5/$id/accept/";
  static String rejectInvitation({required String id}) =>
      "/chat-group/invite/5/$id/reject/";
  static String userNameSetup({required String id}) =>
      "/chat-group/username-setup/$id/";
  static String getGroupMemberInfo({required String id}) =>
      "/chat-group/group-member-info/$id/";
  static String leaveGroup({required String id}) =>
      "/chat-group/leave-group/$id/";
  static String getChatHistory({required String id}) =>
      "/chat-group/history/$id/";

  //* bot
  static const String bot = "/bot/chat/";
}
