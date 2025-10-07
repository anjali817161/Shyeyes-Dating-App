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
    return {"requests": requests?.map((x) => x.toJson()).toList()};
  }
}

class Request {
  String? id;
  String? name;
  Recipient? recipient; 
  String? status;
  String? actionBy;
  String? sentAt;

  Request({
    this.id,
    this.name,
    this.recipient,
    this.status,
    this.actionBy,
    this.sentAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      name: json['name'],
      recipient: json['to'] != null ? Recipient.fromJson(json['to']) : null,
      status: json['status'],
      actionBy: json['actionBy'],
      sentAt: json['sentAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "to": recipient?.toJson(),
      "status": status,
      "actionBy": actionBy,
      "sentAt": sentAt,
    };
  }
}

class Recipient {
  String? id;
  Name? name;
  String? email;
  int? age;
  String? profilePic;

  Recipient({this.id, this.name, this.email, this.age, this.profilePic});

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
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
    return Name(firstName: json['firstName'], lastName: json['lastName']);
  }

  Map<String, dynamic> toJson() {
    return {"firstName": firstName, "lastName": lastName};
  }
}
