
enum AppRoutes {
  splash,
  ageConfirmationScreen,
onboardingScreen,
loginScreen,
signUpScreen,
forgotPasswordScreen,
verifyOTPScreen,
resetPasswordScreen,
dashBoard,
homeScreen,
savedSearchedScreen,
searchDetails,
askPuntGpt,
changePassword,
tipSlipScreen,
selectedRace,
tipsAndAnalysis,
speedMaps,
puntGptClub,
punterClubChatScreen,
bookies,
account,
personalDetailsScreen,
manageSubscriptionScreen,
offlineViewScreen,
selectedPlanScreen,
currentPlanScreen,
  runnersScreen, groupMembersScreen, lifeTimeMembersScreen, uploadStoryContent, editStorySection, editStoryOption, uploadStoryData, deleteStoryContent, createNewStorySection,
}


extension WebRouteExtension on AppRoutes {
  String get path => this == AppRoutes.homeScreen ? "/" : "/$name";
}
