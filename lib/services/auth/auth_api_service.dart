import 'package:dartz/dartz.dart';
import 'package:puntgpt_nick/service/storage/locale_storage_service.dart';

import '../../core/constants/end_points.dart';
import '../../core/helper/base_api_helper.dart';

class AuthApiService {
  AuthApiService._();

  static final AuthApiService _instance = AuthApiService._();
  static AuthApiService instance = _instance;

  Future<Either<ApiException, Map<String, dynamic>>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.userLogin,
      data: {"email": email, "password": password},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> registerUser({
    required String firstName,
    required String lastName,
    required String dob,
    required String state,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String agreedToTerms,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.userRegister,
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth": dob,
        "state": state,
        "email": email,
        "phone": phone,
        "password": password,
        "confirm_password": confirmPassword,
        "agreed_to_terms": agreedToTerms,
      },
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> sendOtp({
    required String email,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.forgotPassword,
      data: {"email": email},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> verifyOTP({
    required String otp,
    required String userId,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.verifyToken(id: userId),
      data: {"reset_token": otp},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String userID,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.resetPassword(id: userID),
      data: {"new_password": newPassword, "confirm_password": confirmPassword},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> refreshToken() async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.refreshToken,
      data: {"refresh": LocaleStorageService.refreshToken},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> logOut({
    required Map data,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      data: data,
      EndPoints.logOut,
    );
  }
}
