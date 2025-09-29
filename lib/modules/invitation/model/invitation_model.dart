class RequestsModel {
  List<RequestsResponse>? requests;

  RequestsModel({this.requests});

  RequestsModel.fromJson(Map<String, dynamic> json) {
    if (json['requests'] != null) {
      requests = <RequestsResponse>[];
      json['requests'].forEach((v) {
        requests!.add(RequestsResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (requests != null) {
      data['requests'] = requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestsResponse {
  String? id;
  User1? user1;
  String? user2;
  String? status;
  String? actionBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  RequestsResponse({
    this.id,
    this.user1,
    this.user2,
    this.status,
    this.actionBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  RequestsResponse.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user1 = json['user1'] != null ? User1.fromJson(json['user1']) : null;
    user2 = json['user2'];
    status = json['status'];
    actionBy = json['actionBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    if (user1 != null) data['user1'] = user1!.toJson();
    data['user2'] = user2;
    data['status'] = status;
    data['actionBy'] = actionBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

class User1 {
  String? id;
  Name? name;
  String? email;
  int? age;
  String? profilePic;

  User1({this.id, this.name, this.email, this.age, this.profilePic});

  User1.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['Name'] != null ? Name.fromJson(json['Name']) : null;
    email = json['email'];
    age = json['age'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    if (name != null) data['Name'] = name!.toJson();
    data['email'] = email;
    data['age'] = age;
    data['profilePic'] = profilePic;
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
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
