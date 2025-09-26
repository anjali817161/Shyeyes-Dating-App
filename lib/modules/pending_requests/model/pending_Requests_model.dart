// To parse this JSON data:
// final requestsResponse = requestsResponseFromJson(jsonString);

import 'dart:convert';

RequestsResponse requestsResponseFromJson(String str) =>
    RequestsResponse.fromJson(json.decode(str));

String requestsResponseToJson(RequestsResponse data) =>
    json.encode(data.toJson());

class RequestsResponse {
  List<Request>? requests;

  RequestsResponse({this.requests});

  factory RequestsResponse.fromJson(Map<String, dynamic> json) =>
      RequestsResponse(
        requests: json["requests"] == null
            ? []
            : List<Request>.from(
                json["requests"].map((x) => Request.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "requests": requests == null
        ? []
        : List<dynamic>.from(requests!.map((x) => x.toJson())),
  };
}

class Request {
  String? id;
  String? user1;
  User2? user2;
  String? status;
  String? actionBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Request({
    this.id,
    this.user1,
    this.user2,
    this.status,
    this.actionBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["_id"],
    user1: json["user1"],
    user2: json["user2"] == null ? null : User2.fromJson(json["user2"]),
    status: json["status"],
    actionBy: json["actionBy"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user1": user1,
    "user2": user2?.toJson(),
    "status": status,
    "actionBy": actionBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class User2 {
  String? id;
  Name? name;
  String? email;
  int? age;
  String? profilePic;

  User2({this.id, this.age, this.name, this.email, this.profilePic});

  factory User2.fromJson(Map<String, dynamic> json) => User2(
    id: json["_id"],
    age: int.tryParse(json["age"].toString()),
    name: json["Name"] == null ? null : Name.fromJson(json["Name"]),
    email: json["email"],
    profilePic: json["profilePic"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "age": age,
    "Name": name?.toJson(),
    "email": email,
    "profilePic": profilePic,
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
