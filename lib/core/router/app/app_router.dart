import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/models/search_engine/runner_model.dart';
import 'package:puntgpt_nick/screens/account/mobile/account_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/current_plan_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/selected_plan_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/forgot_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/login_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/reset_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/verify_otp_screen.dart';
import 'package:puntgpt_nick/screens/bookies/mobile/bookies_screen.dart';
import 'package:puntgpt_nick/screens/home/mobile/ask_punt_gpt.dart';
import 'package:puntgpt_nick/screens/home/mobile/home_screen.dart';
import 'package:puntgpt_nick/screens/home/mobile/widgets/runners_list_screen.dart';
import 'package:puntgpt_nick/screens/offline/offline_screen.dart';
import 'package:puntgpt_nick/screens/onboarding/mobile/age_confirmation_screen.dart';
import 'package:puntgpt_nick/screens/onboarding/mobile/on_boarding_screen.dart';
import 'package:puntgpt_nick/screens/onboarding/web/web_onboarding_screen.dart';
import 'package:puntgpt_nick/screens/punt_gpt_club/mobile/club_chat_screen.dart';
import 'package:puntgpt_nick/screens/splash/splash_screen.dart';
import '../../../screens/account/mobile/change_password_screen.dart';
import '../../../screens/account/mobile/manage_subscription_screen.dart';
import '../../../screens/account/mobile/personal_details_screen.dart';
import '../../../screens/auth/screens/mobile/sign_up_screen.dart';
import '../../../screens/dashboard/mobile/dashboard.dart';
import '../../../screens/home/mobile/manage_saved_search.dart';
import '../../../screens/home/mobile/saved_search_screen.dart';
import '../../../screens/home/mobile/search_filter_screen.dart';
import '../../../screens/home/mobile/selected_race_screen.dart';
import '../../../screens/home/mobile/tip_slip_screen.dart';
import '../../../screens/punt_gpt_club/mobile/punt_club_screen.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static StatefulNavigationShell? indexedStackNavigationShell;

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash.name,
        builder: (context, state) => SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.ageConfirmationScreen,
        name: AppRoutes.ageConfirmationScreen.name,
        builder: (context, state) => AgeConfirmationScreen(),
      ),
      GoRoute(
        path: AppRoutes.offlineViewScreen,
        name: AppRoutes.offlineViewScreen.name,
        builder: (context, state) => OfflineScreen(),
      ),

      GoRoute(
        path: AppRoutes.onboardingScreen,
        name: AppRoutes.onboardingScreen.name,
        builder: (context, state) =>
            kIsWeb ? WebOnboardingScreen() : OnboardingScreen(),
      ),

      // ==================== AUTH ROUTES ====================
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) =>
            LoginScreen(isFreeSignUp: (state.extra as Map)['is_free_sign_up']),
      ),

      GoRoute(
        path: AppRoutes.signUpScreen,
        name: AppRoutes.signUpScreen.name,
        builder: (context, state) =>
            SignUpScreen(isFreeSignUp: (state.extra as Map)['is_free_sign_up']),
      ),

      GoRoute(
        name: AppRoutes.searchFilter.name,
        path: AppRoutes.searchFilter,
        builder: (context, state) {
          return SearchFilterScreen();
        },
      ),
      GoRoute(
        name: AppRoutes.forgotPasswordScreen.name,
        path: AppRoutes.forgotPasswordScreen,
        builder: (context, state) {
          return ForgotPasswordScreen();
        },
      ),
      GoRoute(
        name: AppRoutes.verifyOTPScreen.name,
        path: AppRoutes.verifyOTPScreen,
        builder: (context, state) {
          return VerifyOtpScreen();
        },
      ),
      GoRoute(
        name: AppRoutes.resetPasswordScreen.name,
        path: AppRoutes.resetPasswordScreen,
        builder: (context, state) {
          return ResetPasswordScreen();
        },
      ),

      // ==================== MAIN APP WITH SHELL (Bottom Nav) ====================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          indexedStackNavigationShell = navigationShell;
          return Dashboard(
            // key: state.pageKey,
            navigationShell: indexedStackNavigationShell!,
          );
        },
        branches: <StatefulShellBranch>[
          //todo ----------> Customer Home Tab
          StatefulShellBranch(
            // navigatorKey: _shellNavigatorCustomerHome,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.homeScreen.name,
                path: AppRoutes.homeScreen,
                builder: (BuildContext context, GoRouterState state) {
                  return HomeScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.savedSearchedScreen.name,
                path: AppRoutes.savedSearchedScreen,
                builder: (context, state) {
                  return SavedSearchScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.searchDetails.name,
                path: AppRoutes.searchDetails,
                builder: (BuildContext context, GoRouterState state) {
                  return SearchDetailScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.askPuntGpt.name,
                path: AppRoutes.askPuntGpt,
                builder: (BuildContext context, GoRouterState state) {
                  return AskPuntGptScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.selectedRace.name,
                path: AppRoutes.selectedRace,
                builder: (BuildContext context, GoRouterState state) {
                  return SelectedRaceScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.runnersScreen.name,
                path: AppRoutes.runnersScreen,
                builder: (BuildContext context, GoRouterState state) {
                  final runnerData = state.extra != null 
                      ? state.extra as RunnerDataModel 
                      : null;
                  return RunnersList(runnerData: runnerData);
                },
              ),
            ],
          ),
          //todo ----------> PuntGPT Punter Club Tab
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.puntGptClub,
                name: AppRoutes.puntGptClub.name,
                builder: (context, state) => PunterClubScreen(),
              ),
              GoRoute(
                path: AppRoutes.punterClubChatScreen,
                name: AppRoutes.punterClubChatScreen.name,
                builder: (context, state) =>
                    PuntClubChatScreen(title: state.extra as String),
              ),
            ],
          ),
          //todo ----------> Bookies Tab
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.bookies,
                name: AppRoutes.bookies.name,
                builder: (context, state) => BookiesScreen(),
              ),
            ],
          ),
          //todo ----------> Customer Account Tab
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.account.name,
                path: AppRoutes.account,
                builder: (BuildContext context, GoRouterState state) {
                  return AccountScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.personalDetailsScreen.name,
                path: AppRoutes.personalDetailsScreen,
                builder: (BuildContext context, GoRouterState state) {
                  return PersonalDetailsScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.manageSubscriptionScreen.name,
                path: AppRoutes.manageSubscriptionScreen,
                builder: (BuildContext context, GoRouterState state) {
                  return ManageSubscriptionScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.changePassword.name,
                path: AppRoutes.changePassword,
                builder: (BuildContext context, GoRouterState state) {
                  return ChangePasswordScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.tipSlipScreen.name,
                path: AppRoutes.tipSlipScreen,
                builder: (BuildContext context, GoRouterState state) {
                  return TipSlipScreen();
                },
              ),
              GoRoute(
                name: AppRoutes.selectedPlanScreen.name,
                path: AppRoutes.selectedPlanScreen,
                builder: (BuildContext context, GoRouterState state) {
                  return SelectedPlanScreen(
                    plan: (state.extra as SubscriptionPlanModel),
                  );
                },
              ),
              GoRoute(
                name: AppRoutes.currentPlanScreen.name,
                path: AppRoutes.currentPlanScreen,
                builder: (BuildContext context, GoRouterState state) {
                  return CurrentPlanScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.homeScreen),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
