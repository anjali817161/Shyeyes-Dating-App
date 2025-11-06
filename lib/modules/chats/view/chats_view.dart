import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/profile/controller/current_plan_controller.dart';
import 'package:shyeyes/modules/widgets/Zego_service.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import '../controller/chat_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../about/controller/block_controller.dart';
import '../../blockedUsers/controller/blocked_controller.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final bool isOnline;
  final DateTime? lastSeen;

  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    this.isOnline = false,
    this.lastSeen,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ChatController controller = Get.put(ChatController());
  final ProfileController profileController = Get.find();
  final TextEditingController msgCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();
  final ActivePlanController activePlanController = Get.find();
  final FriendController friendController = Get.put(FriendController());
  final BlockController blockController = Get.put(BlockController());
  final BlockedUserController blockedController = Get.put(BlockedUserController());

  late String currentUserId;
  late String receiverId;
  late String receiverName;
  late String receiverImage;
  late bool isOnline;
  late DateTime? lastSeen;
  Timer? _refreshTimer;

  // Light animation controllers
  late AnimationController _bubbleController;
  late AnimationController _floatingController;

  // Refresh chat data with loading indicator
  Future<void> refreshChat() async {
    await controller.initChat(
      receiverId: receiverId,
      receiverName: receiverName,
      receiverImage: receiverImage,
      receiverUser: receiverUser,
    );
  }

  // Silent refresh without loading indicator
  Future<void> silentRefresh() async {
    if (!mounted) return;

    // Fetch messages without showing loading state
    await controller.fetchMessages(receiverId);

    // Update friendship status
    final isFriend = friendController.friends.any(
      (friend) => friend.userId == receiverId,
    );
    if (mounted) {
      setState(() {
        friendshipStatus = isFriend ? "friend" : "none";
      });
    }
  }

  late Animation<double> _bubbleAnimation;
  late Animation<double> _floatingAnimation;

  late dynamic receiverUser;
  late String friendshipStatus;

  @override
  void initState() {
    super.initState();

    // Initial setup
    currentUserId = profileController.profile2.value?.data?.edituser?.id ?? "";
    receiverId = widget.receiverId;
    receiverName = widget.receiverName;
    receiverImage = widget.receiverImage;
    isOnline = widget.isOnline;
    lastSeen = widget.lastSeen;

    receiverUser = {
      "id": receiverId,
      "name": receiverName,
      "profilePic": receiverImage,
    };

    // Determine friendship status
    bool isFriend = friendController.friends.value.any(
      (friend) => friend.userId == receiverId,
    );
    friendshipStatus = isFriend ? "friend" : "none";

    // Initialize light animations
    _initializeAnimations();

    // Initialize chat asynchronously without blocking UI
    refreshChat();

    // Set up periodic refresh every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        silentRefresh();
      } else {
        timer.cancel();
      }
    });

    // Scroll to bottom when messages are loaded or updated
    ever(controller.messages, (messages) {
      if (messages.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollCtrl.hasClients) {
            scrollCtrl.animateTo(
              scrollCtrl.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    // Initialize block status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      blockController.isBlocked.value = blockedController.blockedUsers.any(
        (user) => user.id == receiverId,
      );
    });
  }

  void _initializeAnimations() {
    // Bubble floating animation
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _bubbleAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    // Floating element animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  void _sendMessage() {
    final text = msgCtrl.text.trim();
    if (text.isEmpty) return;

    // Send message using controller
    controller.sendMessage(text);
    msgCtrl.clear();

    // Silent refresh after sending message
    silentRefresh();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollCtrl.hasClients) {
        scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          (receiverImage != null &&
                              receiverImage.isNotEmpty &&
                              receiverImage.startsWith("http"))
                          ? NetworkImage(resolveImageUrl(receiverImage))
                          : null,
                      child: (receiverImage == null || receiverImage.isEmpty)
                          ? Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receiverName,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isOnline ? "Online" : "Last seen recently",
                        //  "Last seen ${_formatLastSeen(lastSeen)}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              _handleAudioCall(receiverUser, friendshipStatus);
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              _handleVideoCall(receiverUser, friendshipStatus);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_chat') {
                _showClearChatConfirmation();
              } else if (value == 'block_user') {
                _showBlockUserConfirmation();
              }
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuItem<String>> items = [
                const PopupMenuItem<String>(
                  value: 'clear_chat',
                  child: Text('Clear Chat'),
                ),
              ];
              if (friendshipStatus == "friend" || blockController.isBlocked.value) {
                items.add(
                  PopupMenuItem<String>(
                    value: 'block_user',
                    child: Obx(() => Text(
                      blockController.isBlocked.value ? 'Unblock' : 'Block',
                    )),
                  ),
                );
              }
              return items;
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/chat_back.jpeg"),
                fit: BoxFit.cover, // fills entire container
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _floatingAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _floatingAnimation.value,
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Let's break the ice by saying hii👋",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: silentRefresh,
                    child: ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.all(8),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final msg = controller.messages[index];
                        final isMe = msg.from == currentUserId;

                        return _buildMessageBubble(msg, isMe, theme);
                      },
                    ),
                  );
                }),
              ),
              Obx(() {
                if (blockController.isBlocked.value) {
                  return Container(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 10,
                      bottom: 10 + MediaQuery.of(context).padding.bottom,
                    ),
                    color: Colors.redAccent,
                    child: Row(
                      children: [
                        Expanded(
                          child: const Text(
                            "You have blocked this user. Tap to unblock and start chatting.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await blockController.unblockUser(receiverId);
                            await blockedController.fetchBlockedUsers();
                            blockController.isBlocked.value = false;
                            Get.snackbar("Success", "User unblocked successfully");
                          },
                          child: const Text(
                            "Unblock",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 10,
                      bottom: 10 + MediaQuery.of(context).padding.bottom,
                    ),
                    color: theme.colorScheme.secondary,
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
                  );
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLightBackgroundAnimation() {
    final theme = Theme.of(context);

    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Floating circles
            for (int i = 0; i < 8; i++)
              Positioned(
                left: (i * 50) % MediaQuery.of(context).size.width,
                top: (i * 70) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _bubbleAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bubbleAnimation.value),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100]?.withOpacity(0.3),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Floating dots
            for (int i = 0; i < 12; i++)
              Positioned(
                left: (i * 40 + 20) % MediaQuery.of(context).size.width,
                top: (i * 60 + 40) % MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: _floatingController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.1 + 0.1 * _floatingAnimation.value,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg, bool isMe, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundImage: receiverImage.startsWith("http")
                  ? NetworkImage(resolveImageUrl(receiverImage))
                  : AssetImage(receiverImage) as ImageProvider,
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? theme.colorScheme.primary
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    msg.message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(msg.timestamp),
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          msg.status == "read" ? Icons.done_all : Icons.done,
                          size: 12,
                          color: msg.status == "read"
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage:
                  profileController
                          .profile2
                          .value
                          ?.data
                          ?.edituser
                          ?.profilePic !=
                      null
                  ? NetworkImage(
                      resolveImageUrl(profileController.profile2.value!.data!.edituser!.profilePic),
                    )
                  : AssetImage("assets/images/default_profile.png")
                        as ImageProvider,
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String _formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return 'unknown';

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  Future<void> _handleAudioCall(dynamic user, String status) async {
    final name = user["name"] ?? "User";

    // Check if user is friend
    if (status.toLowerCase() != "friend") {
      // Show subscription upgrade popup if not friend
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const SubscriptionBottomSheet(),
      );
      return;
    }

    // Check if user has active paid plan
    if (!activePlanController.hasActivePaidPlan) {
      // Show subscription upgrade popup
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const SubscriptionBottomSheet(),
      );
      return;
    }

    try {
      await ZegoService.startCall(
        targetUser: user,
        isVideoCall: false,
        currentPlan: activePlanController.activePlan.value?.planType ?? "free",
        isFriend: friendController.friends.value.any(
          (friend) => friend.userId == user["id"],
        ),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to start audio call: $e");
    }
  }

  Future<void> _handleVideoCall(dynamic user, String status) async {
    final name = user["name"] ?? "User";

    // Check if user is friend
    if (status.toLowerCase() != "friend") {
      // Show subscription upgrade popup if not friend
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const SubscriptionBottomSheet(),
      );
      return;
    }

    // Check if user has active paid plan
    if (!activePlanController.hasActivePaidPlan) {
      // Show subscription upgrade popup
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const SubscriptionBottomSheet(),
      );
      return;
    }

    try {
      await ZegoService.startCall(
        targetUser: user,
        isVideoCall: true,
        currentPlan: activePlanController.activePlan.value?.planType ?? "free",
        isFriend: friendController.friends.value.any(
          (friend) => friend.userId == user["id"],
        ),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to start video call: $e");
    }
  }

  void _showClearChatConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Chat'),
          content: const Text(
            'Are you sure you want to clear the chat history? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await controller.clearChat(); // Call the clear chat API
                // The UI will be cleared automatically since controller.messages.clear() is called in clearChat
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showBlockUserConfirmation() {
    final isBlocked = blockController.isBlocked.value;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isBlocked ? 'Unblock User' : 'Block User'),
          content: Text(
            isBlocked
                ? 'Are you sure you want to unblock this user? You will be able to chat with them again.'
                : 'Are you sure you want to block this user? You will no longer receive messages from them.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                if (isBlocked) {
                  await blockController.unblockUser(receiverId);
                  blockController.isBlocked.value = false;
                } else {
                  await blockController.blockUser(receiverId);
                  blockController.isBlocked.value = true;
                }
                // Refresh the blocked users list
                await blockedController.fetchBlockedUsers();
              },
              child: Text(isBlocked ? 'Unblock' : 'Block'),
            ),
          ],
        );
      },
    );
  }
}
