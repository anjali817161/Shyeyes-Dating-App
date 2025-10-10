import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/notification/view/notification_view.dart';
import 'package:shyeyes/modules/widgets/pulse_animation.dart';

class ChatLobbyPage extends StatefulWidget {
  const ChatLobbyPage({super.key});

  @override
  State<ChatLobbyPage> createState() => _ChatLobbyPageState();
}

class _ChatLobbyPageState extends State<ChatLobbyPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  // 🔹 Dummy active users list
  final List<Map<String, String>> activeUsers = [
    {
      "name": "Amit",
      "profilePic": "https://randomuser.me/api/portraits/men/31.jpg",
    },
    {
      "name": "Sneha",
      "profilePic": "https://randomuser.me/api/portraits/women/44.jpg",
    },
    {
      "name": "Ravi",
      "profilePic": "https://randomuser.me/api/portraits/men/56.jpg",
    },
    {
      "name": "Neha",
      "profilePic": "https://randomuser.me/api/portraits/women/21.jpg",
    },
  ];

  // 🔹 Dummy chat list
  final List<Map<String, dynamic>> chats = [
    {
      "userName": "Amit Sharma",
      "userId": "1",
      "profilePic": "https://randomuser.me/api/portraits/men/31.jpg",
      "lastMessage": "Hey! How are you?",
      "lastMessageTime": "10:20 AM",
      "isRead": false,
    },
    {
      "userName": "Sneha Kapoor",
      "userId": "2",
      "profilePic": "https://randomuser.me/api/portraits/women/44.jpg",
      "lastMessage": "Let's meet tomorrow.",
      "lastMessageTime": "9:50 AM",
      "isRead": true,
    },
    {
      "userName": "Ravi Verma",
      "userId": "3",
      "profilePic": "https://randomuser.me/api/portraits/men/56.jpg",
      "lastMessage": "Did you check my message?",
      "lastMessageTime": "Yesterday",
      "isRead": false,
    },
    {
      "userName": "Neha Singh",
      "userId": "4",
      "profilePic": "https://randomuser.me/api/portraits/women/21.jpg",
      "lastMessage": "See you soon 💬",
      "lastMessageTime": "Monday",
      "isRead": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredChats = chats
        .where(
          (chat) => chat["userName"].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.secondaryContainer,
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Get.to(() => NotificationsPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search chats...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 🟢 Active users row
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 12),
              scrollDirection: Axis.horizontal,
              itemCount: activeUsers.length,
              itemBuilder: (context, index) {
                final user = activeUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 1,
                              ),
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                user["profilePic"]!,
                              ),
                            ),
                          ),
                          // 💚 Blinking online dot
                          Positioned(bottom: 4, right: 4, child: BlinkingDot()),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user["name"]!,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // 💬 Chat list
          Expanded(
            child: filteredChats.isEmpty
                ? const Center(child: Text("No chats yet."))
                : ListView.builder(
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(chat["profilePic"]!),
                          ),
                          title: Text(
                            chat["userName"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            chat["lastMessage"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: chat["isRead"]
                                  ? Colors.grey
                                  : Colors.black,
                              fontWeight: chat["isRead"]
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                chat["lastMessageTime"],
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (!chat["isRead"])
                                const Icon(
                                  Icons.circle,
                                  color: Colors.blue,
                                  size: 10,
                                ),
                            ],
                          ),
                          onTap: () {
                            // ✅ Navigate to ChatScreen (dummy)
                            Get.to(
                              () => ChatScreen(
                                receiverId: chat["userId"],
                                receiverName: chat["userName"],
                                receiverImage: chat["profilePic"],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
