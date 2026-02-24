import 'package:flutter/cupertino.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';
import 'package:puntgpt_nick/core/utils/app_toast.dart';
import 'package:puntgpt_nick/models/punt_club/chat_group_model.dart';
import 'package:puntgpt_nick/models/punt_club/notification_model.dart';
import 'package:puntgpt_nick/models/punt_club/user_invites_list.dart';
import 'package:puntgpt_nick/service/home/punter_club/punter_club_api_service.dart';

class PuntClubProvider extends ChangeNotifier {
  PuntClubProvider() {
    searchNameCtr = TextEditingController();
    searchNameCtr.addListener(notifyListeners);
  }
  int selectedGroup = 0,notificationCount = 0;
  String groupId = "";
  late final TextEditingController searchNameCtr;
  final TextEditingController clubNameCtr = TextEditingController();
  final TextEditingController usernameCtr = TextEditingController();

  @override
  void dispose() {
    searchNameCtr.removeListener(notifyListeners);
    searchNameCtr.dispose();
    clubNameCtr.dispose();
    super.dispose();
  }

  //* filtered user list for search
  List<UserInvitesList> get filteredUserList {
    final query = searchNameCtr.text.trim().toLowerCase();
    if (userInvitesList == null) return [];
    if (query.isEmpty) return userInvitesList!;
    return userInvitesList!
        .where((u) => u.name.toLowerCase().contains(query))
        .toList();
  }

  List<ChatGroupModel>? chatGroupsList;
  List<UserInvitesList>? userInvitesList;
  List<NotificationModel>? notificationList;
  int _selectedPunters = 0;
  int get selectedPunterWeb => _selectedPunters;
  final Set<int> selectedIds = {};

  void toggleUser(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelectedIds() {
    selectedIds.clear();
    notifyListeners();
  }

  void resetInviteState() {
    selectedIds.clear();
    // isInvitingUser = false;
    notifyListeners();
  }

  void removeNotificationAt(int index) {
    notificationList?.removeAt(index);
    notifyListeners();
  }

  void clearNotificationList() {
    notificationList?.clear();
    notifyListeners();
  }

  set setPunterIndex(int value) {
    _selectedPunters = value;
    notifyListeners();
  }

  //* create chat group
  bool isCreatingChatGroupLoading = false;
  Future<void> createChatGroup({required VoidCallback onSuccess, required Function(String error) onError}) async {
    isCreatingChatGroupLoading = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.createChatGroup(
      data: {"name": clubNameCtr.text},
    );

    response.fold(
      (l) {
        Logger.error("create chat group error: ${l.errorMsg}");
        onError.call(l.errorMsg);
      },
      (r) {
        Logger.info("createChatGroup response: $r");
        onSuccess.call();
        clubNameCtr.clear();
        final data = r["data"];
        final club = (data is Map && data.containsKey("club")) ? data["club"] : data;
        groupId = (club["id"]).toString();
        Logger.info("groupId: $groupId");
        getChatGroups();
      },
    );
    clubNameCtr.clear();
    isCreatingChatGroupLoading = false;
notifyListeners();
  }

  //* get chat groups
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

  //* get users invite list
  Future<void> getUsersInviteList({required String groupId}) async {
    // if (userInvitesList != null) return;
    // userInvitesList = null;
    notifyListeners();
    final response = await PuntClubApiService.instance.getUsersInviteList(
      groupId: groupId,
    );
    response.fold(
      (l) {
        Logger.error("get users invite list error: ${l.errorMsg}");
      },
      (r) {
        userInvitesList = (r["data"] as List)
            .map((e) => UserInvitesList.fromJson(e))
            .toList();
        searchNameCtr.clear();
        notifyListeners();
      },
    );
  }

  //* get notification list
  Future<void> getNotifications() async {
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
        notificationCount = notificationList?.length ?? 0;
        notifyListeners();
      },
    );
  }

  //* invite user
  bool isInvitingUser = false;
  Future<void> inviteUser({
    required List<String> userIds,
    required String groupId,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    isInvitingUser = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.inviteUser(
      userIds: userIds,
      groupId: groupId,
    );

    response.fold(
      (l) {
        Logger.error("invite user error: ${l.errorMsg}");
      },
      (r) {
        // onSuccess.call();
        final int skippedCount = r["data"]["skipped_count"] as int;
        final int totalSelected = selectedIds.length;

        if (skippedCount > 0) {
          final String subject = switch (skippedCount) {
            1 when totalSelected == 1 => "This user is",
            _ when skippedCount == totalSelected => "All users are",
            _ => "$skippedCount users are",
          };
          AppToast.warning(
            context: context,
            message: "$subject already in the group",
          );
        } else {
          AppToast.success(
            context: context,
            message: totalSelected == 1
                ? "Invitation sent successfully"
                : "Invitations sent successfully",
          );
        }
        clearSelectedIds();
      },
    );
    isInvitingUser = false;
    notifyListeners();
  }



  //* delete single notification
  Future<void> deleteSingleNotification({
    required String notificationId,
    required VoidCallback onSuccess,
  }) async {
    final response = await PuntClubApiService.instance.deleteSingleNotification(
      notificationId: notificationId,
    );
    response.fold(
      (l) {
        Logger.error("delete single notification error: ${l.errorMsg}");
      },
      (r) {
        // onSuccess.call();
        // getNotifications();
      },
    );
  }


  //* delete all notification
  bool isDeletingAllNotification = false;
  Future<void> deleteAllNotification() async {
    isDeletingAllNotification = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.deleteAllNotification();
    response.fold(
      (l) {
        Logger.error("delete all notification error: ${l.errorMsg}");
      },
      (r) {
      },
    );
    isDeletingAllNotification = false;
    notifyListeners();
  }

  //* accept invitation
  bool isAcceptingInvitation = false;
  Future<void> acceptInvitation({
    required String inviteId,
    required VoidCallback onSuccess,
  }) async {
    isAcceptingInvitation = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.acceptInvitation(
      inviteId: inviteId,
    );
    response.fold(
      (l) {
        Logger.error("accept invitation error: ${l.errorMsg}");
      },
      (r) {
        onSuccess.call();
        getChatGroups();
        getNotifications();
      },
    );
    isAcceptingInvitation = false;
    notifyListeners();
  }

  //* user name setup
  bool isUserNameSetup = false;
  Future<void> userNameSetup({required String username, required VoidCallback onSuccess}) async {
    isUserNameSetup = true;
    notifyListeners();
    Logger.info("user name setup: $groupId, $username");
    final response = await PuntClubApiService.instance.userNameSetup(groupId: groupId, username: username);
    response.fold(
      (l) {
        Logger.error("user name setup error: ${l.errorMsg}");
      },
      (r) {
        onSuccess.call();
      },
    );
    isUserNameSetup = false;
    notifyListeners();
  }

  //* reject invitation
  bool isRejectingInvitation = false;
  Future<void> rejectInvitation({
    required String rejectId,
    required VoidCallback onSuccess,
  }) async {
    isRejectingInvitation = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.rejectInvitation(
      rejectId: rejectId,
    );
    response.fold(
      (l) {
        Logger.error("reject invitation error: ${l.errorMsg}");
      },
      (r) {
        onSuccess.call();
        getNotifications();
      },
    );
    isRejectingInvitation = false;
    notifyListeners();
  }
}
