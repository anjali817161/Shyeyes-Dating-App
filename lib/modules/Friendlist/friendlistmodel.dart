class FriendListModel {
  final List<Friend>? friends;

  FriendListModel({this.friends});

  factory FriendListModel.fromJson(Map<String, dynamic> json) {
    return FriendListModel(
      friends: json['friends'] != null
          ? List<Friend>.from(json['friends'].map((x) => Friend.fromJson(x)))
          : [],
    );
  }
}

class Friend {
  final String? id;
  final String? name;
  final int? age;
  final String? profilePic;

  Friend({this.id, this.name, this.age, this.profilePic});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['userId'],
      name: json['name'],
      age: int.tryParse(json['age'].toString()),
      profilePic: json['profilePic'],
    );
  }
}
