import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/chats/controller/chat_controller.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/notification/view/notification_view.dart';
import 'package:shyeyes/modules/widgets/pulse_animation.dart';

class ChatLobbyPage extends StatefulWidget {
  const ChatLobbyPage({super.key});

  @override
  State<ChatLobbyPage> createState() => _ChatLobbyPageState();
}

class _ChatLobbyPageState extends State<ChatLobbyPage> {
  final ChatController controller = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    controller.loadChatList(); // ✅ load previous conversations
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              onChanged: controller.searchChats,
            ),
          ),

          // 🟢 Active users row
          Obx(() {
            final activeUsers = controller.onlineUsers;
            if (activeUsers.isEmpty) {
              return const SizedBox(height: 0);
            }

            return SizedBox(
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
                                backgroundImage: NetworkImage(user.avatarUrl),
                              ),
                            ),
                            // 💚 Blinking online dot
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: BlinkingDot(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.name.split(" ").first,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 8),

          // 💬 Chat list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final chatList = controller.filteredChats.isNotEmpty
                  ? controller.filteredChats
                  : controller.chats;

              if (chatList.isEmpty) {
                return const Center(child: Text("No chats yet."));
              }

              return ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final chat = chatList[index];
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
                        backgroundImage: NetworkImage(chat.avatarUrl),
                      ),
                      title: Text(
                        chat.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: chat.isRead ? Colors.grey : Colors.black,
                          fontWeight: chat.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(chat.time, style: const TextStyle(fontSize: 12)),
                          if (!chat.isRead)
                            const Icon(
                              Icons.circle,
                              color: Colors.blue,
                              size: 10,
                            ),
                        ],
                      ),
                      onTap: () {
                        // ✅ Navigate to ChatScreen
                        Get.to(
                          () => ChatScreen(
                            receiverId: chat.receiverId,
                            receiverName: chat.name,
                            receiverImage: chat.avatarUrl,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
