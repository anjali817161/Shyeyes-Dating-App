class PendingNewRequestModel {
  List<Request>? requests;

  PendingNewRequestModel({this.requests});

  factory PendingNewRequestModel.fromJson(Map<String, dynamic> json) {
    return PendingNewRequestModel(
      requests: json['requests'] != null
          ? List<Request>.from(json['requests'].map((x) => Request.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "requests": requests?.map((x) => x.toJson()).toList(),
    };
  }
}

class Request {
  String? id;
  String? name;
  From? from;
  String? status;
  String? actionBy;
  String? sentAt;

  Request({
    this.id,
    this.name,
    this.from,
    this.status,
    this.actionBy,
    this.sentAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      name: json['name'],
      from: json['from'] != null ? From.fromJson(json['from']) : null,
      status: json['status'],
      actionBy: json['actionBy'],
      sentAt: json['sentAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "from": from?.toJson(),
      "status": status,
      "actionBy": actionBy,
      "sentAt": sentAt,
    };
  }
}

class From {
  String? id;
  Name? name;
  String? email;
  int? age;
  String? profilePic;

  From({
    this.id,
    this.name,
    this.email,
    this.age,
    this.profilePic,
  });

  factory From.fromJson(Map<String, dynamic> json) {
    return From(
      id: json['_id'],
      name: json['Name'] != null ? Name.fromJson(json['Name']) : null,
      email: json['email'],
      age: json['age'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "Name": name?.toJson(),
      "email": email,
      "age": age,
      "profilePic": profilePic,
    };
  }
}

class Name {
  String? firstName;
  String? lastName;

  Name({this.firstName, this.lastName});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
