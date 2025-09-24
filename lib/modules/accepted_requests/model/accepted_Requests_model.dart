// lib/modules/accepted/model/accepted_request_model.dart

class AcceptedRequestModel {
  List<AcceptedRequest>? requests;

  AcceptedRequestModel({this.requests});

  AcceptedRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['requests'] != null) {
      requests = <AcceptedRequest>[];
      json['requests'].forEach((v) {
        requests!.add(AcceptedRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AcceptedRequest {
  String? id;
  String? from;
  ToUser? to;
  String? status;
  String? createdAt;
  String? updatedAt;

  AcceptedRequest({
    this.id,
    this.from,
    this.to,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  AcceptedRequest.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    from = json['from'];
    to = json['to'] != null ? ToUser.fromJson(json['to']) : null;
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = this.id;
    data['from'] = this.from;
    if (this.to != null) {
      data['to'] = this.to!.toJson();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ToUser {
  Name? name;
  String? id;
  String? email;
  String? age;
  String? profilePic;

  ToUser({this.name, this.id, this.email, this.age, this.profilePic});

  ToUser.fromJson(Map<String, dynamic> json) {
    name = json['Name'] != null ? Name.fromJson(json['Name']) : null;
    id = json['_id'];
    age = json['age'];
    email = json['email'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.name != null) {
      data['Name'] = this.name!.toJson();
    }
    data['_id'] = this.id;
    data['age'] = this.age;
    data['email'] = this.email;
    data['profilePic'] = this.profilePic;
    return data;
  }
}

class Name {
  String? firstName;
  String? lastName;

  Name({this.firstName, this.lastName});

  Name.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
