class NotificationModel {
  // Extracts the shared invite UUID from either the accept or reject URL.
  static final _inviteIdRegex = RegExp(
    r'invite/([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/',
    caseSensitive: false,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final message = json["message"] as String;
    return NotificationModel(
      id: json["id"],
      message: message,
      createdAt: json["created_at"],
      inviteId: _inviteIdRegex.firstMatch(message)?.group(1),
    );
  }

  NotificationModel({
    required this.id,
    required this.message,
    required this.createdAt,
    this.inviteId,
  });

  int id;
  String message, createdAt;

  /// Invite UUID shared by both accept and reject URLs.
  /// Use with [EndPoints.acceptInvitation] and [EndPoints.rejectInvitation].
  String? inviteId;

  bool get hasInvite => inviteId != null;
}
