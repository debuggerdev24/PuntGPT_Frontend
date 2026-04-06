enum WebRoutes {
  splashScreen,
  homeScreen,
  onBoardingScreen,
  signUpScreen,
  logInScreen,
  selectedRace,
  tipSlipScreen,
  accountScreen,
  personalDetailsScreen,
  manageSubscriptionScreen,
  askPuntGptScreen,
  savedSearchedScreen,
  punterClubScreen,
  punterClubChatScreen,
  bookiesScreen,
  subscribeToProPunterScreen,
  forgotPasswordScreen,
  verifyOTPScreen,
  resetPasswordScreen, currentPlanScreen, selectedPlanScreen,
}

extension WebRouteExtension on WebRoutes {
  String get path => this == WebRoutes.homeScreen ? "/" : "/$name";
}
