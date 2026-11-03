class TripReminderResponse {
  final int id;
  final DateTime? remindAt;
  final String? type;
  final bool sent;

  TripReminderResponse({
    required this.id,
    this.remindAt,
    this.type,
    required this.sent,
  });

  factory TripReminderResponse.fromJson(Map<String, dynamic> json) {
    return TripReminderResponse(
      id: json['id'],
      remindAt: json['remindAt'] != null
          ? DateTime.tryParse(
              json['remindAt'].toString(),
            )
          : null,
      type: json['type']?.toString(),
      sent: json['sent'] ?? false,
    );
  }
}
