class FriendRequestResponse {
  final int requestId;
  final int senderId;
  final String senderUsername;
  final String senderProfilePic;
  final int receiverId;
  final String receiverUsername;
  final String status;
  final String createdAt;

  FriendRequestResponse({
    required this.requestId,
    required this.senderId,
    required this.senderUsername,
    required this.senderProfilePic,
    required this.receiverId,
    required this.receiverUsername,
    required this.status,
    required this.createdAt,
  });

  factory FriendRequestResponse.fromJson(Map<String, dynamic> json) {
    return FriendRequestResponse(
      requestId: json['requestId'] ?? json['id'] ?? 0,
      senderId: json['senderId'] ?? 0,
      senderUsername: json['senderUsername'] ?? '',
      senderProfilePic: json['senderProfilePic'] ?? '',
      receiverId: json['receiverId'] ?? 0,
      receiverUsername: json['receiverUsername'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
