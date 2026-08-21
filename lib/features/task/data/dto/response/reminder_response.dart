class ReminderResponse {
  final int id;
  final String remindAt;
  final String type;
  final bool sent;

  ReminderResponse({
    required this.id,
    required this.remindAt,
    required this.type,
    required this.sent,
  });

  factory ReminderResponse.fromJson(Map<String, dynamic> json) {
    return ReminderResponse(
      id: json['id'] ?? 0,
      remindAt: json['remindAt'] ?? '',
      type: json['type'] ?? '',
      sent: json['sent'] ?? false,
    );
  }
}
