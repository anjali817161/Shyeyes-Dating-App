import 'dart:convert';

EditProfileModel? editProfileModelFromJson(String str) =>
    str.isNotEmpty ? EditProfileModel.fromJson(json.decode(str)) : null;

String editProfileModelToJson(EditProfileModel? data) =>
    json.encode(data?.toJson() ?? {});

class EditProfileModel {
  String? message;
  User? user;

  EditProfileModel({this.message, this.user});

  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      EditProfileModel(
        message: json["message"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {"message": message, "user": user?.toJson()};
}

class User {
  Name? name;
  Location? location;
  String? id;
  String? email;
  String? phoneNo;
  String? dob; // keep dob as String
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
    this.profilePic,
    this.status,
    this.emailVerified,
    this.membership,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["Name"] != null ? Name.fromJson(json["Name"]) : null,
    location: json["location"] != null
        ? Location.fromJson(json["location"])
        : null,
    id: json["_id"],
    email: json["email"],
    phoneNo: json["phoneNo"],
    dob: json["dob"], // direct assign
    age: json["age"],
    gender: json["gender"],
    bio: json["bio"],
    hobbies: json["hobbies"] != null
        ? List<String>.from(json["hobbies"].map((x) => x))
        : null,
    photos: json["photos"] != null
        ? List<dynamic>.from(json["photos"].map((x) => x))
        : null,
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
  );

  Map<String, dynamic> toJson() => {
    "Name": name?.toJson(),
    "location": location?.toJson(),
    "_id": id,
    "email": email,
    "phoneNo": phoneNo,
    "dob": dob, // send as string only
    "age": age,
    "gender": gender,
    "bio": bio,
    "hobbies": hobbies != null
        ? List<dynamic>.from(hobbies!.map((x) => x))
        : null,
    "photos": photos != null ? List<dynamic>.from(photos!.map((x) => x)) : null,
    "profilePic": profilePic,
    "status": status,
    "emailVerified": emailVerified,
    "membership": membership,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
