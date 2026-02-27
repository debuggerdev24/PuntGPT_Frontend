import 'package:dartz/dartz.dart';

import '../../core/constants/end_points.dart';
import '../../core/helper/base_api_helper.dart';

class AccountApiService {
  AccountApiService._();
  static AccountApiService instance = AccountApiService._();

  Future<Either<ApiException, Map<String, dynamic>>> getProfile() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.profile,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    return await BaseApiHelper.instance.patch<Map<String, dynamic>>(
      data: data,
      EndPoints.updateProfile,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> updatePassword({
    required Map<String, dynamic> data,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      data: data,
      EndPoints.updatePassword,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>>
  getSubscriptionPlans() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getSubscriptionPlans,
    );
  }
}
