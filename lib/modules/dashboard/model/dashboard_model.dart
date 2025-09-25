import 'dart:convert';

ActiveUsersModel activeUsersModelFromJson(String str) =>
    ActiveUsersModel.fromJson(json.decode(str));

String activeUsersModelToJson(ActiveUsersModel data) =>
    json.encode(data.toJson());

class ActiveUsersModel {
  bool? success;
  String? message;
  Data? data;

  ActiveUsersModel({this.success, this.message, this.data});

  factory ActiveUsersModel.fromJson(Map<String, dynamic> json) =>
      ActiveUsersModel(
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
  List<Users>? users;
  int? page;
  int? limit;
  int? count;

  Data({this.users, this.page, this.limit, this.count});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    users: json["users"] != null
        ? List<Users>.from(json["users"].map((x) => Users.fromJson(x)))
        : null,
    page: json["page"],
    limit: json["limit"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "users": users != null
        ? List<dynamic>.from(users!.map((x) => x.toJson()))
        : null,
    "page": page,
    "limit": limit,
    "count": count,
  };
}

class Users {
  String? id;
  int? age;
  Location? location;
  String? bio;
  List<String>? hobbies;
  dynamic profilePic;
  String? friendshipStatus;
  int? mutualFriendsCount;
  String? name;

  Users({
    this.id,
    this.age,
    this.location,
    this.bio,
    this.hobbies,
    this.profilePic,
    this.friendshipStatus,
    this.mutualFriendsCount,
    this.name,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["_id"],
    age: json["age"],
    location: json["location"] != null
        ? Location.fromJson(json["location"])
        : null,
    bio: json["bio"],
    hobbies: json["hobbies"] != null
        ? List<String>.from(json["hobbies"].map((x) => x))
        : null,
    profilePic: json["profilePic"],
    friendshipStatus: json["friendshipStatus"],
    mutualFriendsCount: json["mutualFriendsCount"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "age": age,
    "location": location?.toJson(),
    "bio": bio,
    "hobbies": hobbies != null
        ? List<dynamic>.from(hobbies!.map((x) => x))
        : null,
    "profilePic": profilePic,
    "friendshipStatus": friendshipStatus,
    "mutualFriendsCount": mutualFriendsCount,
    "name": name,
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
