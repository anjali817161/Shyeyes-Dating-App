class Activeusermodel {
  String? message;
  List<Users>? users;

  Activeusermodel({this.message, this.users});

  Activeusermodel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? sId;
  String? name;
  int? age;
  String? profilePic;
  Location? location;

  Users({this.sId, this.name, this.age, this.profilePic, this.location});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    age = json['age'];
    profilePic = json['profilePic'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['profilePic'] = this.profilePic;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Location {
  String? city;
  String? country;
  String? street;
  String? state;

  Location({this.city, this.country, this.street, this.state});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    street = json['street'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['street'] = this.street;
    data['state'] = this.state;
    return data;
  }
}
