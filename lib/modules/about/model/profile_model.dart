import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class ProfileModel {
  final bool status;
  final String message;
  final UserProfile data;

  ProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json['status'],
      message: json['message'],
      data: UserProfile.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}
class UserProfile {
  final int id;
  final String uniqueId;
  final String fName;
  final String lName;
  final String fullName;
  final String email;
  final String phone;
  final String dob;
  final int age;
  final String gender;
  final String location;
  final String about;
  final String status;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    required this.id,
    required this.uniqueId,
    required this.fName,
    required this.lName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.age,
    required this.gender,
    required this.location,
    required this.about,
    required this.status,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
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
      status: json['status'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'f_name': fName,
      'l_name': lName,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'dob': dob,
      'age': age,
      'gender': gender,
      'location': location,
      'about': about,
      'status': status,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}


