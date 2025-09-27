class alllikessent {
  List<Likes>? likes;

  alllikessent({this.likes});

  alllikessent.fromJson(Map<String, dynamic> json) {
    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(new Likes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Likes {
  String? sId;
  String? liker;
  Liked? liked;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? friendshipStatus;

  Likes(
      {this.sId,
      this.liker,
      this.liked,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.friendshipStatus});

  Likes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    liker = json['liker'];
    liked = json['liked'] != null ? new Liked.fromJson(json['liked']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    friendshipStatus = json['friendshipStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['liker'] = this.liker;
    if (this.liked != null) {
      data['liked'] = this.liked!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['friendshipStatus'] = this.friendshipStatus;
    return data;
  }
}

class Liked {
  String? sId;
  Name? name;
  int? age;
  Location? location;
  String? profilePic;
  String? status;

  Liked(
      {this.sId,
      this.name,
      this.age,
      this.location,
      this.profilePic,
      this.status});

  Liked.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['Name'] != null ? new Name.fromJson(json['Name']) : null;
    age = json['age'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
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
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
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

class Location {
  String? street;
  String? city;
  String? state;
  String? country;

  Location({this.street, this.city, this.state, this.country});

  Location.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}
