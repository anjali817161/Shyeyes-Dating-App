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
    return {"users": users?.map((x) => x.toJson()).toList()};
  }
}

class SearchUser {
  String? id;
  String? email;
  dynamic profilePic;
  String? fullName;
  int? age;
  String? location;

  SearchUser({
    this.id,
    this.email,
    this.profilePic,
    this.fullName,
    this.age,
    this.location,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    String? userId = json["_id"] ?? json["id"];

    String? name;
    if (json["fullName"] != null) {
      name = json["fullName"];
    } else if (json["Name"] != null && json["Name"] is Map) {
      final first = json["Name"]["firstName"] ?? "";
      final last = json["Name"]["lastName"] ?? "";
      name = "$first $last".trim();
      if (name.isEmpty) name = null;
    } else if (json["firstName"] != null) {
      final first = json["firstName"] ?? "";
      final last = json["lastName"] ?? "";
      name = "$first $last".trim();
      if (name.isEmpty) name = null;
    }

    String? location;
    if (json["location"] is Map && json["location"]["city"] != null) {
      location = json["location"]["city"];
    }

    return SearchUser(
      id: userId,
      email: json["email"],
      profilePic: json["profilePic"],
      fullName: name,
      age: json["age"] != null ? int.tryParse(json["age"].toString()) : null,
      location: location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "profilePic": profilePic,
      "fullName": fullName,
      "age": age,
      "location": location,
    };
  }

  // Override equals and hashCode to allow for easy deduplication
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
