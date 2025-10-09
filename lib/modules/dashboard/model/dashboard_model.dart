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
  String? gender;
  Location? location;
  String? bio;
  List<String>? hobbies;
  List<String>? photos;
  dynamic profilePic;
  String? friendshipStatus;
  List<Friend>? friendsList;
  int? mutualFriendsCount;
  bool likedByMe;
  Name? name;

  Users({
    this.id,
    this.age,
    this.gender,
    this.location,
    this.bio,
    this.hobbies,
    this.photos,
    this.profilePic,
    this.friendshipStatus,
    this.friendsList,
    this.mutualFriendsCount,
    this.likedByMe = false,
    this.name,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["_id"].toString(),
    age: json["age"],
    gender: json["gender"],
    location: json["location"] != null
        ? Location.fromJson(json["location"])
        : null,
    bio: json["bio"],
    hobbies: json["hobbies"] != null
        ? List<String>.from(json["hobbies"].map((x) => x))
        : null,
    photos: json["photos"] != null
        ? List<String>.from(json["photos"].map((x) => x))
        : null,
    profilePic: json["profilePic"],
    friendshipStatus: json["friendshipStatus"],
    friendsList: json["friendsList"] != null
        ? List<Friend>.from(json["friendsList"].map((x) => Friend.fromJson(x)))
        : null,
    mutualFriendsCount: json["mutualFriendsCount"],
    likedByMe: json["likedByMe"] ?? false,
    name: json["Name"] != null ? Name.fromJson(json["Name"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "age": age,
    "gender": gender,
    "location": location?.toJson(),
    "bio": bio,
    "hobbies": hobbies != null
        ? List<dynamic>.from(hobbies!.map((x) => x))
        : null,
    "photos": photos != null ? List<dynamic>.from(photos!.map((x) => x)) : null,
    "profilePic": profilePic,
    "friendshipStatus": friendshipStatus,
    "friendsList": friendsList != null
        ? List<dynamic>.from(friendsList!.map((x) => x.toJson()))
        : null,
    "mutualFriendsCount": mutualFriendsCount,
    "likedByMe": likedByMe,
    "Name": name?.toJson(),
  };
}

class Name {
  String? firstName;
  String? lastName;

  Name({this.firstName, this.lastName});

  factory Name.fromJson(Map<String, dynamic> json) =>
      Name(firstName: json["firstName"], lastName: json["lastName"]);

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
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

class Friend {
  String? id;
  Name? name;
  String? profilePic;

  Friend({this.id, this.name, this.profilePic});

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
    id: json["_id"],
    name: json["Name"] != null ? Name.fromJson(json["Name"]) : null,
    profilePic: json["profilePic"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Name": name?.toJson(),
    "profilePic": profilePic,
  };
}
