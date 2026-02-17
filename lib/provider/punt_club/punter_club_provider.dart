import 'package:flutter/cupertino.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';
import 'package:puntgpt_nick/models/punt_club/chat_group_model.dart';
import 'package:puntgpt_nick/models/punt_club/notification_model.dart';
import 'package:puntgpt_nick/models/punt_club/user_invites_list.dart';
import 'package:puntgpt_nick/service/home/punt_club/punt_club_api_service.dart';

class PuntClubProvider extends ChangeNotifier {
  int selectedGroup = 0;
  String grpName = "", grpId = "";
  TextEditingController searchNameCtr = TextEditingController(),
      clubNameCtr = TextEditingController();

  List<ChatGroupModel>? chatGroupsList;
  List<UserInvitesList>? userInvitesList;
  List<NotificationModel>? notificationList;
  int _selectedPunters = 0;
  int get selectedPunterWeb => _selectedPunters;

  set setPunterIndex(int value) {
    _selectedPunters = value;
    notifyListeners();
  }

  bool isCreatingChatGroupLoading = false;
  Future<void> createChatGroup({required VoidCallback onSuccess}) async {
    isCreatingChatGroupLoading = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.createChatGroup(
      data: {"name": clubNameCtr.text},
    );
    response.fold(
      (l) {
        Logger.error("create chat group error: ${l.errorMsg}");
      },
      (r) {
        onSuccess.call();
        clubNameCtr.clear();
        final club = r["data"]["club"];
        grpName = club["name"];
        grpId = club["id"];
        getChatGroups();
      },
    );
    isCreatingChatGroupLoading = false;
    notifyListeners();
  }

  Future<void> getChatGroups() async {
    chatGroupsList = null;
    notifyListeners();
    final response = await PuntClubApiService.instance.getChatGroups();
    response.fold(
      (l) {
        Logger.error("get chat groups error: ${l.errorMsg}");
      },
      (r) {
        chatGroupsList = (r["data"] as List)
            .map((e) => ChatGroupModel.fromJson(e))
            .toList();

        notifyListeners();
      },
    );
  }

  Future<void> getUsersInviteList({
    required String groupId,
    required String grpName,
  }) async {
    userInvitesList = null;
    notifyListeners();
    final response = await PuntClubApiService.instance.getUsersInviteList(
      groupId: groupId,
      grpName: grpName,
    );
    response.fold(
      (l) {
        Logger.error("get users invite list error: ${l.errorMsg}");
      },
      (r) {
        userInvitesList = (r["data"] as List)
            .map((e) => UserInvitesList.fromJson(e))
            .toList();
        notifyListeners();
      },
    );
  }

  Future<void> getNotificationList() async {
    notificationList = null;
    notifyListeners();
    final response = await PuntClubApiService.instance.getNotificationList();
    response.fold(
      (l) {
        Logger.error("get notification list error: ${l.errorMsg}");
      },
      (r) {
        notificationList = (r["data"] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
        notifyListeners();
      },
    );
  }
}
