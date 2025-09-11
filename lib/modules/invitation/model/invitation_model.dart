// models/received_request_model.dart
class ReceivedRequest {
  final int id;
  final int senderId;
  final int receiverId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Sender sender;

  ReceivedRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
  });

  factory ReceivedRequest.fromJson(Map<String, dynamic> json) {
    return ReceivedRequest(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      sender: Sender.fromJson(json['sender']),
    );
  }
}

class Sender {
  final int id;
  final String uniqueId;
  final String fName;
  final String lName;
  final String email;
  final String phone;
  final String dob;
  final String? img;
  final String? coverPhoto;
  final int age;
  final String gender;
  final String location;
  final String about;
  final String status;
  final String fullName;

  Sender({
    required this.id,
    required this.uniqueId,
    required this.fName,
    required this.lName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.img,
    required this.coverPhoto,
    required this.age,
    required this.gender,
    required this.location,
    required this.about,
    required this.status,
    required this.fullName,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      uniqueId: json['unique_id'],
      fName: json['f_name'],
      lName: json['l_name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      img: json['img'],
      coverPhoto: json['cover_photo'],
      age: json['age'],
      gender: json['gender'],
      location: json['location'],
      about: json['about'],
      status: json['status'],
      fullName: json['full_name'],
    );
  }
}
