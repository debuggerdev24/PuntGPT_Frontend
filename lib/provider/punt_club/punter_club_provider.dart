import 'dart:async';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/punt_club/chat_group_model.dart';
import 'package:puntgpt_nick/models/punt_club/club_chat_message_model.dart';
import 'package:puntgpt_nick/models/punt_club/notification_model.dart';
import 'package:puntgpt_nick/models/punt_club/user_invites_list.dart';
import 'package:puntgpt_nick/services/punter_club/chat_socket_service.dart';
import 'package:puntgpt_nick/services/punter_club/punter_club_api_service.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';

class PuntClubProvider extends ChangeNotifier {
  PuntClubProvider() {
    searchNameCtr = TextEditingController();
    searchNameCtr.addListener(notifyListeners);
  }

  /// Subscription to ChatService events. Cancel in dispose.
  StreamSubscription<Map<String, dynamic>>? _chatEventSubscription;
  int selectedGroup = 0, notificationCount = 0;
  bool _isAdmin = false;
  String groupId = "";
  late final TextEditingController searchNameCtr;
  final TextEditingController clubNameCtr = TextEditingController();
  final TextEditingController usernameCtr = TextEditingController();

  @override
  void dispose() {
    disconnectChat();
    _chatEventSubscription?.cancel();
    searchNameCtr.removeListener(notifyListeners);
    searchNameCtr.dispose();
    clubNameCtr.dispose();
    super.dispose();
  }

  //* ========== CHAT (WebSocket) ==========
  /// List of messages in the current group chat.
  List<ClubChatMessageModel>? chatMessages;

  /// Typing indicators: sender_id -> sender_username.
  final Map<int, String> typingUsers = {};

  /// Typing users excluding current user (so we don't show "You are typing").

  /// Call this with our display name (e.g. from profile or group username) to filter own typing.
  // void setMyDisplayName(String? name) {
  //   if (name != null && name.trim().isNotEmpty) _myDisplayName = name.trim();
  // }

  /// Tracks which group we're chatting in, to avoid clearing messages when re-entering.
  String? _currentChatGroupId;

  /// Our display name in this group (e.g. "Meera") - used to filter own typing indicator.
  // String? _myDisplayName;

  /// Current user id for "is mine" check. From LocaleStorageService.
  int get _currentUserId => LocaleStorageService.userId;
  bool get isAdmin => _isAdmin;

  /// True if a message was sent by the current user.
  bool isMyMessage(ClubChatMessageModel m) => m.senderId == _currentUserId;

  /// Connects to chat WebSocket for the selected group and loads history.
  /// Keeps existing messages when re-entering the same group.
  Future<void> connectChat() async {
    final groupId = selectedGroupId ?? this.groupId;
    if (groupId.isEmpty) return;

    final isSameGroup = groupId == _currentChatGroupId;
    if (!isSameGroup) {
      chatMessages = null;

      typingUsers.clear();
      _currentChatGroupId = groupId;
      notifyListeners();
      await _loadChatHistory(groupId);
    }
    typingUsers.clear();

    Logger.info('[PuntClubProvider] connecting to chat: $groupId');
    ChatService.instance.connect(groupId: groupId);
    _chatEventSubscription?.cancel();
    _chatEventSubscription = ChatService.instance.events.listen(_onChatEvent);
    notifyListeners();
  }

  /// Loads chat history from REST API before WebSocket takes over.
  Future<void> _loadChatHistory(String gid) async {
    // chatMessages = [];

    final result = await PuntClubApiService.instance.getChatGroupHistory(
      groupId: gid,
    );
    result.fold(
      (l) =>
          Logger.error('[PuntClubProvider] load chat history: ${l.errorMsg}'),
      (r) {
        final data = r["data"]['history'] ?? [];
        if (data.isEmpty) {
          chatMessages = [];
          return;
        }
        final chats = List<ClubChatMessageModel>.from(
          (data as List).map((e) => ClubChatMessageModel.fromJson(e)),
        );
        chatMessages = chats;
        Logger.info(
          '[PuntClubProvider] chat messages: ${chatMessages!.length}',
        );
      },
    );
    notifyListeners();
  }

  //* Handles incoming WebSocket events by "type" field.
  void _onChatEvent(Map<String, dynamic> e) {
    final type = (e['type'] ?? '').toString();
    switch (type) {
      case 'message':
        final m = ClubChatMessageModel.fromJson(e);
        chatMessages ??= [];
        chatMessages!.add(m);
        if (!isMyMessage(m)) {
          getChatGroups();
        }
        break;
      case 'message_edited':
        _handleMessageEdited(e);
        break;
      case 'message_deleted':
        _handleMessageDeleted(e);
        break;
      case 'typing':
        _handleTyping(e);
        break;
      case 'stop_typing':
        _handleStopTyping(e);
        break;
      case 'error':
        _handleError(e);
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void _handleMessageEdited(Map<String, dynamic> e) {
    final id = _intFrom(e['message_id']);
    final content = (e['content'] ?? '').toString();
    final editedAt = e['edited_at'] != null
        ? DateTime.tryParse(e['edited_at'].toString())
        : null;
    for (final m in chatMessages!) {
      if (m.messageId == id) {
        m.content = content;
        m.isEdited = true;
        if (editedAt != null) m.editedAt = editedAt;
        break;
      }
    }
  }

  void _handleMessageDeleted(Map<String, dynamic> e) {
    final id = _intFrom(e['message_id']);
    chatMessages!.removeWhere((m) => m.messageId == id);
  }

  void _handleTyping(Map<String, dynamic> e) {
    Logger.info('[PuntClubProvider] typing: ${e.toString()}}');
    final senderId = _intFrom(e['sender_id']);

    final username = (e['sender_username'] ?? '').toString().trim();
    final isMe = senderId == _currentUserId;
    if (!isMe) typingUsers[senderId] = username;
    // Logger.info('[PuntClubProvider] typing users: ${typingUsers.toString()}}');
    // Logger.info(
    //   '[PuntClubProvider] other users typing: ${otherUsersTyping.toString()}}',
    // );
    Logger.info(
      '[PuntClubProvider] user Id from storage: ${_currentUserId.toString()}}',
    );
  }

  // Map<int, String> get otherUsersTyping {
  //   //* typingUsers data:
  //   //* typing users: {126: Meera}}
  //   final result = <int, String>{};
  //   for (final e in typingUsers.entries) {
  //     final isMe =
  //         e.key == _currentUserId ||
  //         (_myDisplayName != null &&
  //             _myDisplayName!.isNotEmpty &&
  //             e.value.trim().toLowerCase() == _myDisplayName!.toLowerCase());
  //     if (!isMe) result[e.key] = e.value;
  //   }
  //   return result;
  // }

  void _handleStopTyping(Map<String, dynamic> e) {
    final senderId = _intFrom(e['sender_id']);
    typingUsers.remove(senderId);
  }

  void _handleError(Map<String, dynamic> e) {
    final msg = (e['message'] ?? 'Unknown error').toString();
    Logger.error('[PuntClubProvider] Chat error: $msg');
  }

  static int _intFrom(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  /// Disconnects from chat. Keeps messages so they persist when re-entering.
  void disconnectChat() {
    _chatEventSubscription?.cancel();
    _chatEventSubscription = null;
    ChatService.instance.disconnect();
    typingUsers.clear();
    notifyListeners();
  }

  /// Sends a new message.
  void sendChatMessage(String content) {
    ChatService.instance.sendMessage(content);
  }

  /// Edits an existing message (own messages only, within 15 min).
  void editChatMessage(int messageId, String content) {
    ChatService.instance.sendEdit(messageId, content);
  }

  /// Deletes a message.
  void deleteChatMessage(int messageId) {
    ChatService.instance.sendDelete(messageId);
  }

  /// Notifies server that user started typing.
  void sendTyping() {
    ChatService.instance.sendTyping();
  }

  /// Notifies server that user stopped typing.
  void sendStopTyping() {
    ChatService.instance.sendStopTyping();
  }

  //* ========== END CHAT ==========

  List<ChatGroupModel>? chatGroupsList;
  List<UserInvitesList>? userInvitesList;
  List<NotificationModel>? notificationList;
  List<GroupMembersModel>? groupMembersList;
  int _selectedPunters = 0;
  int get selectedPunterWeb => _selectedPunters;
  final Set<int> selectedIds = {};
  String? selectedGroupId;

  set setSelectedChatGroupIndex(int value) {
    selectedGroup = value;
    selectedGroupId = chatGroupsList![selectedGroup].id.toString();
    _isAdmin = chatGroupsList![selectedGroup].isAdmin;
    Logger.info("selectedGroupId: $selectedGroupId");
  }

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
    // notifyListeners();
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
  Future<void> createChatGroup({
    required VoidCallback onSuccess,
    required Function(String error) onError,
  }) async {
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

        final data = r["data"];
        final club = (data is Map && data.containsKey("club"))
            ? data["club"]
            : data;
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

  //* get chat group history
  // Future<void> getChatGroupHistory({required String groupId}) async {
  //   chatGroupHistoryList = null;
  //   notifyListeners();
  //   final response = await PuntClubApiService.instance.getChatGroupHistory(
  //     groupId: groupId,
  //   );
  // }

  //* get users invite list
  Future<void> getUsersInviteList({required String groupId}) async {
    // if (userInvitesList != null) return;
    userInvitesList = null;
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

  //* filtered user list for search
  List<UserInvitesList> get filteredUserList {
    final query = searchNameCtr.text.trim().toLowerCase();
    if (userInvitesList == null) return [];
    if (query.isEmpty) return [];
    return userInvitesList!
        .where((u) => u.name.toLowerCase().contains(query))
        .toList();
  }

  //* get notification list
  Future<void> getNotifications() async {
    if (LocaleStorageService.acccessToken.isEmpty) return;
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
        getUsersInviteList(groupId: groupId);
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
    response.fold((l) {
      Logger.error("delete all notification error: ${l.errorMsg}");
    }, (r) {});
    isDeletingAllNotification = false;
    notifyListeners();
  }

  //* accept invitation
  bool isAcceptingInvitation = false;
  Future<void> acceptInvitation({
    required String inviteId,
    required VoidCallback onSuccess,
    required Function(String error) onFailed,
  }) async {
    isAcceptingInvitation = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.acceptInvitation(
      inviteId: inviteId,
    );
    response.fold(
      (l) {
        Logger.error("accept invitation error: ${l.errorMsg}");
        final errorMsg = l.errorMsg.toLowerCase();
        if (errorMsg.contains("invalid") || errorMsg.contains("expired")) {
          onFailed.call("Invitation is expired");
        }
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
  bool isUserNameSetupLoading = false;
  Future<void> userNameSetup({required VoidCallback onSuccess}) async {
    isUserNameSetupLoading = true;
    notifyListeners();

    Logger.info(
      "user name setup: $selectedGroupId, ${usernameCtr.text.trim()}",
    );
    final response = await PuntClubApiService.instance.userNameSetup(
      groupId: selectedGroupId!,
      username: usernameCtr.text.trim(),
    );
    response.fold(
      (l) {
        Logger.error("user name setup error: ${l.errorMsg}");
      },
      (r) async {
        // final newName = usernameCtr.text.trim();
        // if (newName.isNotEmpty) {
        //   setMyDisplayName(newName);
        // }
        // Reconnect chat socket so backend picks up updated name
        disconnectChat();
        await connectChat();
        onSuccess.call();
      },
    );
    usernameCtr.clear();
    isUserNameSetupLoading = false;
    notifyListeners();
  }

  //* reject invitation
  // bool isRejectingInvitation = false;
  Future<void> rejectInvitation({
    required String rejectId,
    required VoidCallback onSuccess,
  }) async {
    // isRejectingInvitation = true;
    notificationList = null;
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
    // isRejectingInvitation = false;
    // notifyListeners();
  }

  //* get group members list
  Future<void> getGroupMembersList({required String groupId}) async {
    groupMembersList = null;
    notifyListeners();
    final response = await PuntClubApiService.instance.getGroupMembersList(
      groupId: groupId,
    );
    response.fold(
      (l) {
        Logger.error("get group members list error: ${l.errorMsg}");
      },
      (r) {
        groupMembersList = ((r["data"] as List).isNotEmpty)
            ? (r["data"] as List)
                  .map((e) => GroupMembersModel.fromJson(e))
                  .toList()
            : [];
        notifyListeners();
      },
    );
    notifyListeners();
  }

  //* leave group
  bool isLeavingGroup = false;
  Future<void> leaveGroup({required VoidCallback onSuccess}) async {
    isLeavingGroup = true;
    notifyListeners();
    final response = await PuntClubApiService.instance.leaveGroup(
      groupId: selectedGroupId!,
    );
    response.fold(
      (l) {
        Logger.error("leave group error: ${l.errorMsg}");
      },
      (r) {
        onSuccess.call();
        getChatGroups();
      },
    );
    isLeavingGroup = false;
    notifyListeners();
  }
}
