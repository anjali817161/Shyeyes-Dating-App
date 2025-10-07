import 'dart:convert';

FriendsModel friendsModelFromJson(String str) =>
    FriendsModel.fromJson(json.decode(str));

String friendsModelToJson(FriendsModel data) => json.encode(data.toJson());

class FriendsModel {
  bool? success;
  String? message;
  Data? data;

  FriendsModel({this.success, this.message, this.data});

  factory FriendsModel.fromJson(Map<String, dynamic> json) => FriendsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<Friend>? friends;

  Data({this.friends});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    friends: json["friends"] == null
        ? []
        : List<Friend>.from(json["friends"].map((x) => Friend.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "friends": friends == null
        ? []
        : List<dynamic>.from(friends!.map((x) => x.toJson())),
  };
}

class Friend {
  String? userId;
  String? name;
  int? age;
  String? profilePic;
  String? bio;
  Location? location;
  List<String>? hobbies;
  String? friendshipStatus;
  bool? likedByMe;

  Friend({
    this.userId,
    this.name,
    this.age,
    this.profilePic,
    this.bio,
    this.location,
    this.hobbies,
    this.friendshipStatus,
    this.likedByMe,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
    userId: json["_id"],
    name: json["name"],
    age: json["age"],
    profilePic: json["profilePic"],
    bio: json["bio"],
    location: json["location"] != null
        ? Location.fromJson(json["location"])
        : null,
    hobbies: json["hobbies"] == null ? [] : List<String>.from(json["hobbies"]),
    friendshipStatus: json["friendshipStatus"],
    likedByMe: json["likedByMe"],
  );

  Map<String, dynamic> toJson() => {
    "_id": userId,
    "name": name,
    "age": age,
    "profilePic": profilePic,
    "bio": bio,
    "location": location?.toJson(),
    "hobbies": hobbies == null
        ? []
        : List<dynamic>.from(hobbies!.map((x) => x)),
    "friendshipStatus": friendshipStatus,
    "likedByMe": likedByMe,
  };
}

class Location {
  String? city;
  String? country;

  Location({this.city, this.country});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(city: json["city"], country: json["country"]);

  Map<String, dynamic> toJson() => {"city": city, "country": country};
}
