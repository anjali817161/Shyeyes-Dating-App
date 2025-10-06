// To parse this JSON data, do
//
//     final aboutModel = aboutModelFromJson(jsonString);

import 'dart:convert';

AboutModel? aboutModelFromJson(String str) =>
    AboutModel.fromJson(json.decode(str));

String aboutModelToJson(AboutModel? data) => json.encode(data?.toJson());

class AboutModel {
  bool? success;
  String? message;
  User? user;

  AboutModel({
    this.success,
    this.message,
    this.user,
  });

  factory AboutModel.fromJson(Map<String, dynamic>? json) => AboutModel(
        success: json?["success"],
        message: json?["message"],
        user: json?["user"] != null ? User.fromJson(json?["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  Name? name;
  Location? location;
  Usage? usage;
  List<dynamic>? friends;
  int? matchCount;
  String? id;
  String? email;
  String? phoneNo;
  String? dob;
  int? age;
  String? gender;
  String? bio;
  List<String>? hobbies;
  List<dynamic>? photos;
  dynamic profilePic;
  String? friendshipStatus; // ✅ Add this

  bool? emailVerified;
  dynamic membership;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likeCount;
  final bool? likedByMe;

  User({
    this.name,
    this.location,
    this.usage,
    this.friends,
    this.matchCount,
    this.id,
    this.email,
    this.phoneNo,
    this.dob,
    this.age,
    this.gender,
    this.bio,
    this.hobbies,
    this.photos,
    this.profilePic,
    this.friendshipStatus,
    this.emailVerified,
    this.membership,
    this.createdAt,
    this.updatedAt,
    this.likeCount,
    this.likedByMe,
  });

  factory User.fromJson(Map<String, dynamic>? json) => User(
        name: json?["Name"] != null ? Name.fromJson(json?["Name"]) : null,
        location:
            json?["location"] != null ? Location.fromJson(json?["location"]) : null,
        usage: json?["usage"] != null ? Usage.fromJson(json?["usage"]) : null,
        friends: json?["friends"] != null
            ? List<dynamic>.from(json?["friends"].map((x) => x))
            : [],
        matchCount: json?["matchCount"],
        id: json?["_id"],
        email: json?["email"],
        phoneNo: json?["phoneNo"],
        dob: json?["dob"],
        age: json?["age"],
        gender: json?["gender"],
        bio: json?["bio"],
        hobbies: json?["hobbies"] != null
            ? List<String>.from(json?["hobbies"].map((x) => x))
            : [],
        photos: json?["photos"] != null
            ? List<dynamic>.from(json?["photos"].map((x) => x))
            : [],
        profilePic: json?["profilePic"],
        friendshipStatus: json?["friendshipStatus"],
        emailVerified: json?["emailVerified"],
        membership: json?["membership"],
        createdAt:
            json?["createdAt"] != null ? DateTime.tryParse(json?["createdAt"]) : null,
        updatedAt:
            json?["updatedAt"] != null ? DateTime.tryParse(json?["updatedAt"]) : null,
        likeCount: json?["likeCount"],
        likedByMe: json?["likedByMe"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name?.toJson(),
        "location": location?.toJson(),
        "usage": usage?.toJson(),
        "friends": friends != null ? List<dynamic>.from(friends!.map((x) => x)) : [],
        "matchCount": matchCount,
        "_id": id,
        "email": email,
        "phoneNo": phoneNo,
        "dob": dob,
        "age": age,
        "gender": gender,
        "bio": bio,
        "hobbies": hobbies != null ? List<dynamic>.from(hobbies!.map((x) => x)) : [],
        "photos": photos != null ? List<dynamic>.from(photos!.map((x) => x)) : [],
        "profilePic": profilePic,
        "friendshipStatus": friendshipStatus,
        "emailVerified": emailVerified,
        "membership": membership,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "likeCount": likeCount,
        "likedByMe": likedByMe,
      };
}

class Location {
  String? street;
  String? city;
  String? state;
  String? country;

  Location({
    this.street,
    this.city,
    this.state,
    this.country,
  });

  factory Location.fromJson(Map<String, dynamic>? json) => Location(
        street: json?["street"],
        city: json?["city"],
        state: json?["state"],
        country: json?["country"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "country": country,
      };
}

class Name {
  String? firstName;
  String? lastName;

  Name({
    this.firstName,
    this.lastName,
  });

  factory Name.fromJson(Map<String, dynamic>? json) => Name(
        firstName: json?["firstName"],
        lastName: json?["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
      };
}

class Usage {
  int? requestsSent;
  int? chatSecondsUsed;
  int? audioCallsMade;
  int? videoCallsMade;

  Usage({
    this.requestsSent,
    this.chatSecondsUsed,
    this.audioCallsMade,
    this.videoCallsMade,
  });

  factory Usage.fromJson(Map<String, dynamic>? json) => Usage(
        requestsSent: json?["requestsSent"],
        chatSecondsUsed: json?["chatSecondsUsed"],
        audioCallsMade: json?["audioCallsMade"],
        videoCallsMade: json?["videoCallsMade"],
      );

  Map<String, dynamic> toJson() => {
        "requestsSent": requestsSent,
        "chatSecondsUsed": chatSecondsUsed,
        "audioCallsMade": audioCallsMade,
        "videoCallsMade": videoCallsMade,
      };
}
