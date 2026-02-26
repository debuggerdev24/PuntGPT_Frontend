import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/account/subscription_plan_model.dart';
import 'package:puntgpt_nick/screens/account/mobile/account_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/change_password_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/current_plan_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/manage_subscription_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/personal_details_screen.dart';
import 'package:puntgpt_nick/screens/account/mobile/selected_plan_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/tip_slip_screen.dart';

class AccountRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      name: AppRoutes.account.name,
      path: AppRoutes.account.path,
      builder: (BuildContext context, GoRouterState state) {
        return AccountScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.personalDetailsScreen.name,
      path: AppRoutes.personalDetailsScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return PersonalDetailsScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.manageSubscriptionScreen.name,
      path: AppRoutes.manageSubscriptionScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return ManageSubscriptionScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.changePassword.name,
      path: AppRoutes.changePassword.path,
      builder: (BuildContext context, GoRouterState state) {
        return ChangePasswordScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.tipSlipScreen.name,
      path: AppRoutes.tipSlipScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return TipSlipScreen();
      },
    ),
    GoRoute(
      name: AppRoutes.selectedPlanScreen.name,
      path: AppRoutes.selectedPlanScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return SelectedPlanScreen(plan: (state.extra as SubscriptionPlanModel));
      },
    ),
    GoRoute(
      name: AppRoutes.currentPlanScreen.name,
      path: AppRoutes.currentPlanScreen.path,
      builder: (BuildContext context, GoRouterState state) {
        return CurrentPlanScreen();
      },
    ),
  ];
}
