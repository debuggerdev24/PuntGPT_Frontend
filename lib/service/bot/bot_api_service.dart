import 'package:dartz/dartz.dart';
import 'package:puntgpt_nick/core/constants/end_points.dart';
import 'package:puntgpt_nick/core/helper/base_api_helper.dart';

class BotApiService {
  factory BotApiService() => _instance;
  BotApiService._internal();
  static final BotApiService _instance = BotApiService._internal();

  static BotApiService get instance => _instance;

  Future<Either<ApiException, Map<String, dynamic>>> getBotResponse({
    required Map<String, dynamic> data,
  }) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.bot,
      data: data,
    );
  }
}