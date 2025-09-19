// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel? data) =>
    json.encode(data?.toJson());

class UserProfileModel {
  String? message;
  User? user;

  UserProfileModel({
    this.message,
    this.user,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        message: json["message"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  Name? name;
  Location? location;
  String? id;
  String? email;
  String? phoneNo;
  DateTime? dob;
  int? age;
  String? gender;
  String? bio;
  List<String>? hobbies;
  List<String>? photos;
  String? status;
  bool? emailVerified;
  dynamic membership;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? otp;
  DateTime? otpExpires;

  User({
    this.name,
    this.location,
    this.id,
    this.email,
    this.phoneNo,
    this.dob,
    this.age,
    this.gender,
    this.bio,
    this.hobbies,
    this.photos,
    this.status,
    this.emailVerified,
    this.membership,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.otp,
    this.otpExpires,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["Name"] != null ? Name.fromJson(json["Name"]) : null,
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,
        id: json["_id"],
        email: json["email"],
        phoneNo: json["phoneNo"],
        dob: json["dob"] != null ? DateTime.tryParse(json["dob"]) : null,
        age: json["age"],
        gender: json["gender"],
        bio: json["bio"],
        hobbies: json["hobbies"] != null
            ? List<String>.from(json["hobbies"].map((x) => x))
            : null,
        photos: json["photos"] != null
            ? List<String>.from(json["photos"].map((x) => x))
            : null,
        status: json["status"],
        emailVerified: json["emailVerified"],
        membership: json["membership"],
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
        v: json["__v"],
        otp: json["otp"],
        otpExpires: json["otpExpires"] != null
            ? DateTime.tryParse(json["otpExpires"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "Name": name?.toJson(),
        "location": location?.toJson(),
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
            : null,
        "photos": photos != null
            ? List<dynamic>.from(photos!.map((x) => x))
            : null,
        "status": status,
        "emailVerified": emailVerified,
        "membership": membership,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "otp": otp,
        "otpExpires": otpExpires?.toIso8601String(),
      };
}

class Location {
  String? street;
  String? city;
  String? state;
  String? country;
  String? postalCode;

  Location({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postalCode"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "country": country,
        "postalCode": postalCode,
      };
}

class Name {
  String? firstName;
  String? lastName;

  Name({
    this.firstName,
    this.lastName,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
      };
}
