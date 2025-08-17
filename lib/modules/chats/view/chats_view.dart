import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [
    "Hey, how are you? 💬",
    "I was thinking about you 💖",
    "Let’s catch up soon!",
  ];

  final TextEditingController controller = TextEditingController();

  void sendMessage() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add(controller.text.trim());
        controller.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Show dialog after 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      final theme = Theme.of(context);
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => Dialog(
            shape: HeartShapeBorder(),
            backgroundColor: theme.colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: theme.colorScheme.primary,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Free Limit Exceeded',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your free time is over. Please subscribe to continue.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) =>
                            const SubscriptionBottomSheet(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Subscribe Now',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.user.imageUrl)),
            const SizedBox(width: 12),
            Text(widget.user.name),
          ],
        ),
      ),
      body: Stack(
        children: [
          /// 🔹 Background Lottie Animation
          Positioned.fill(
            child: Opacity(
              opacity: 0.7, // keep it light
              child: Lottie.asset(
              'assets/lotties/heart_fly.json', // replace with your Lottie file
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),

          /// 🔹 Chat Content
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final isMe = index % 2 == 0;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isMe ? theme.colorScheme.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          messages[index],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Input Box
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 6),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          hintText: "Type a message 💌",
                          hintStyle:
                              TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: theme.colorScheme.secondary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color:
                                  theme.colorScheme.primary.withOpacity(0.4),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color:
                                  theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
