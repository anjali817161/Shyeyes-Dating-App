class BestmatchModel {
  final String? id;
  final String? email;
  final String? phoneNo;
  final String? dob;
  final int? age;
  final String? gender;
  final String? bio;
  final String? status;
  final bool? emailVerified;
  final String? profilePic;
  final List<String>? photos;
  final List<String>? hobbies;
  final String? name; // now just a string
  final Location? location;

  BestmatchModel({
    this.id,
    this.email,
    this.phoneNo,
    this.dob,
    this.age,
    this.gender,
    this.bio,
    this.status,
    this.emailVerified,
    this.profilePic,
    this.photos,
    this.hobbies,
    this.name,
    this.location,
  });

  factory BestmatchModel.fromJson(Map<String, dynamic> json) {
    return BestmatchModel(
      id: json["_id"],
      email: json["email"],
      phoneNo: json["phoneNo"],
      dob: json["dob"],
      age: json["age"],
      gender: json["gender"],
      bio: json["bio"],
      status: json["status"],
      emailVerified: json["emailVerified"],
      profilePic: json["profilePic"],
      photos: (json["photos"] as List?)?.map((e) => e.toString()).toList(),
      hobbies: (json["hobbies"] as List?)?.map((e) => e.toString()).toList(),
      name: json["name"], // now just directly assign
      location: json["location"] != null
          ? Location.fromJson(json["location"])
          : null,
    );
  }
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
}
