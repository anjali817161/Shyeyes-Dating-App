class SearchUserModel {
  List<SearchUser>? users;

  SearchUserModel({this.users});

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      users: json["users"] != null
          ? List<SearchUser>.from(
              json["users"].map((x) => SearchUser.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "users": users?.map((x) => x.toJson()).toList(),
    };
  }
}

class SearchUser {
  String? id;
  String? email;
  String? profilePic;
  Name? name;

  SearchUser({this.id, this.email, this.profilePic, this.name});

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      id: json["_id"],
      email: json["email"],
      profilePic: json["profilePic"],
      name: json["Name"] != null ? Name.fromJson(json["Name"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "profilePic": profilePic,
      "Name": name?.toJson(),
    };
  }

  String get fullName =>
      "${name?.firstName ?? ""} ${name?.lastName ?? ""}".trim();
}

class Name {
  String? firstName;
  String? lastName;

  Name({this.firstName, this.lastName});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
