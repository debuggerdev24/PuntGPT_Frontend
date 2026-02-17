class NotificationModel {

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        type: json["type"],
        isRead: json["is_read"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    NotificationModel({
        required this.id,
        required this.title,
        required this.message,
        required this.type,
        required this.isRead,
        required this.createdAt,
    });
    int id;
    String title;
    String message;
    String type;
    bool isRead;
    DateTime createdAt;

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "type": type,
        "is_read": isRead,
        "created_at": createdAt.toIso8601String(),
    };
}
