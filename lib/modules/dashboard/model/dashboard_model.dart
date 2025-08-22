class ActiveUserModel {
  final int id;
  final String name;
  final String? image;

  ActiveUserModel({required this.id, required this.name, this.image});

  factory ActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ActiveUserModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}


class BestMatchModel {
  final int? userId;
  final String? name;
  final int? age;
  final String? img;

  BestMatchModel({
    this.userId,
    this.name,
    this.age,
    this.img,
  });

  factory BestMatchModel.fromJson(Map<String, dynamic> json) {
    return BestMatchModel(
      userId: json['userid'],
      name: json['name'],
      age: json['age'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userid": userId,
      "name": name,
      "age": age,
      "img": img,
    };
  }
}

