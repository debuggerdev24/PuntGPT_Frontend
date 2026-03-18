import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/router/app/route_pages/account_routes.dart';
import 'package:puntgpt_nick/core/router/app/route_pages/auth_routes.dart';
import 'package:puntgpt_nick/core/router/app/route_pages/bookies_routes.dart';
import 'package:puntgpt_nick/core/router/app/route_pages/home_routes.dart';
import 'package:puntgpt_nick/core/router/app/route_pages/punt_club_routes.dart';
import 'package:puntgpt_nick/core/widgets/offline/offline_screen.dart';

import 'package:puntgpt_nick/screens/onboarding/mobile/age_confirmation_screen.dart';
import 'package:puntgpt_nick/screens/onboarding/mobile/on_boarding_screen.dart';
import 'package:puntgpt_nick/screens/onboarding/web/web_onboarding_screen.dart';

import 'package:puntgpt_nick/screens/splash/splash_screen.dart';

import '../../../screens/dashboard/mobile/dashboard.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static StatefulNavigationShell? indexedStackNavigationShell;

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,

    initialLocation: AppRoutes.splash.path,
    routes: [
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        builder: (context, state) => SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.ageConfirmationScreen.path,
        name: AppRoutes.ageConfirmationScreen.name,
        builder: (context, state) => AgeConfirmationScreen(),
      ),
      GoRoute(
        path: AppRoutes.offlineViewScreen.path,
        name: AppRoutes.offlineViewScreen.name,
        builder: (context, state) => OfflineScreen(),
      ),

      GoRoute(
        path: AppRoutes.onboardingScreen.path,
        name: AppRoutes.onboardingScreen.name,
        builder: (context, state) =>
            kIsWeb ? WebOnboardingScreen() : OnboardingScreen(),
      ),

      // ==================== AUTH ROUTES ====================
      ...AuthRoutes.routes,
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
          //* ----------> Customer Home Tab
          StatefulShellBranch(
            // navigatorKey: _shellNavigatorCustomerHome,
            routes: HomeRoutes.routes,
          ),
          //* ----------> PuntGPT Punter Club Tab
          StatefulShellBranch(routes: PuntClubRoutes.routes),
          //* ----------> Bookies Tab
          StatefulShellBranch(routes: BookiesRoutes.routes),
          //* ---------->  Account Tab
          StatefulShellBranch(routes: AccountRoutes.routes),
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
              style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold),
            ),
            15.w.verticalSpace,
            Text('Page not found: ${state.matchedLocation}'),
            24.w.verticalSpace,
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.homeScreen.path),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
