import 'package:dartz/dartz.dart';
import 'package:puntgpt_nick/core/constants/end_points.dart';
import 'package:puntgpt_nick/core/helper/base_api_helper.dart';

class SubscriptionApiService {
  SubscriptionApiService._();
  static final SubscriptionApiService _instance = SubscriptionApiService._();

  static SubscriptionApiService get instance => _instance;

  Future<Either<ApiException, Map<String, dynamic>>>
  getSubscriptionPlans() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getSubscriptionPlans,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getCurrentSubscription() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.currentSubscription,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> initiateSubscription({required Map<String, dynamic> data}) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.initiateSubscription,
      data: data,
    );
  }
  Future<Either<ApiException, Map<String, dynamic>>> validateSubscription({required Map<String, dynamic> data}) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.validateSubscription,
      data: data,
    );
  }
}