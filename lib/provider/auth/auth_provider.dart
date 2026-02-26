import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/service/auth/auth_api_service.dart';
import 'package:puntgpt_nick/service/storage/locale_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController firstNameCtr = TextEditingController(),
      lastNameCtr = TextEditingController(),
      emailCtr = TextEditingController(),
      phoneCtr = TextEditingController(),
      passwordCtr = TextEditingController(),
      confirmPasswordCtr = TextEditingController(),
      dobCtr = TextEditingController(),
      loginEmailCtr = TextEditingController(),
      loginPasswordCtr = TextEditingController(),
      forgotPasswordCtr = TextEditingController(text: "test@gmail.com"),
      newPasswordCtr = TextEditingController(),
      resetConfirmPasswordCtr = TextEditingController(),
      otpCtr = TextEditingController();

  int _selectedTab = 0, _resendSeconds = 0;
  Timer? _resendTimer;

  String? _selectedState, _forgotPassUid;
  late String _forgotPasswordMail;

  bool get canResendOtp => _resendSeconds == 0;
  int get selectedTab => _selectedTab;

  int get resendSeconds => _resendSeconds;
  set setSelectedTab(int value) {
    _selectedTab = value;
    notifyListeners();
  }

  String? get selectedState => _selectedState;
  set selectedState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  bool _showSignUpPass = false;
  bool get showSignUpPass => _showSignUpPass;
  set showSignUpPass(bool value) {
    _showSignUpPass = value;
    notifyListeners();
  }

  bool _showConfirmPass = false;
  bool get showConfirmPass => _showConfirmPass;
  set showConfirmPass(bool value) {
    _showConfirmPass = value;
    notifyListeners();
  }

  bool _showLoginPass = false;
  bool get showLoginPass => _showLoginPass;
  set showLoginPass(bool value) {
    _showLoginPass = value;
    notifyListeners();
  }

  bool _isReadTermsAndConditions = false;
  bool get isReadTermsAndConditions => _isReadTermsAndConditions;
  set isReadTermsAndConditions(bool value) {
    _isReadTermsAndConditions = value;
    notifyListeners();
  }

  //todo register user

  bool isSignUpLoading = false;
  Future<void> registerUser({
    required BuildContext context,
    required bool isFreeSignUp,
  }) async {
    //todo agreed to terms and conditions or not?

    if (!isReadTermsAndConditions) {
      AppToast.warning(
        context: context,
        message: "Please check the box to agree to the terms and continue.",
      );
      return;
    }

    isSignUpLoading = true;
    notifyListeners();
    final result = await AuthApiService.instance.registerUser(
      firstName: firstNameCtr.text.trim(),
      lastName: lastNameCtr.text.trim(),
      dob: dobCtr.text.trim(),
      state: selectedState!,
      email: emailCtr.text.trim(),
      phone: phoneCtr.text.trim(),
      password: passwordCtr.text.trim(),
      confirmPassword: confirmPasswordCtr.text.trim(),
      agreedToTerms: isReadTermsAndConditions.toString(),
    );

    result.fold(
      (l) {
        Logger.error(l.apiErrorMsg!);
      },
      (r) {
        AppToast.success(context: context, message: "Register Successfully.");
        context.pushNamed(
          (kIsWeb) ? WebRoutes.logInScreen.name : AppRoutes.loginScreen.name,
          extra: {"is_free_sign_up": isFreeSignUp},
        );

        clearSignUpControllers();
        clearLoginControllers();
      },
    );
    isSignUpLoading = false;
    notifyListeners();
  }

  //todo user login
  bool isLoginLoading = false;
  Future<void> loginUser({required BuildContext context}) async {
    isLoginLoading = true;
    notifyListeners();

    final result = await AuthApiService.instance.loginWithEmailPassword(
      email: loginEmailCtr.text.trim(),
      password: loginPasswordCtr.text.trim(),
    );

    result.fold(
      (l) {
        Logger.error(l.apiErrorMsg!);
        if (l.errorMsg.contains("Invalid email or password")) {
          AppToast.error(
            context: context,
            message: "Account not found with this email!",
          );
        }
      },
      (r) async {
        final data = r["data"];
        AppToast.success(
          context: context,
          message: "Login Successfully.",
          duration: 4.seconds,
        );
        await LocaleStorageService.saveUserToken(data["access"]);
        await LocaleStorageService.saveUserRefreshToken(data["refresh"]);
        await LocaleStorageService.saveUserId(data["user_id"].toString());
        await LocaleStorageService.setIsUserLoggedIn();
        await LocaleStorageService.setLoggedInUserEmail(
          loginEmailCtr.text.trim(),
        );
        await LocaleStorageService.setLoggedInUserPassword(
          loginPasswordCtr.text.trim(),
        );

        if (context.mounted) {
          context.goNamed(
            (kIsWeb) ? WebRoutes.homeScreen.name : AppRoutes.homeScreen.name,
          );
        }
        clearLoginControllers();
      },
    );
    isLoginLoading = false;
    notifyListeners();
  }

  //todo -----------------> send OTP
  bool isForgotPassLoading = false;
  Future<void> sendOTP({required BuildContext context}) async {
    isForgotPassLoading = true;
    notifyListeners();

    final result = await AuthApiService.instance.sendOtp(
      email: forgotPasswordCtr.text.trim(),
    );

    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        _forgotPassUid = r["data"]["user_id"].toString();
        AppToast.success(context: context, message: "OTP sent successfully");
        context.pushNamed(
          (kIsWeb)
              ? WebRoutes.verifyOTPScreen.name
              : AppRoutes.verifyOTPScreen.name,
        );
        _startResendTimer();
        _forgotPasswordMail = forgotPasswordCtr.text.trim();
        forgotPasswordCtr.clear();
      },
    );
    isForgotPassLoading = false;
    notifyListeners();
  }

  //todo ---------------> timer for the resend Otp
  void _startResendTimer() {
    _resendSeconds = 60; // 1 minute
    notifyListeners();

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        _resendSeconds--;
        notifyListeners();
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  bool isVerifyOtpLoading = false;
  Future<void> verifyOtp({required BuildContext context}) async {
    isVerifyOtpLoading = true;
    notifyListeners();

    final result = await AuthApiService.instance.verifyOTP(
      otp: otpCtr.text.trim(),
      userId: _forgotPassUid!,
    );

    result.fold(
      (l) {
        Logger.error(l.errorMsg);
        if (l.errorMsg.contains("expired")) {
          AppToast.error(context: context, message: "Token has expired");
          return;
        }
        AppToast.error(context: context, message: l.errorMsg);
      },
      (r) {
        AppToast.success(context: context, message: "OTP verify successfully");
        context.pushNamed(
          (kIsWeb)
              ? WebRoutes.resetPasswordScreen.name
              : AppRoutes.resetPasswordScreen.name,
        );
        otpCtr.clear();
      },
    );
    isVerifyOtpLoading = false;
    notifyListeners();
  }

  bool isResendOtpLoading = false;
  Future<void> resendOtp({required BuildContext context}) async {
    if (!canResendOtp) {
      AppToast.error(
        context: context,
        message: "Please wait $_resendSeconds seconds before resending",
      );
      return;
    }

    if (_forgotPasswordMail.isEmpty) {
      AppToast.error(
        context: context,
        message: "Email not found. Please try again.",
      );
      return;
    }

    isResendOtpLoading = true;
    notifyListeners();

    final result = await AuthApiService.instance.sendOtp(
      email: _forgotPasswordMail,
    );

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMsg);
      },
      (data) async {
        AppToast.success(context: context, message: "OTP sent successfully");

        otpCtr.clear();
        _startResendTimer();
      },
    );

    isResendOtpLoading = false;
    notifyListeners();
  }

  bool isResetPasswordLoading = false;
  Future<void> resetPassword({required BuildContext context}) async {
    isResetPasswordLoading = true;
    notifyListeners();
    final result = await AuthApiService.instance.resetPassword(
      newPassword: newPasswordCtr.text.trim(),
      confirmPassword: resetConfirmPasswordCtr.text.trim(),
      userID: _forgotPassUid!,
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        context.goNamed(
          (kIsWeb) ? WebRoutes.logInScreen.name : AppRoutes.loginScreen.name,
        );
        AppToast.success(
          context: context,
          message: "Your password has been reset successfully.",
        );
      },
    );
    isResetPasswordLoading = false;
    notifyListeners();
  }

  bool isLogOutLoading = false;
  Future<void> logout({
    required VoidCallback onSuccess,
    required Function(String error) onFailed,
  }) async {
    isLogOutLoading = true;
    notifyListeners();
    final result = await AuthApiService.instance.logOut(
      data: {"refresh": LocaleStorageService.refreshToken},
    );

    result.fold(
      (l) {
        onFailed.call(l.errorMsg);
      },
      (r) {
        LocaleStorageService.removeAccessToken();
        LocaleStorageService.removeRefreshToken();
        onSuccess.call();
      },
    );
    isLogOutLoading = false;
    notifyListeners();
  }

  //
  void clearSignUpControllers() {
    firstNameCtr.clear();
    lastNameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    passwordCtr.clear();
    dobCtr.clear();
    confirmPasswordCtr.clear();
    selectedState = "";
    _isReadTermsAndConditions = false;
  }

  void clearLoginControllers() {
    loginEmailCtr.clear();
    loginPasswordCtr.clear();
  }
}
