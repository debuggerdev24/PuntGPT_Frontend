/// Model for a single message in Punter Club group chat.
/// Maps to server JSON: type "message", "message_edited", "message_deleted".
/// Used for both WebSocket broadcasts and REST chat history API.
class ClubChatMessageModel {
  ClubChatMessageModel({
    required this.messageId,
    required this.senderId,
    required this.senderUsername,
    required this.content,
    required this.createdAt,
    this.isEdited = false,
    this.editedAt,
  });

  /// Parses new message broadcast from server.
  /// { "type": "message", "message_id": 42, "sender_id": 101, "sender_username": "...", "content": "...", "created_at": "...", "is_edited": false }
  /// Also supports REST history format with "id" instead of "message_id".
  factory ClubChatMessageModel.fromNewMessageJson(Map<String, dynamic> json) {
    return ClubChatMessageModel(
      messageId: _intFrom(json['message_id'] ?? json['id']),
      senderId: _intFrom(json['sender_id']),
      senderUsername: (json['sender_username'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: _parseDateTime(json['created_at']),
      isEdited: json['is_edited'] == true,
      editedAt: json['edited_at'] != null ? _parseDateTime(json['edited_at']) : null,
    );
  }

  final int messageId;
  final int senderId;
  final String senderUsername;
  String content;
  final DateTime createdAt;
  bool isEdited;
  DateTime? editedAt;

  /// Returns true if message can be edited (within 15 minutes of creation).
  bool get canEdit {
    final diff = DateTime.now().difference(createdAt);
    return diff.inMinutes < 15;
  }

  static int _intFrom(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static DateTime _parseDateTime(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    try {
      return DateTime.parse(v.toString()).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }
}
