// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel? editProfileModelFromJson(String str) =>
    str.isNotEmpty ? EditProfileModel.fromJson(json.decode(str)) : null;

String editProfileModelToJson(EditProfileModel? data) =>
    json.encode(data?.toJson() ?? {});

class EditProfileModel {
  bool? success;
  String? message;
  Data? data;

  EditProfileModel({
    this.success,
    this.message,
    this.data,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      EditProfileModel(
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
  EditUser? edituser;

  Data({
    this.edituser,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        edituser: json["user"] != null ? EditUser.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "user": edituser?.toJson(),
      };
}

class EditUser {
  Name? name;
  Location? location;
  Usage? usage;
  int? matchCount;
  String? id;
  String? email;
  String? phoneNo;
  DateTime? dob;
  int? age;
  String? gender;
  String? bio;
  List<String>? hobbies;
  List<dynamic>? photos;
  dynamic profilePic;
  String? status;
  bool? emailVerified;
  dynamic membership;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? friends;
  int? likeCount;

  EditUser({
    this.name,
    this.location,
    this.usage,
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
    this.status,
    this.emailVerified,
    this.membership,
    this.createdAt,
    this.updatedAt,
    this.friends,
    this.likeCount,
  });

 factory EditUser.fromJson(Map<String, dynamic> json) {
  return EditUser(
    name: json["Name"] != null ? Name.fromJson(json["Name"]) : null,
    location: json["location"] != null ? Location.fromJson(json["location"]) : null,
    usage: json["usage"] != null ? Usage.fromJson(json["usage"]) : null,
    matchCount: json["matchCount"],
    id: (json["_id"] ?? json["id"] ?? "").toString().trim(), // ✅ fix here
    email: json["email"],
    phoneNo: json["phoneNo"],
    dob: json["dob"] != null ? DateTime.tryParse(json["dob"]) : null,
    age: json["age"],
    gender: json["gender"],
    bio: json["bio"],
    hobbies: json["hobbies"] != null
        ? List<String>.from(json["hobbies"].map((x) => x))
        : [],
    photos: json["photos"] != null
        ? List<dynamic>.from(json["photos"].map((x) => x))
        : [],
    profilePic: json["profilePic"],
    status: json["status"],
    emailVerified: json["emailVerified"],
    membership: json["membership"],
    createdAt: json["createdAt"] != null
        ? DateTime.tryParse(json["createdAt"])
        : null,
    updatedAt: json["updatedAt"] != null
        ? DateTime.tryParse(json["updatedAt"])
        : null,
    friends: json["friends"] != null
        ? List<String>.from(json["friends"].map((x) => x))
        : [],
    likeCount: json["likeCount"],
  );
}


  Map<String, dynamic> toJson() => {
        "Name": name?.toJson(),
        "location": location?.toJson(),
        "usage": usage?.toJson(),
        "matchCount": matchCount,
        "_id": id,
        "email": email,
        "phoneNo": phoneNo,
        "dob": dob != null
            ? "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
            : null,
        "age": age,
        "gender": gender,
        "bio": bio,
        "hobbies": hobbies != null
            ? List<dynamic>.from(hobbies!.map((x) => x))
            : [],
        "photos": photos != null
            ? List<dynamic>.from(photos!.map((x) => x))
            : [],
        "profilePic": profilePic,
        "status": status,
        "emailVerified": emailVerified,
        "membership": membership,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "friends":
            friends != null ? List<dynamic>.from(friends!.map((x) => x)) : [],
        "likeCount": likeCount,
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

class Usage {
  int? chatSecondsUsed;
  int? audioCallsMade;
  int? videoCallsMade;
  int? requestsSent;

  Usage({
    this.chatSecondsUsed,
    this.audioCallsMade,
    this.videoCallsMade,
    this.requestsSent,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        chatSecondsUsed: json["chatSecondsUsed"],
        audioCallsMade: json["audioCallsMade"],
        videoCallsMade: json["videoCallsMade"],
        requestsSent: json["requestsSent"],
      );

  Map<String, dynamic> toJson() => {
        "chatSecondsUsed": chatSecondsUsed,
        "audioCallsMade": audioCallsMade,
        "videoCallsMade": videoCallsMade,
        "requestsSent": requestsSent,
      };
}
