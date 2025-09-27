import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:shyeyes/modules/chats/controller/chat_controller.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/notification/view/notification_view.dart';
import 'package:shyeyes/modules/widgets/pulse_animation.dart';

class ChatLobbyPage extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ChatLobbyPage({super.key});

  // Dummy user for ChatScreen
  UserModel dummyUser = UserModel(
    name: 'Shaan',
    imageUrl: 'https://i.pravatar.cc/150?img=65',
    lastMessage: "Hey, how are you?🥰",
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: GestureDetector(
              onTap: () {
                Get.to(() => NotificationsPage());
              },
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
            onPressed: () {},
          ),
          // IconButton(
          //   icon: const Icon(Icons.edit_outlined, color: Colors.white),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Stories / Active users
          // Stories / Active users
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 12),
              scrollDirection: Axis.horizontal,
              itemCount: controller.chats.length,
              itemBuilder: (context, index) {
                final user = controller.chats[index];
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

                          //  Add blinking green dot
                          Positioned(bottom: 4, right: 4, child: BlinkingDot()),
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
          ),

          const SizedBox(height: 8),

          // Chat list
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.chats.length,
                itemBuilder: (context, index) {
                  final chat = controller.chats[index];
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
                        chat.message,
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
                        // Navigate to chat screen
                     //   Get.to(() => ChatScreen(user: dummyUser));
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

// // Green Pulse Effect Widget
// class ActivePulse extends StatefulWidget {
//   @override
//   _ActivePulseState createState() => _ActivePulseState();
// }

// class _ActivePulseState extends State<ActivePulse>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 70,
//       height: 70,
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return CustomPaint(painter: PulsePainter(_controller.value));
//         },
//       ),
//     );
//   }
// }
