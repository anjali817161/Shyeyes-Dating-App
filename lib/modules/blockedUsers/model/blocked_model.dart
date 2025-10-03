class BlockedUserModel {
  final String id;
  final String email;
  final String? profilePic;
  final DateTime blockedAt;

  BlockedUserModel({
    required this.id,
    required this.email,
    this.profilePic,
    required this.blockedAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: json['id'],
      email: json['email'],
      profilePic: json['profilePic'],
      blockedAt: DateTime.parse(json['blockedAt']),
    );
  }
}

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
      count: json['count'],
    );
  }
}
