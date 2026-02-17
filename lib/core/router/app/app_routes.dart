// class AppRoutes {
//   // Prevent instantiation
//   AppRoutes._();

//   static const String splash = '/splash';
//   static const String ageConfirmationScreen = '/age-confirmation';
//   static const String onboardingScreen = '/onboarding';
//   static const String loginScreen = '/login';
//   static const String signUpScreen = '/signup';
//   static const String forgotPasswordScreen = '/forgot-password';
//   static const String verifyOTPScreen = '/verify-otp';
//   static const String resetPasswordScreen = '/reset-password';
//   static const String dashBoard = '/dashboard';
//   static const String homeScreen = '/home';
//   static const String searchFilter = '/search-filter';
//   static const String savedSearchedScreen = '/saved-search';
//   static const String searchDetails = '/search-detail';
//   static const String askPuntGpt = '/ask-punt-gpt';
//   static const String changePassword = '/change-password';
//   static const String tipSlipScreen = '/tip-slip';
//   static const String selectedRace = '/selected-race';
//   static const String tipsAndAnalysis = '/tips-and-analysis';
//   static const String speedMaps = '/speed-maps';
//   static const String puntGptClub = '/punt-gpt-club';
//   static const String punterClubChatScreen = '/punter-club-chat';
//   static const String bookies = '/bookies';
//   static const String account = '/account';
//   static const String personalDetailsScreen = '/personal-details';
//   static const String manageSubscriptionScreen = '/manage-subscription';
//   static const String offlineViewScreen = '/offline-view';
//   static const String selectedPlanScreen = '/selected-plan';
//   static const String currentPlanScreen = '/current-plan';
//   static const String runnersScreen = '/runners-screen';
// }

// extension AppRoutesExtension on String {
//   /// Returns a formatted route name by converting a path into an underscore-separated string.
//   ///
//   /// This is useful when generating route `name` values for GoRouter.
//   ///
//   /// Example:
//   /// ```dart
//   /// const route = "/customer/home";
//   /// print(route.name); // Output: "customer_home"
//   ///
//   /// const anotherRoute = "/auth/login";
//   /// print(anotherRoute.name); // Output: "auth_login"
//   /// ```
//   String get name {
//     if (this == "/") {
//       return "home";
//     }
//     String s = startsWith('/') ? substring(1) : this;
//     return s.split('/').join('_');
//   }
// }

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
searchFilter,
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
runnersScreen,
}


extension WebRouteExtension on AppRoutes {
  String get path => this == AppRoutes.homeScreen ? "/" : "/$name";
}
