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
  String? profilePic;
  String? fullName;
  int? age;

  SearchUser({this.id, this.email, this.profilePic, this.fullName, this.age});

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    // Handle different possible keys for id
    String? userId = json["_id"] ?? json["id"];

    // Handle fullName: if direct, use it; else construct from Name object
    String? name;
    if (json["fullName"] != null) {
      name = json["fullName"];
    } else if (json["Name"] != null && json["Name"] is Map) {
      final first = json["Name"]["firstName"] ?? "";
      final last = json["Name"]["lastName"] ?? "";
      name = "$first $last".trim();
      if (name.isEmpty) name = null;
    }

    return SearchUser(
      id: userId,
      email: json["email"],
      profilePic: json["profilePic"],
      fullName: name,
      age: json["age"] != null ? int.tryParse(json["age"].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "profilePic": profilePic,
      "fullName": fullName,
      "age": age,
    };
  }
}
