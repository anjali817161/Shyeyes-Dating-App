class ReceivedRequest {
  final String? id;
  final Sender? sender;
  final String? receiverId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  ReceivedRequest({
    this.id,
    this.sender,
    this.receiverId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ReceivedRequest.fromJson(Map<String, dynamic> json) {
    return ReceivedRequest(
      id: json['_id'],
      sender: json['user1'] != null
          ? Sender.fromJson(json['user1'])
          : null, // 👈 FIXED
      receiverId: json['user2'], // 👈 FIXED
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Sender {
  final String? id;
  final String? email;
  final String? profilePic;
  final String? firstName;
  final String? lastName;

  Sender({this.id, this.email, this.profilePic, this.firstName, this.lastName});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'],
      email: json['email'],
      profilePic: json['profilePic'],
      firstName: json['Name']?['firstName'], // 👈 Correct mapping
      lastName: json['Name']?['lastName'],
    );
  }

  String get fullName => "${firstName ?? ''} ${lastName ?? ''}".trim();
}
