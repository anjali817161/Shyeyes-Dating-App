import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import '../../profile/controller/profile_controller.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController());
  final ProfileController profileController =
      Get.find(); // ✅ Get logged-in user
  final TextEditingController msgCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  late String currentUserId;
  late String receiverId;
  late String receiverName;
  late String receiverImage;

  @override
  void initState() {
    super.initState();
    // _connectUser();

    // Get current user ID from ProfileController
    currentUserId = profileController.profile2?.value?.data?.edituser?.id ?? "";
    receiverId = widget.receiverId;
    receiverName = widget.receiverName;
    receiverImage = widget.receiverImage;

    // Initialize chat
    controller.initChat(
      receiverId: receiverId,
      receiverName: receiverName,
      receiverImage: receiverImage,
    );
  }

  void _sendMessage() {
    final text = msgCtrl.text.trim();
    if (text.isEmpty) return;

    // Send message using controller
    controller.sendMessage(text);
    msgCtrl.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollCtrl.hasClients) {
        scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: receiverImage.startsWith("http")
                  ? NetworkImage(receiverImage)
                  : AssetImage(receiverImage) as ImageProvider,
            ),

            const SizedBox(width: 10),
            Text(receiverName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text("Let's break the ice by saying hii👋"),
                );
              }

              return ListView.builder(
                controller: scrollCtrl,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.from == currentUserId;

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe
                            ? theme.colorScheme.primary
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg.message,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: theme.colorScheme.primary,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
