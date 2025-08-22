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
