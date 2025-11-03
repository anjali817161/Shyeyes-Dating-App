import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/profile/controller/current_plan_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/model/user_chat_model.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class ChatController extends GetxController {
  // -------------------------------------------------
  // 🧠 Controllers & API Setup
  // -------------------------------------------------
  final profileController = Get.find<ProfileController>();
  final activeUserController = Get.find<ActiveUsersController>();

  final baseUrl = "https://shyeyes-backend.onrender.com/api/chats";
  IO.Socket? socket;

  // -------------------------------------------------
  // 📦 Observables
  // -------------------------------------------------
  var messages = <MessageModel>[].obs;
  var isLoading = false.obs;
  var isTyping = false.obs;
  var onlineUsers = <Users>[].obs;
  var receiverId = "".obs;
  var receiverName = "".obs;
  var receiverImage = "".obs;
  var remainingMessages = 0.obs;

  final _addedMessageIds = <String>{};

  final _box = GetStorage();

  late String currentUserId;
  late String token;

  // var chats = <ChatPreviewModel>[].obs;
  var conversations = <ChatPreviewModel>[].obs;

  void searchChats(String query) {
    if (query.isEmpty) {
      conversations.value = [];
    } else {
      conversations.value = conversations
          .where((c) => c.userName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // -------------------------------------------------
  // ⚙️ Initialize Socket
  // -------------------------------------------------
  // Update the socket error handling in initSocket:
  Future<void> initSocket() async {
    token = await SharedPrefHelper.getToken() ?? "";
    if (token.isEmpty) {
      Get.snackbar("Error", "No token found. Please login again.");
      return;
    }

    _log('initSocket: starting');
    // If there's an existing socket, clean it up to avoid duplicate listeners
    try {
      if (socket != null) {
        _log('initSocket: disposing existing socket instance');
        socket?.off("new_message");
        socket?.off("message_sent");
        socket?.disconnect();
      }
    } catch (e) {
      _log('Error while disposing old socket: $e');
    }

    socket = IO.io(
      "https://shyeyes-backend.onrender.com/chat",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    socket?.connect();

    socket?.onConnect((_) => _log("✅ Socket connected to /chat namespace"));
    socket?.onDisconnect((_) => _log("❌ Socket disconnected"));

    // Handle subscription errors gracefully
    socket?.on("error", (data) {
      _log("⚠️ Socket error: $data");
      if (data is Map &&
          data['message']?.toString().contains('subscription') == true) {
        Get.snackbar(
          "Subscription Required",
          "Both users need active subscriptions to chat",
          duration: const Duration(seconds: 3),
        );
      }
    });

    // 🧹 Prevent duplicate listeners
    // Ensure listener is only attached once on the current socket instance
    _log('Detaching new_message listener (if any)');
    socket?.off("new_message");
    socket?.on("new_message", (rawData) {
      try {
        final Map<String, dynamic> data = {};
        (rawData as Map).forEach((key, value) {
          data[key.toString()] = value;
        });

        final msgData = data['message'];
        final safeMessage = msgData is Map
            ? msgData['text'] ?? ''
            : msgData?.toString() ?? '';
        data['message'] = safeMessage;

        final msg = MessageModel.fromJson(data);

        // Only process messages for current chat
        bool isForCurrentChat =
            (msg.to == receiverId.value && msg.from == currentUserId) ||
            (msg.from == receiverId.value && msg.to == currentUserId);
        if (!isForCurrentChat) {
          _log("⏭️ Skipping message not for current chat");
          return;
        }

        // If this is a message from current user, try to replace a local temp message
        if (msg.from == currentUserId) {
          final idx = messages.indexWhere(
            (m) =>
                m.from == currentUserId &&
                (m.status == 'sending' || m.status == 'pending') &&
                m.message == msg.message &&
                msg.timestamp.difference(m.timestamp).inSeconds.abs() <= 10,
          );

          if (idx != -1) {
            // Replace temp message with server message
            final oldId = messages[idx].id;
            messages[idx] = msg;
            // Update dedupe set
            _addedMessageIds.remove(oldId);
            _addedMessageIds.add(msg.id);
            // Remove any other duplicate entries that may have the same oldId
            try {
              messages.removeWhere((m) => m.id == oldId && m.id != msg.id);
            } catch (_) {}
            saveMessagesToLocal();
            _log("🔁 Replaced temp message $oldId with server id ${msg.id}");
            _sortMessages();
            return;
          }
        }

        // Add message if not already added (deduplication by ID)
        if (!_addedMessageIds.contains(msg.id)) {
          _addedMessageIds.add(msg.id);
          messages.add(msg);
          saveMessagesToLocal();
          _log("✅ Added message: ${msg.id}");
          _sortMessages();
        } else {
          _log("⚠️ Duplicate message ignored: ${msg.id}");
        }
      } catch (e, st) {
        _log("🔥 Error in new_message listener: $e");
        print(st);
      }
    });

    _log('Attached new_message listener');

    _log('Detaching message_sent listener (if any)');
    socket?.off("message_sent");
    socket?.on("message_sent", (data) {
      _log("✅ Message sent confirmed: $data");
      final rm = data["remainingMessages"];

      if (rm is int) {
        remainingMessages.value = rm;
      } else if (rm is String) {
        if (rm == "Unlimited") {
          remainingMessages.value =
              999999; // Set to a large number for unlimited
        } else {
          // Try to parse if it's a number string
          final parsed = int.tryParse(rm);
          if (parsed != null) {
            remainingMessages.value = parsed;
          } else {
            // handle non-numeric gracefully (keep old value or reset)
            print("⚠️ Unexpected string for remainingMessages: $rm");
          }
        }
      } else if (rm == null) {
        _log("⚠️ remainingMessages is null, keeping old value");
      }
    });

    _log('Attached message_sent listener');
  }

  //SAVE MSG LOCALLY//

  void saveMessagesToLocal() {
    final msgList = messages.map((m) => m.toJson()).toList();
    _box.write('chat_${receiverId.value}', msgList);
  }

  void loadMessagesFromLocal(String rid) {
    final data = _box.read('chat_$rid');
    if (data != null) {
      final loadedMessages = (data as List)
          .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Filter messages to ensure they belong to current chat only
      final filteredMessages = loadedMessages
          .where(
            (m) =>
                (m.from == currentUserId && m.to == rid) ||
                (m.from == rid && m.to == currentUserId),
          )
          .toList();

      // Deduplicate loaded messages
      final uniqueLoaded = <MessageModel>[];
      for (final m in filteredMessages) {
        if (!uniqueLoaded.any((u) => u.id == m.id)) uniqueLoaded.add(m);
      }

      messages.assignAll(uniqueLoaded);
      _sortMessages();

      // Add IDs to prevent duplicates
      _addedMessageIds.clear(); // Clear existing IDs first
      for (var msg in uniqueLoaded) {
        _addedMessageIds.add(msg.id);
      }
    }
  }

  // -------------------------------------------------
  // 💬 Initialize Chat with Receiver
  // -------------------------------------------------
  Future<void> initChat({
    required String receiverId,
    required String receiverName,
    required String receiverImage,
    required Map<String, dynamic> receiverUser,
    String? baseUrl,
  }) async {
    try {
      isLoading.value = true;

      currentUserId =
          profileController.profile2.value?.data?.edituser?.id ?? "";
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "User ID not found. Please login again.");
        print("currentUserId: ${currentUserId}");
        return;
      }

      this.receiverId.value = receiverId;
      this.receiverName.value = receiverName;
      this.receiverImage.value = receiverImage;
      await initSocket();
      loadMessagesFromLocal(receiverId);
      socket?.emit("join_chat", {"receiverId": receiverId});
      _log('Emitted join_chat to $receiverId');
      await fetchMessages(receiverId);

      // Join chat room
      print("📥 Joined chat with $receiverId");

      // Load old messages
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------
  // 📨 Fetch Messages (REST)
  // -------------------------------------------------
  Future<void> fetchMessages(String receiverId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/messages/$receiverId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("body:-------${response.body}");
      print("status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {
          final fetchedMessages = (jsonData["messages"] as List)
              .map((e) => MessageModel.fromJson(e))
              .toList();
          // Merge fetched messages with local messages.
          // If a fetched message corresponds to a local "temp" message (status sending/pending)
          // replace the temp with the server message to avoid duplicate UI entries.
          final List<MessageModel> merged = List.from(messages);

          for (final f in fetchedMessages) {
            // try to find a matching local temp message by same sender, same text,
            // and timestamp proximity (allow some clock skew)
            final idx = merged.indexWhere(
              (m) =>
                  m.from == f.from &&
                  (m.status == 'sending' || m.status == 'pending') &&
                  m.message == f.message &&
                  (f.timestamp.difference(m.timestamp).inSeconds.abs() <= 120),
            );

            if (idx != -1) {
              final oldId = merged[idx].id;
              merged[idx] = f;
              // remove other duplicates of oldId to avoid multiple replacements
              merged.removeWhere((m) => m.id == oldId && m.id != f.id);
              _addedMessageIds.remove(oldId);
              _addedMessageIds.add(f.id);
              _log(
                'fetchMessages: replaced local temp $oldId with server ${f.id}',
              );
            } else if (!merged.any((m) => m.id == f.id)) {
              // not present by id - append
              merged.add(f);
              _addedMessageIds.add(f.id);
              _log('fetchMessages: appended server message ${f.id}');
            } else {
              // already present by id — skip
            }
          }

          messages.assignAll(merged);
          // Ensure correct chronological order and persist
          _sortMessages();
          saveMessagesToLocal();
        } else {
          // Handle "No chat found" gracefully - it's not an error, just no messages yet
          print("No existing chat found - starting fresh");
          messages.clear();
        }
      } else if (response.statusCode == 404) {
        // No chat exists yet - this is normal for new conversations
        print("No existing chat - starting new conversation");
        messages.clear();
      } else {
        print("Failed to fetch messages: ${response.body}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
      // Don't show error to user for "no chat found" scenario
    }
  }

  // -------------------------------------------------
  // 📤 Send Message (Socket + REST)
  // -------------------------------------------------
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final activePlanController = Get.find<ActivePlanController>();
    final friendController = Get.find<FriendController>();
    final plan = activePlanController.activePlan.value;

    // Check if friend
    bool isFriend = friendController.friends.any(
      (f) => f.userId == receiverId.value,
    );
    if (!isFriend) {
      Get.snackbar('Warning', '⚠️ You need to be friends to send messages!');
      _sortMessages();
      return;
    }

    // Check if has active plan
    if (plan == null) {
      Get.snackbar(
        'Subscription Required',
        'Please subscribe to send messages',
      );
      _sortMessages();
      return;
    }

    // Check plan limits based on plan type
    if (plan.planType?.toLowerCase() == 'free') {
      // Free plan: 50 messages limit
      final totalMsgs = messages.length;
      if (totalMsgs >= 50) {
        _showLimitDialog('message', 50);
        return;
      }
    } else {
      // Paid plans: Check usage against limits
      final messageUsage = plan.usage?.messages?.used ?? 0;
      final messageLimit = plan.limits?.messagesPerDay ?? 0;
      if (messageLimit > 0 && messageUsage >= messageLimit) {
        _showLimitDialog('message', messageLimit);
        return;
      }
    }

    // Block phone numbers
    final hasNumber = RegExp(r'\d{8,}').hasMatch(text);
    String sanitizedText = hasNumber
        ? text.replaceAll(RegExp(r'\d'), 'x')
        : text;

    final tempMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: currentUserId,
      to: receiverId.value,
      message: sanitizedText,
      timestamp: DateTime.now(),
      status: "sending",
    );

    messages.add(tempMsg);
    _addedMessageIds.add(tempMsg.id);
    saveMessagesToLocal();
    _log('Added temp message id: ${tempMsg.id} text: ${tempMsg.message}');

    // Send via socket - message will be updated when received back via new_message event
    _log('Emitting send_message -> ${sanitizedText}');
    socket?.emit("send_message", {
      "receiverId": receiverId.value,
      "message": sanitizedText,
      "to": receiverId.value, // Add specific recipient
    });

    // Silent refresh after sending
    Future.delayed(Duration(milliseconds: 500), () {
      fetchMessages(receiverId.value);
    });
  }

  void markMessageAsRead(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = MessageModel(
        id: messages[index].id,
        from: messages[index].from,
        to: messages[index].to,
        message: messages[index].message,
        timestamp: messages[index].timestamp,
        status: "read",
      );
    }
  }

  // -------------------------------------------------
  // ✍️ Typing Indicators
  // -------------------------------------------------
  void startTyping() {
    socket?.emit("typing_start", {"receiverId": receiverId.value});
  }

  void stopTyping() {
    socket?.emit("typing_stop", {"receiverId": receiverId.value});
  }

  // -------------------------------------------------
  // 🧾 Message Utilities
  // -------------------------------------------------
  void _sortMessages() {
    try {
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      // notify observers in case sorting doesn't auto-update
      messages.refresh();
    } catch (e) {
      print('Error sorting messages: $e');
    }
  }

  // Simple logger to make debugging socket lifecycle easier
  void _log(String msg) {
    try {
      final rid = receiverId.value.isNotEmpty
          ? receiverId.value
          : 'no-receiver';
      print('[ChatController][$rid] $msg');
    } catch (e) {
      print('[ChatController] $msg');
    }
  }

  // -------------------------------------------------
  // 🔄 Refresh Conversations List
  // -------------------------------------------------
  Future<List<ChatPreviewModel>> fetchConversations() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/conversations"),
        headers: {"Authorization": "Bearer $token"},
      );

      print("body:-------${response.body}");
      print("status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true && data["conversations"] != null) {
          final List convos = data["conversations"];
          conversations.assignAll(
            convos.map((e) => ChatPreviewModel.fromJson(e)).toList(),
          );
        }
      }
    } catch (e) {
      print("Error loading conversations: $e");
    }
    return [];
  }

  // -------------------------------------------------
  // 🧹 Clear Chat History
  // -------------------------------------------------
  Future<void> clearChat() async {
    try {
      _log('clearChat: clearing chat for receiver ${receiverId.value}');
      final response = await http.delete(
        Uri.parse("$baseUrl/clear/${receiverId.value}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        // Clear all messages from current chat
        messages.clear();

        // Clear all stored messages for this chat
        try {
          // Clear messages from local storage
          _box.remove('chat_${receiverId.value}');

          // Clear message IDs from deduplication set
          // Clear only message IDs belonging to this chat
          _addedMessageIds
              .clear(); // For simplicity, clear all and rebuild from messages list
          final remainingMessages = messages
              .where(
                (m) =>
                    !(m.from == currentUserId && m.to == receiverId.value) &&
                    !(m.from == receiverId.value && m.to == currentUserId),
              )
              .toList();

          // Rebuild ID set from remaining messages
          for (var msg in remainingMessages) {
            _addedMessageIds.add(msg.id);
          }
          ;

          _log('clearChat: cleared local cache and dedupe set');
        } catch (e) {
          _log('Error clearing local chat cache: $e');
        }

        // Also remove socket listeners for this chat so rejoining doesn't duplicate
        try {
          _log(
            'clearChat: removing socket listeners for receiver ${receiverId.value}',
          );
          socket?.off("new_message");
          socket?.off("message_sent");
        } catch (e) {
          _log('Error removing socket listeners on clearChat: $e');
        }

        Get.snackbar("Success", "Chat history cleared");
        _log('clearChat: completed successfully');
      }
    } catch (e) {
      _log("Error clearing chat: $e");
    }
  }

  // -------------------------------------------------
  // 📊 Show Limit Dialog
  // -------------------------------------------------
  void _showLimitDialog(String type, int limit) {
    Get.dialog(
      Dialog(
        shape: HeartShapeBorder(),
        backgroundColor: Get.theme.colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Get.theme.colorScheme.primary,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Limit Reached',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                type == 'message'
                    ? 'You have reached the $limit message limit for your plan. Upgrade to continue chatting!'
                    : 'You have reached the $limit minute limit for your plan. Upgrade to continue calling!',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.bottomSheet(
                    const SubscriptionBottomSheet(),
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Upgrade Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    try {
      _log('onClose: removing listeners and disconnecting socket');
      socket?.off("new_message");
      socket?.off("message_sent");
      socket?.disconnect();
      socket = null;
      _log('onClose: socket cleaned up');
    } catch (e) {
      _log('Error while closing socket: $e');
    }
    super.onClose();
  }
}
