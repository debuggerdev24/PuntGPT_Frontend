import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/forgot_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/login_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/reset_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/sign_up_screen.dart';
import 'package:puntgpt_nick/screens/auth/screens/mobile/verify_otp_screen.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/search_filter_screen.dart';

class AuthRoutes {

  static final List<RouteBase> routes = [
    GoRoute(
        path: AppRoutes.loginScreen.path,
        name: AppRoutes.loginScreen.name,
        builder: (context, state) =>
            LoginScreen(isFreeSignUp: (state.extra as Map)['is_free_sign_up']),
      ),

      GoRoute(
        path: AppRoutes.signUpScreen.path,
        name: AppRoutes.signUpScreen.name,
        builder: (context, state) =>
            SignUpScreen(isFreeSignUp: (state.extra as Map)['is_free_sign_up']),
      ),

      GoRoute(
        name: AppRoutes.searchFilter.name,
        path: AppRoutes.searchFilter.path,
        builder: (context, state) {
          return SearchFilterScreen();
        },
      ),
      GoRoute(
        name: AppRoutes.forgotPasswordScreen.name,
        path: AppRoutes.forgotPasswordScreen.path,
        builder: (context, state) {
          return ForgotPasswordScreen();
        },
      ),
      GoRoute(
        name: AppRoutes.verifyOTPScreen.name,
        path: AppRoutes.verifyOTPScreen.path,
        builder: (context, state) {
          return VerifyOtpScreen();
        },
      ),
      GoRoute(
        name: AppRoutes.resetPasswordScreen.name,
        path: AppRoutes.resetPasswordScreen.path,
        builder: (context, state) {
          return ResetPasswordScreen();
        },
      ),

  ];
}
