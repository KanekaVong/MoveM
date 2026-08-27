class NotificationResponse {
  final int id;
  final int senderId;
  final String? senderName;
  final String? senderProfilePicture;
  final String? title;
  final String? message;
  final String? notificationType;
  final String? referenceType;
  final String? referenceId;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? readAt;

  NotificationResponse({
    required this.id,
    required this.senderId,
    this.senderName,
    this.senderProfilePicture,
    this.title,
    this.message,
    this.notificationType,
    this.referenceType,
    this.referenceId,
    this.isRead = false,
    this.createdAt,
    this.readAt,
  });

  NotificationResponse copyWith({
    int? id,
    int? senderId,
    String? senderName,
    String? senderProfilePicture,
    String? title,
    String? message,
    String? notificationType,
    String? referenceType,
    String? referenceId,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return NotificationResponse(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderProfilePicture: senderProfilePicture ?? this.senderProfilePicture,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'] as int? ?? 0,
      senderId: json['senderId'] as int? ?? 0,
      senderName: json['senderName'] as String?,
      senderProfilePicture: json['senderProfilePicture'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      notificationType: json['notificationType'] as String?,
      referenceType: json['referenceType'] as String?,
      referenceId: json['referenceId']?.toString(),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'].toString())
          : null,
    );
  }

  String timeAgo() {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 7) {
      return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} mins ago';
    } else {
      return 'Just now';
    }
  }
}
