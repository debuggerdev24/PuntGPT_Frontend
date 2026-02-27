import 'package:dartz/dartz.dart';
import 'package:puntgpt_nick/core/constants/end_points.dart';
import 'package:puntgpt_nick/core/helper/base_api_helper.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';

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
  Future<Either<ApiException, Map<String, dynamic>>> getUsersInviteList({required String groupId}) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getUserInviteList(groupId: groupId),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getNotificationList() async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getAllNotification,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> inviteUser({required List<String> userIds, required String groupId}) async {
    Logger.info("invite user: $userIds, groupId: $groupId");
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.inviteUser(groupId: groupId),
      data: {"user_ids": userIds},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> acceptInvitation({required String inviteId}) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.acceptInvitation(inviteId: inviteId),

    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> userNameSetup({required String groupId, required String username}) async {
    return await BaseApiHelper.instance.patch<Map<String, dynamic>>(
      EndPoints.userNameSetup(groupId: groupId),
      data: {"group_username": username},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> rejectInvitation({required String rejectId}) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.rejectInvitation(rejectId: rejectId),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> deleteSingleNotification({required String notificationId}) async {
    return await BaseApiHelper.instance.delete<Map<String, dynamic>>(
      EndPoints.deleteSingleNotification(notificationId: notificationId),
      parser: (_) => {},
    );
  }
  Future<Either<ApiException, Map<String, dynamic>>> deleteAllNotification() async {
    return await BaseApiHelper.instance.delete<Map<String, dynamic>>(
      EndPoints.deleteAllNotification,
      parser: (_) => {},

    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getGroupMembersList({required String groupId}) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.groupMembersList(groupId: groupId),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> leaveGroup({required String groupId}) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      EndPoints.leaveGroup(groupId: groupId),
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> getChatGroupHistory({required String groupId}) async {
    return await BaseApiHelper.instance.get<Map<String, dynamic>>(
      EndPoints.getChatGroupHistory(groupId: groupId),
    );
  }
}