// To parse this JSON data, do
//
//     final friendsModel = friendsModelFromJson(jsonString);

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

  Friend({this.userId, this.name, this.age, this.profilePic});

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
    userId: json["userId"],
    name: json["name"],
    age: json["age"],
    profilePic: json["profilePic"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "age": age,
    "profilePic": profilePic,
  };
}
