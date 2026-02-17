import 'package:dartz/dartz.dart';
import 'package:puntgpt_nick/core/constants/end_points.dart';
import 'package:puntgpt_nick/core/helper/base_api_helper.dart';

class PuntClubApiService {

  PuntClubApiService._();
  static final PuntClubApiService _instance = PuntClubApiService._();
  static PuntClubApiService get instance => _instance;

  Future<Either<ApiException, Map<String, dynamic>>> createChatGroup({required Map<String, dynamic> data}) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.createChatGroup,
      data: data,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getChatGroups() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getChatGroups,
    );
  }

  //users invite list
  Future<Either<ApiException, Map<String, dynamic>>> getUsersInviteList({required String groupId,required String grpName}) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getUserInviteList(groupId: groupId, grpName: grpName),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getNotificationList() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getAllNotification,
    );
  }
}