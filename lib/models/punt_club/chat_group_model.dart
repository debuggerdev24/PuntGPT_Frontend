class ChatGroupModel {
  factory ChatGroupModel.fromJson(Map<String, dynamic> json) => ChatGroupModel(
    id: json["id"],
    name: json["name"],
    unreadMessageCount: json["unread_message_count"],
    isAdmin: json["is_admin"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  ChatGroupModel({
    required this.id,
    required this.name,
    required this.isAdmin,
    required this.unreadMessageCount,
    required this.createdAt,
  });
  int id, unreadMessageCount;
  String name;
  bool isAdmin;
  DateTime createdAt;
}

//*group members model
class GroupMembersModel {
  factory GroupMembersModel.fromJson(Map<String, dynamic> json) =>
      GroupMembersModel(
        userName: json["group_username"],
        joinedAt: DateTime.parse(json["joined_at"]),
      );

  GroupMembersModel({required this.userName, required this.joinedAt});
  String userName;
  DateTime joinedAt;
}
