import 'package:dartz/dartz.dart';
import 'package:puntgpt_nick/core/constants/end_points.dart';
import 'package:puntgpt_nick/core/helper/base_api_helper.dart';

class ClassicFormAPIService {
  ClassicFormAPIService._();
  static ClassicFormAPIService instance = ClassicFormAPIService._();

  Future<Either<ApiException, Map<String, dynamic>>> getClassicForm({
    required String jumpFilter,
  }) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getClassicFormGuide(jumpFilter: jumpFilter),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getNextRace() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.nextToGo,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getMeetingRaceList({
    required String meetingId,
  }) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getMeetingraceList(meetingId: meetingId),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getRaceFieldDetail({
    required String id,
  }) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getRaceFieldDetail(id: id),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getTipsAndAnalysis({
    required String raceId,
  }) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getTipsAndAnalysis(raceId: raceId),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getSpeedMaps({
    required String meetingId,
    required String raceId,
  }) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getSpeedMaps(meetingId: meetingId, raceId: raceId),
    );
  }
}