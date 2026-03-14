import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/auth/mobile/forgot_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/mobile/login_screen.dart';
import 'package:puntgpt_nick/screens/auth/mobile/reset_password_screen.dart';
import 'package:puntgpt_nick/screens/auth/mobile/sign_up_screen.dart';
import 'package:puntgpt_nick/screens/auth/mobile/verify_otp_screen.dart';

class AuthRoutes {

  static final List<RouteBase> routes = [
    GoRoute(
        path: AppRoutes.loginScreen.path,
        name: AppRoutes.loginScreen.name,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUpScreen.path,
        name: AppRoutes.signUpScreen.name,
        builder: (context, state) => SignUpScreen(),
      ),

      // GoRoute(
      //   name: AppRoutes.searchFilter.name,
      //   path: AppRoutes.searchFilter.path,
      //   builder: (context, state) {
      //     return SearchFilterScreen();
      //   },
      // ),
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
