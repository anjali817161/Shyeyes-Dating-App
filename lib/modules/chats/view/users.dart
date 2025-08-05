import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';

class ProfileListPage extends StatefulWidget {
  const ProfileListPage({super.key});

  @override
  State<ProfileListPage> createState() => _ProfileListPageState();
}

class _ProfileListPageState extends State<ProfileListPage> {
  int _selectedIndex = 0;
  final theme = Theme.of(Get.context!);

  // Dummy profiles
  final List<Map<String, String>> profiles = [
    {'name': 'Riya Chaudhary', 'image': 'https://i.pravatar.cc/150?img=1'},
    {'name': 'Rohit Sharma', 'image': 'https://i.pravatar.cc/150?img=2'},
    {'name': 'Neha Mehta', 'image': 'https://i.pravatar.cc/150?img=3'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // You can add more navigation logic here for other tabs
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dummy user for ChatScreen
    UserModel dummyUser = UserModel(
      name: 'Shaan',
      imageUrl: 'https://i.pravatar.cc/150?img=65',
      lastMessage: "Hey, how are you?🥰",
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(profile['image']!),
              ),
              title: Text(profile['name']!),
              trailing: ElevatedButton(
                onPressed: () {
                  Get.to(() => ChatScreen(user: dummyUser));
                  // Navigate to chat screen with dummy user
                  // Get.to(() => ChatScreen(user: UserModel(name: profile['name']!, imageUrl: profile['image']!)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text(
                  'Chat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   selectedItemColor: theme.colorScheme.primary,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profiles'),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
    );
  }
}
