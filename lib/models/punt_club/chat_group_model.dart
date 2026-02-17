class ChatGroupModel {
  factory ChatGroupModel.fromJson(Map<String, dynamic> json) => ChatGroupModel(
    id: json["id"],
    name: json["name"],
    unreadMessageCount: json["unread_message_count"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  ChatGroupModel({
    required this.id,
    required this.name,
    required this.unreadMessageCount,
    required this.createdAt,
  });
  int id, unreadMessageCount;
  String name;
  DateTime createdAt;
}
