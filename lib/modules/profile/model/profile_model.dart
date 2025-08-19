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
