class InviteResponse {
  final int id;
  final String inviteUrl;
  final String createdAt;
  final String? expiresAt;

  InviteResponse({
    required this.id,
    required this.inviteUrl,
    required this.createdAt,
    this.expiresAt,
  });

  factory InviteResponse.fromJson(Map<String, dynamic> json) {
    return InviteResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      inviteUrl: json['inviteUrl']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inviteUrl': inviteUrl,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }
}
