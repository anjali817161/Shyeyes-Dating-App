




import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final int age;
  final bool isActive;
  final String imageUrl;

  const UserCard({
    required this.name,
    required this.age,
    required this.isActive,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isActive)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 12),
                      SizedBox(width: 4),
                      Text(
                        "Recently active",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Icon(Icons.star, color: Colors.lightBlueAccent),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text("$name, $age", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
