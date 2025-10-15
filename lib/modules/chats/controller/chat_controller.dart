import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
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
  late IO.Socket socket;

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

    socket = IO.io(
      "https://shyeyes-backend.onrender.com/chat",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) => print("✅ Socket connected to /chat namespace"));
    socket.onDisconnect((_) => print("❌ Socket disconnected"));

    // Handle subscription errors gracefully
    socket.on("error", (data) {
      print("⚠️ Socket error: $data");
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
    socket.off("new_message");
    socket.on("new_message", (rawData) {
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

        // ✅ deduplicate using message id
        if (!_addedMessageIds.contains(msg.id)) {
          _addedMessageIds.add(msg.id);
          messages.add(msg);
          saveMessagesToLocal();
        } else {
          print("⚠️ Duplicate message ignored: ${msg.id}");
        }
      } catch (e, st) {
        print("🔥 Error in new_message listener: $e");
        print(st);
      }
    });

    socket.off("message_sent");
    socket.on("message_sent", (data) {
      print("✅ Message sent confirmed: $data");
      final rm = data["remainingMessages"];

      if (rm is int) {
        remainingMessages.value = rm;
      } else if (rm is String) {
        // Try to parse if it's a number string
        final parsed = int.tryParse(rm);
        if (parsed != null) {
          remainingMessages.value = parsed;
        } else {
          // handle non-numeric gracefully (keep old value or reset)
          print("⚠️ Unexpected string for remainingMessages: $rm");
        }
      } else if (rm == null) {
        print("⚠️ remainingMessages is null, keeping old value");
      }
    });
  }

  //SAVE MSG LOCALLY//

  void saveMessagesToLocal() {
    final msgList = messages.map((m) => m.toJson()).toList();
    _box.write('chat_${receiverId.value}', msgList);
  }

  void loadMessagesFromLocal(String rid) {
    final data = _box.read('chat_$rid');
    if (data != null) {
      messages.assignAll(
        (data as List)
            .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
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
      socket.emit("join_chat", {"receiverId": receiverId});
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

          final uniqueMessages = [
            ...messages,
            ...fetchedMessages.where((f) => !messages.any((m) => m.id == f.id)),
          ];

          messages.assignAll(uniqueMessages);
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
      return;
    }

    // Check if has active plan
    if (plan == null) {
      Get.snackbar(
        'Subscription Required',
        'Please subscribe to send messages',
      );
      return;
    }

    // Message limits for free plan
    if (plan.planType?.toLowerCase() == 'free') {
      final totalMsgs = messages.length;
      if (totalMsgs >= 50) {
        Get.snackbar(
          'Message Limit Reached',
          'Free plan allows only 50 messages. Please upgrade.',
          duration: const Duration(seconds: 3),
        );
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

    // Save to local storage immediately
    saveMessagesToLocal();

    // Send via socket
    socket.emit("send_message", {
      "receiverId": receiverId.value,
      "message": sanitizedText,
    });

    // REST fallback
    await _sendRest(sanitizedText, tempMsg);
  }

  Future<void> _sendRest(String text, MessageModel tempMsg) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"to": receiverId.value, "message": text}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // ✅ If API returns remaining messages
        final rm = data["remainingMessages"];
        remainingMessages.value = rm is int
            ? rm
            : int.tryParse(rm.toString()) ?? remainingMessages.value;

        // ✅ Mark message as sent
        final index = messages.indexWhere((m) => m.id == tempMsg.id);
        if (index != -1) {
          messages[index] = messages[index].copyWith(status: "sent");
        }
      } else if (response.statusCode == 403) {
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Limit Reached",
          error["message"] ?? "Your subscription has expired.",
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to send message (${response.statusCode})",
        );
      }
    } catch (e) {
      print("❌ Error sending message via REST: $e");
    }
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
    socket.emit("typing_start", {"receiverId": receiverId.value});
  }

  void stopTyping() {
    socket.emit("typing_stop", {"receiverId": receiverId.value});
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
      final response = await http.delete(
        Uri.parse("$baseUrl/clear/${receiverId.value}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        messages.clear();
        Get.snackbar("Success", "Chat history cleared");
      }
    } catch (e) {
      print("Error clearing chat: $e");
    }
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
