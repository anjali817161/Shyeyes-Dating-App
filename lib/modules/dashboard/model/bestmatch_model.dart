import 'dart:convert';

BestMatchResponse bestMatchResponseFromJson(String str) =>
    BestMatchResponse.fromJson(json.decode(str));

String bestMatchResponseToJson(BestMatchResponse data) =>
    json.encode(data.toJson());

class BestMatchResponse {
  final bool? success;
  final String? message;
  final BestMatchData? data;

  BestMatchResponse({this.success, this.message, this.data});

  factory BestMatchResponse.fromJson(Map<String, dynamic> json) {
    return BestMatchResponse(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null ? BestMatchData.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class BestMatchData {
  final List<BestmatchModel>? matches;
  final int? page;
  final int? limit;
  final int? count;

  BestMatchData({this.matches, this.page, this.limit, this.count});

  factory BestMatchData.fromJson(Map<String, dynamic> json) {
    return BestMatchData(
      matches: json["matches"] != null
          ? List<BestmatchModel>.from(
              json["matches"].map((x) => BestmatchModel.fromJson(x)),
            )
          : null,
      page: json["page"],
      limit: json["limit"],
      count: json["count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "matches": matches != null
        ? List<dynamic>.from(matches!.map((x) => x.toJson()))
        : null,
    "page": page,
    "limit": limit,
    "count": count,
  };
}

class BestmatchModel {
  final String? id;
  final int? age;
  final String? bio;
  final String? profilePic;
  final List<String>? hobbies;
  final String? name;
  final String? status;
  final List<Friend>? friendsList;
  final int? mutualFriendsCount;
  final bool? likedByMe;
  final Location? location;

  BestmatchModel({
    this.id,
    this.age,
    this.bio,
    this.profilePic,
    this.hobbies,
    this.name,
    this.status,
    this.friendsList,
    this.mutualFriendsCount,
    this.likedByMe,
    this.location,
  });

  factory BestmatchModel.fromJson(Map<String, dynamic> json) {
    String? fullName;
    if (json["Name"] != null) {
      final fn = json["Name"]["firstName"] ?? "";
      final ln = json["Name"]["lastName"] ?? "";
      fullName = "$fn $ln".trim();
    }

    return BestmatchModel(
      id: json["_id"],
      age: json["age"],
      bio: json["bio"],
      profilePic: json["profilePic"],
      hobbies: (json["hobbies"] as List?)?.map((e) => e.toString()).toList(),
      name: fullName,
      status: json["friendshipStatus"],
      friendsList: (json["friendsList"] as List?)
          ?.map((e) => Friend.fromJson(e))
          .toList(),
      mutualFriendsCount: json["mutualFriendsCount"],
      likedByMe: json["likedByMe"],
      location: json["location"] != null && (json["location"] as Map).isNotEmpty
          ? Location.fromJson(json["location"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "age": age,
    "bio": bio,
    "profilePic": profilePic,
    "hobbies": hobbies,
    "name": name,
    "friendshipStatus": status,
    "friendsList": friendsList != null
        ? friendsList!.map((e) => e.toJson()).toList()
        : null,
    "mutualFriendsCount": mutualFriendsCount,
    "likedByMe": likedByMe,
    "location": location?.toJson(),
  };
}

class Friend {
  final String? id;
  final FriendName? name;
  final String? profilePic;

  Friend({this.id, this.name, this.profilePic});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json["_id"],
      name: json["Name"] != null ? FriendName.fromJson(json["Name"]) : null,
      profilePic: json["profilePic"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Name": name?.toJson(),
    "profilePic": profilePic,
  };
}

class FriendName {
  final String? firstName;
  final String? lastName;

  FriendName({this.firstName, this.lastName});

  factory FriendName.fromJson(Map<String, dynamic> json) {
    return FriendName(firstName: json["firstName"], lastName: json["lastName"]);
  }

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
  };
}

class Location {
  final String? street;
  final String? city;
  final String? state;
  final String? country;

  Location({this.street, this.city, this.state, this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: json["street"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
    );
  }

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "country": country,
  };
}
