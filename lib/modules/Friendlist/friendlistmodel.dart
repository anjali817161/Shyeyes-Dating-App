class Friend {
  final String name;
  final int age;
  final String imageUrl;

  Friend({
    required this.name,
    required this.age,
    required this.imageUrl,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['name'] ?? "Unknown",
      age: json['age'] ?? 0,
      imageUrl: json['image'] ?? "https://i.pravatar.cc/150?img=1",
    );
  }
}
