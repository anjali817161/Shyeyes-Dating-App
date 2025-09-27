class showlikes {
  List<Rlikes>? rlikes;

  showlikes({this.rlikes});

  showlikes.fromJson(Map<String, dynamic> json) {
    if (json['Rlikes'] != null) {
      rlikes = <Rlikes>[];
      json['Rlikes'].forEach((v) {
        rlikes!.add(new Rlikes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rlikes != null) {
      data['Rlikes'] = this.rlikes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rlikes {
  String? sId;
  Liker? liker;
  String? liked;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? friendshipStatus;

  Rlikes(
      {this.sId,
      this.liker,
      this.liked,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.friendshipStatus});

  Rlikes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    liker = json['liker'] != null ? new Liker.fromJson(json['liker']) : null;
    liked = json['liked'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    friendshipStatus = json['friendshipStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.liker != null) {
      data['liker'] = this.liker!.toJson();
    }
    data['liked'] = this.liked;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['friendshipStatus'] = this.friendshipStatus;
    return data;
  }
}

class Liker {
  String? sId;
  Name? name;
  int? age;
  String? profilePic;
  String? status;

  Liker({this.sId, this.name, this.age, this.profilePic, this.status});

  Liker.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['Name'] != null ? new Name.fromJson(json['Name']) : null;
    age = json['age'];
    profilePic = json['profilePic'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.name != null) {
      data['Name'] = this.name!.toJson();
    }
    data['age'] = this.age;
    data['profilePic'] = this.profilePic;
    data['status'] = this.status;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
