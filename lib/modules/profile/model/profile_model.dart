import 'dart:convert';

class UserProfileModel {
  bool? status;
  String? message;
  UserData? data;

  UserProfileModel({this.status, this.message, this.data});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  int? id;
  String? uniqueId;
  String? fName;
  String? lName;
  String? fullName;
  String? email;
  String? phone;
  String? dob;
  int? age;
  String? gender;
  String? location;
  String? about;
  String? imageUrl;

  UserData({
    this.id,
    this.uniqueId,
    this.fName,
    this.lName,
    this.fullName,
    this.email,
    this.phone,
    this.dob,
    this.age,
    this.gender,
    this.location,
    this.about,
    this.imageUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      uniqueId: json['unique_id'],
      fName: json['f_name'],
      lName: json['l_name'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      age: json['age'],
      gender: json['gender'],
      location: json['location'],
      about: json['about'],
      imageUrl: json['image_url'],
    );
  }
}

// Edit profile model class

// To parse this JSON data, do
//
//     final editprofile = editprofileFromJson(jsonString);



Editprofile editprofileFromJson(String str) =>
    Editprofile.fromJson(json.decode(str));

String editprofileToJson(Editprofile data) => json.encode(data.toJson());

class Editprofile {
  bool? status;
  String? message;
  Data? data;

  Editprofile({
    this.status,
    this.message,
    this.data,
  });

  factory Editprofile.fromJson(Map<String, dynamic> json) => Editprofile(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? uniqueId;
  String? fName;
  String? lName;
  String? fullName;
  String? email;
  String? phone;
  DateTime? dob;
  int? age;
  String? gender;
  String? location;
  String? about;
  String? status;
  String? imageUrl;
  String? coverPhotoUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.uniqueId,
    this.fName,
    this.lName,
    this.fullName,
    this.email,
    this.phone,
    this.dob,
    this.age,
    this.gender,
    this.location,
    this.about,
    this.status,
    this.imageUrl,
    this.coverPhotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uniqueId: json["unique_id"],
        fName: json["f_name"],
        lName: json["l_name"],
        fullName: json["full_name"],
        email: json["email"],
        phone: json["phone"],
        dob: json["dob"] != null ? DateTime.tryParse(json["dob"]) : null,
        age: json["age"],
        gender: json["gender"],
        location: json["location"],
        about: json["about"],
        status: json["status"],
        imageUrl: json["image_url"],
        coverPhotoUrl: json["cover_photo_url"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unique_id": uniqueId,
        "f_name": fName,
        "l_name": lName,
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "dob": dob != null
            ? "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}"
            : null,
        "age": age,
        "gender": gender,
        "location": location,
        "about": about,
        "status": status,
        "image_url": imageUrl,
        "cover_photo_url": coverPhotoUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

