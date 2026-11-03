import 'friend_response.dart';

class PublicAchievementItem {
  final String name;
  final String? icon;
  final String? imageUrl;

  const PublicAchievementItem({
    required this.name,
    this.icon,
    this.imageUrl,
  });

  factory PublicAchievementItem.fromJson(Map<String, dynamic> json) {
    return PublicAchievementItem(
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      icon: json['icon']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString(),
    );
  }
}

class PublicUserProfileResponse {
  final String id;
  final String username;
  final String firstname;
  final String lastname;
  final String? bio;
  final String? profilePic;
  final String? friendStatus;
  final int taskCompleted;
  final int challengesCompleted;
  final int tripPlans;
  final int friendsCount;
  final List<PublicAchievementItem> recentAchievements;
  final List<FriendResponse> mutualFriends;

  const PublicUserProfileResponse({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    this.bio,
    this.profilePic,
    this.friendStatus,
    this.taskCompleted = 0,
    this.challengesCompleted = 0,
    this.tripPlans = 0,
    this.friendsCount = 0,
    this.recentAchievements = const [],
    this.mutualFriends = const [],
  });

  String get displayName {
    final fullName = '$firstname $lastname'.trim();
    if (fullName.isNotEmpty) return fullName;
    if (username.isNotEmpty) return username;
    return 'User';
  }

  bool get isRequestPending {
    final status = (friendStatus ?? '').toUpperCase();
    return status.contains('PENDING') || status == 'REQUEST_SENT' || status == 'OUTGOING';
  }

  bool get isFriend {
    final status = (friendStatus ?? '').toUpperCase();
    return status == 'ACCEPTED' || status == 'FRIEND' || status == 'FRIENDS';
  }

  PublicUserProfileResponse copyWith({
    String? friendStatus,
  }) {
    return PublicUserProfileResponse(
      id: id,
      username: username,
      firstname: firstname,
      lastname: lastname,
      bio: bio,
      profilePic: profilePic,
      friendStatus: friendStatus ?? this.friendStatus,
      taskCompleted: taskCompleted,
      challengesCompleted: challengesCompleted,
      tripPlans: tripPlans,
      friendsCount: friendsCount,
      recentAchievements: recentAchievements,
      mutualFriends: mutualFriends,
    );
  }

  factory PublicUserProfileResponse.fromJson(Map<String, dynamic> json) {
    final root = _unwrap(json);
    final user = root['user'] is Map
        ? Map<String, dynamic>.from(root['user'] as Map)
        : root;
    final stats = root['statistics'] is Map
        ? Map<String, dynamic>.from(root['statistics'] as Map)
        : (root['stats'] is Map ? Map<String, dynamic>.from(root['stats'] as Map) : root);

    return PublicUserProfileResponse(
      id: (user['id'] ?? user['userId'] ?? '').toString(),
      username: user['username']?.toString() ?? '',
      firstname: user['firstname']?.toString() ?? user['firstName']?.toString() ?? '',
      lastname: user['lastname']?.toString() ?? user['lastName']?.toString() ?? '',
      bio: user['bio']?.toString() ?? root['bio']?.toString(),
      profilePic: user['profilePic']?.toString() ?? user['profilePicture']?.toString(),
      friendStatus: (root['friendStatus'] ?? user['friendStatus'] ?? root['friendshipStatus'])?.toString(),
      taskCompleted: _readInt(stats, const [
        'taskCompleted',
        'tasksCompleted',
        'completedTasks',
        'taskCount',
      ]),
      challengesCompleted: _readInt(stats, const [
        'challengesCompleted',
        'completedChallenges',
        'challengeCount',
      ]),
      tripPlans: _readInt(stats, const [
        'tripPlans',
        'tripPlanCount',
        'trips',
      ]),
      friendsCount: () {
        final count = _readInt(root, const [
          'friendsCount',
          'friendCount',
          'totalFriends',
        ], fallbackMap: user);
        if (count > 0) return count;
        final friends = _readFriends(root['friends'] ?? user['friends']);
        return friends.length;
      }(),
      recentAchievements: _readAchievements(root['recentAchievements'] ?? root['achievements']),
      mutualFriends: _readFriends(
        root['mutualFriends'] ?? root['mutuals'] ?? root['friends'] ?? user['friends'],
      ),
    );
  }

  static Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return json;
  }

  static int _readInt(
    Map<String, dynamic> map,
    List<String> keys, {
    Map<String, dynamic>? fallbackMap,
  }) {
    for (final key in keys) {
      final value = map[key] ?? fallbackMap?[key];
      if (value is num) return value.toInt();
      if (value != null) {
        final parsed = int.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }
    return 0;
  }

  static List<PublicAchievementItem> _readAchievements(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => PublicAchievementItem.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.name.isNotEmpty)
        .toList();
  }

  static List<FriendResponse> _readFriends(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => FriendResponse.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
