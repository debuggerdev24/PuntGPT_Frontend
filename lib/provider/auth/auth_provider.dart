import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/services/auth/auth_api_service.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController firstNameCtr = TextEditingController(),
      lastNameCtr = TextEditingController(),
      emailCtr = TextEditingController(),
      phoneCtr = TextEditingController(),
      passwordCtr = TextEditingController(),
      confirmPasswordCtr = TextEditingController(),
      forgotPasswordCtr = TextEditingController(),
      newPasswordCtr = TextEditingController(),
      //

      resetConfirmPasswordCtr = TextEditingController(),
      otpCtr = TextEditingController(),
      addressLine1Ctr = TextEditingController(),
      addressLine2Ctr = TextEditingController(),
      suburbCtr = TextEditingController(),
      postCodeCtr = TextEditingController();

  /// Selected country for phone (from country_picker). Used for country name in API and phone validation.
  /// Defaults to Australia — must match the fallback in [PhoneCountryField] when this was null.
  Country? _selectedCountry = CountryService().findByCode('au');
  Country? get selectedPhoneCountry => _selectedCountry;
  set selectedPhoneCountry(Country? value) {
    _selectedCountry = value;
    notifyListeners();
  }

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

  /// Onboarding plan tab selection.
  /// 0 = Mug Punter, 1 = Pro Punter
  int _onboardingPlanTab = 1;
  int get onboardingPlanTab => _onboardingPlanTab;
  // bool get isOnboardingProPunter => _onboardingPlanTab == 1;

  void setOnboardingPlanTab(int value) {
    if (value == _onboardingPlanTab) return;
    _onboardingPlanTab = value;
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

  //* register user

  bool isSignUpLoading = false;
  Future<void> registerUser({required BuildContext context}) async {
    //* agreed to terms and conditions or not?

    if (!isReadTermsAndConditions) {
      AppToast.warning(
        context: context,
        message: "Please check the box to agree to the terms and continue.",
      );
      return;
    }
    final country = _selectedCountry ?? CountryService().findByCode('au');
    if (country == null) {
      AppToast.warning(
        context: context,
        message: "Please select a country for your mobile number.",
      );
      return;
    }

    isSignUpLoading = true;
    notifyListeners();
    final registerData = <String, dynamic>{
      "first_name": firstNameCtr.text.trim(),
      "last_name": lastNameCtr.text.trim(),
      "state": selectedState!,
      "email": emailCtr.text.trim(),
      "phone":
          '+${country.phoneCode}${phoneCtr.text.replaceAll(RegExp(r'[^0-9]'), '')}',
      "password": passwordCtr.text.trim(),
      "confirm_password": confirmPasswordCtr.text.trim(),
      "agreed_to_terms": isReadTermsAndConditions.toString(),
      if (addressLine1Ctr.text.trim().isNotEmpty)
        "address_line_1": addressLine1Ctr.text.trim(),
      if (addressLine2Ctr.text.trim().isNotEmpty)
        "address_line_2": addressLine2Ctr.text.trim(),
      if (suburbCtr.text.trim().isNotEmpty) "suburb": suburbCtr.text.trim(),
      if (postCodeCtr.text.trim().isNotEmpty)
        "post_code": postCodeCtr.text.trim(),
      "country": country.name,
    };
    final result = await AuthApiService.instance.registerUser(
      data: registerData,
    );

    result.fold(
      (l) {
        Logger.error(l.errorMsg);
        if (l.errorMsg.contains("already exists")) {
          AppToast.info(context: context, message: "Email already exists");
        }
        isSignUpLoading = false;
        notifyListeners();
      },
      (r) async {
        await login(context: context, showLoginToast: false);
        // ignore: use_build_context_synchronously
        AppToast.success(context: context, message: "Register Successfully.");
        clearSignUpControllers();
        clearLoginControllers();
        isSignUpLoading = false;
        notifyListeners();
      },
    );
  }

  //todo user login
  bool isLoginLoading = false;
  Future<void> login({
    required BuildContext context,
    bool? showLoginToast = true,
  }) async {
    isLoginLoading = true;
    notifyListeners();

    final result = await AuthApiService.instance.loginWithEmailPassword(
      email: emailCtr.text.trim(),
      password: passwordCtr.text.trim(),
    );

    result.fold(
      (l) {
        Logger.error(l.apiErrorMsg ?? l.errorMsg);
        AppToast.error(context: context, message: l.errorMsg);
      },
      (r) async {
        final data = r["data"];
        if (showLoginToast == true) {
          AppToast.success(
            context: context,
            message: "Login Successfully.",
            duration: 4.seconds,
          );
        }

        await LocaleStorageService.saveUserToken(data["access"]);
        await LocaleStorageService.saveUserRefreshToken(data["refresh"]);
        await LocaleStorageService.saveUserId(
          int.parse(data["user_id"].toString()),
        );

        await LocaleStorageService.setLoggedInUserEmail(emailCtr.text.trim());
        await LocaleStorageService.setLoggedInUserPassword(
          passwordCtr.text.trim(),
        );

        if (context.mounted) {
          context.goNamed(
            (kIsWeb) ? WebRoutes.homeScreen.name : AppRoutes.homeScreen.name,
          );
          isGuest = false;
        }
        clearLoginControllers();
      },
    );
    isLoginLoading = false;
    notifyListeners();
  }

  //* -----------------> send OTP
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

  bool isDeleteAccountLoading = false;

  //* Permanently deletes the account on the server and clears local session.
  Future<void> deleteAccount({
    required VoidCallback onSuccess,
    required Function(String error) onFailed,
  }) async {
    isDeleteAccountLoading = true;
    notifyListeners();
    final result = await AuthApiService.instance.deleteAccount();
    result.fold(
      (l) {
        onFailed(l.errorMsg);
      },
      (r) {
        LocaleStorageService.clearUserTokens();

        onSuccess();
      },
    );
    isDeleteAccountLoading = false;
    notifyListeners();
  }

  //
  void clearSignUpControllers() {
    firstNameCtr.clear();
    lastNameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    passwordCtr.clear();
    confirmPasswordCtr.clear();
    addressLine1Ctr.clear();
    addressLine2Ctr.clear();
    suburbCtr.clear();
    postCodeCtr.clear();
    selectedPhoneCountry = CountryService().findByCode('au');
    selectedState = "";
    _isReadTermsAndConditions = false;
  }

  void clearLoginControllers() {
    emailCtr.clear();
    passwordCtr.clear();
  }
}
