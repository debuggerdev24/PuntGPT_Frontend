import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/core/router/web/web_routes.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/responsive/responsive_builder.dart';
import 'package:puntgpt_nick/screens/account/mobile/account_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/current_plan_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/manage_subscription_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/personal_details_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/selected_plan_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/forgot_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/reset_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/verify_otp_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/web/web_forgot_pass_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/web/web_login_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/web/web_reset_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/web/web_sign_up_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/web/web_verify_otp_screen.dart';
import 'package:puntgpt_nick/screens/dashboard/web/web_dashboard.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/tip_slip_screen_web.dart';
import 'package:puntgpt_nick/screens/onboarding/web/web_age_confirmation.dart';
import 'package:puntgpt_nick/screens/punter_club/mobile/club_chat_screen.dart';
import 'package:puntgpt_nick/screens/punter_club/web/punter_club_screen_web.dart';
import 'package:puntgpt_nick/screens/splash/web_splash_screen.dart';

import '../../../screens/account/web/account_screen_web.dart';
import '../../../screens/bookies/web/bookies_screen_web.dart';
import '../../../screens/home/search_engine/mobile/ask_puntgpt_screen.dart';
import '../../../screens/home/search_engine/mobile/saved_search_screen.dart';
import '../../../screens/home/search_engine/web/selected_race_screen_web.dart';
import '../../../screens/onboarding/web/web_onboarding_screen.dart';
import '../../../screens/punter_club/mobile/punt_club_screen.dart';

class WebRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static StatefulNavigationShell? indexedStackNavigationShell;

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: WebRoutes.splashScreen.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: WebRoutes.splashScreen.path,
        name: WebRoutes.splashScreen.name,
        builder: (context, state) => WebSplashScreen(),
      ),
      GoRoute(
        path: WebRoutes.onBoardingScreen.path,
        name: WebRoutes.onBoardingScreen.name,
        builder: (context, state) => WebOnboardingScreen(),
      ),
      GoRoute(
        path: WebRoutes.ageConfirmationScreen.path,
        name: WebRoutes.ageConfirmationScreen.name,
        builder: (context, state) => WebAgeConfirmationScreen(),
      ),
      GoRoute(
        path: WebRoutes.signUpScreen.path,
        name: WebRoutes.signUpScreen.name,
        builder: (context, state) =>
            WebSignUpScreen(isFreeSignUp: state.extra as bool),
      ),
      GoRoute(
        path: WebRoutes.logInScreen.path,
        name: WebRoutes.logInScreen.name,
        builder: (context, state) => WebLoginScreen(),
      ),
      GoRoute(
        path: WebRoutes.forgotPasswordScreen.path,
        name: WebRoutes.forgotPasswordScreen.name,
        builder: (context, state) => context.isMobileView
            ? ForgotPasswordScreen()
            : WebForgotPassScreen(),
      ),
      GoRoute(
        path: WebRoutes.verifyOTPScreen.path,
        name: WebRoutes.verifyOTPScreen.name,
        builder: (context, state) =>
            context.isMobileView ? VerifyOtpScreen() : WebVerifyOtpScreen(),
      ),
      GoRoute(
        path: WebRoutes.resetPasswordScreen.path,
        name: WebRoutes.resetPasswordScreen.name,
        builder: (context, state) => context.isMobileView
            ? ResetPasswordScreen()
            : WebResetPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          indexedStackNavigationShell = navigationShell;
          return WebDashboard(
            // key: state.pageKey,
            navigationShell: indexedStackNavigationShell!,
          );
        },
        branches: <StatefulShellBranch>[
          //todo bookies branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WebRoutes.bookiesScreen.path,
                name: WebRoutes.bookiesScreen.name,
                builder: (context, state) => BookiesScreenWeb(),
              ),
            ],
          ),
          //todo Punter Club branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WebRoutes.punterClubScreen.path,
                name: WebRoutes.punterClubScreen.name,
                builder: (context, state) => context.isMobileView
                    ? PunterClubScreen()
                    : PunterClubScreenWebScreen(),
              ),
              GoRoute(
                path: WebRoutes.punterClubChatScreen.path,
                name: WebRoutes.punterClubChatScreen.name,
                builder: (context, state) =>
                    PuntClubChatScreen(title: state.extra as String),
              ),
            ],
          ),
          //todo home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WebRoutes.homeScreen.path,
                name: WebRoutes.homeScreen.name,
                builder: (context, state) => HomeScreenWeb(),
              ),
              GoRoute(
                path: WebRoutes.selectedRace.path,
                name: WebRoutes.selectedRace.name,
                builder: (context, state) => SelectedRaceTableScreenWeb(),
              ),
              GoRoute(
                name: WebRoutes.askPuntGptScreen.name,
                path: WebRoutes.askPuntGptScreen.path,
                builder: (context, state) => AskPuntGptScreen(),
              ),
              GoRoute(
                name: WebRoutes.savedSearchedScreen.name,
                path: WebRoutes.savedSearchedScreen.path,
                builder: (BuildContext context, GoRouterState state) {
                  return SavedSearchScreen();
                },
              ),
            ],
          ),
          //todo tip slip branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WebRoutes.tipSlipScreen.path,
                name: WebRoutes.tipSlipScreen.name,
                builder: (context, state) => TipSlipScreenWeb(),
              ),
            ],
          ),
          //todo account branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WebRoutes.accountScreen.path,
                name: WebRoutes.accountScreen.name,
                builder: (context, state) => (context.isMobileView)
                    ? AccountScreen()
                    : AccountScreenWeb(),
              ),
              GoRoute(
                path: WebRoutes.personalDetailsScreen.path,
                name: WebRoutes.personalDetailsScreen.name,
                builder: (context, state) => (context.isMobileView)
                    ? PersonalDetailsScreen()
                    : AccountScreenWeb(),
              ),
              GoRoute(
                path: WebRoutes.manageSubscriptionScreen.path,
                name: WebRoutes.manageSubscriptionScreen.name,
                builder: (context, state) => (context.isMobileView)
                    ? ManageSubscriptionScreen()
                    : AccountScreenWeb(),
              ),
              GoRoute(
                path: WebRoutes.currentPlanScreen.path,
                name: WebRoutes.currentPlanScreen.name,
                builder: (context, state) => CurrentPlanScreen(),
              ),
              GoRoute(
                path: WebRoutes.selectedPlanScreen.path,
                name: WebRoutes.selectedPlanScreen.name,
                builder: (context, state) => SelectedPlanScreen(
                  plan: state.extra as SubscriptionPlanModel,
                ),
              ),
            ],
          ),
        ],
      ),
    ],

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
              onPressed: () => context.goNamed(WebRoutes.homeScreen.name),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
