class BlockedUserResponse {
  final List<BlockedUserModel> blockedUsers;
  final int count;

  BlockedUserResponse({
    required this.blockedUsers,
    required this.count,
  });

  factory BlockedUserResponse.fromJson(Map<String, dynamic> json) {
    return BlockedUserResponse(
      blockedUsers: (json['blockedUsers'] as List)
          .map((e) => BlockedUserModel.fromJson(e))
          .toList(),
      count: json['count'] ?? 0,
    );
  }
}

class BlockedUserModel {
  final String id;
  final String name;
  final String? profilePic;
  final DateTime blockedAt;

  BlockedUserModel({
    required this.id,
    required this.name,
    this.profilePic,
    required this.blockedAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown User',
      profilePic: json['profilePic'],
      blockedAt: DateTime.parse(json['blockedAt']),
    );
  }
}
