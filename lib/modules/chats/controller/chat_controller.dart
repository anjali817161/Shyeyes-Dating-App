import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
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

  final baseUrl = "https://shyeyes-b.onrender.com/api/chats";
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

  late String currentUserId;
  late String token;

  var chats = <ChatPreviewModel>[].obs;
  var filteredChats = <ChatPreviewModel>[].obs;

  void searchChats(String query) {
    if (query.isEmpty) {
      filteredChats.value = [];
    } else {
      filteredChats.value = chats
          .where((c) => c.userName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // -------------------------------------------------
  // ⚙️ Initialize Socket
  // -------------------------------------------------
  Future<void> initSocket() async {
    token = await SharedPrefHelper.getToken() ?? "";
    if (token.isEmpty) {
      Get.snackbar("Error", "No token found. Please login again.");
      return;
    }

    socket = IO.io(
      "https://shyeyes-b.onrender.com/chat",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print("✅ Socket connected to /chat namespace");
    });

    socket.onDisconnect((_) {
      print("❌ Socket disconnected");
    });

    socket.on("error", (data) {
      print("⚠️ Socket error: $data");
      Get.snackbar("Chat Error", data['message'] ?? "Unknown error");
    });

    // 🧹 Remove old listener before adding new one
    socket.off("new_message");
    socket.on("new_message", (data) {
      print("📩 New message received: $data");

      // ✅ Safely cast data to Map<String, dynamic>
      final Map<String, dynamic> dataMap = Map<String, dynamic>.from(
        data as Map,
      );

      // ✅ Handle case where 'message' may be a Map or String
      final safeMessage = dataMap['message'] is Map
          ? (dataMap['message'] as Map)['text']
          : dataMap['message'];

      // ✅ Build safe data Map
      final Map<String, dynamic> safeData = {
        ...dataMap,
        'message': safeMessage,
      };

      // ✅ Convert to model safely
      final msg = MessageModel.fromJson(safeData);

      // ✅ Prevent duplicates
      addUniqueMessage(msg);
    });

    socket.off("message_sent");
    socket.on("message_sent", (data) {
      print("✅ Message sent confirmed: $data");
      remainingMessages.value =
          data["remainingMessages"] ?? remainingMessages.value;
    });

    socket.off("user_online");
    socket.on("user_online", (data) {
      onlineUsers.add(data['userId']);
    });

    socket.off("user_offline");
    socket.on("user_offline", (data) {
      onlineUsers.remove(data['userId']);
    });

    socket.off("user_typing");
    socket.on("user_typing", (data) {
      if (data["userId"] == receiverId.value) {
        isTyping.value = data["isTyping"] ?? false;
      }
    });
  }

  void addUniqueMessage(MessageModel message) {
    if (!messages.any(
      (m) => m.id == message.id && m.message == message.message,
    )) {
      messages.add(message);
    }
  }

  // -------------------------------------------------
  // 💬 Initialize Chat with Receiver
  // -------------------------------------------------
  Future<void> initChat({
    required String receiverId,
    required String receiverName,
    required String receiverImage,
    String? baseUrl,
  }) async {
    try {
      isLoading.value = true;

      currentUserId = profileController.profile2.value?.data?.user?.id ?? "";
      if (currentUserId.isEmpty) {
        Get.snackbar("Error", "User ID not found. Please login again.");
        print("currentUserId: ${currentUserId}");
        return;
      }

      this.receiverId.value = receiverId;
      this.receiverName.value = receiverName;
      this.receiverImage.value = receiverImage;

      await initSocket();

      // Join chat room
      socket.emit("join_chat", {"receiverId": receiverId});
      print("📥 Joined chat with $receiverId");

      // Load old messages
      await fetchMessages(receiverId);
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

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {
          messages.assignAll(
            (jsonData["messages"] as List)
                .map((e) => MessageModel.fromJson(e))
                .toList(),
          );
        }
      } else {
        print("Failed to fetch messages: ${response.body}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  // -------------------------------------------------
  // 📤 Send Message (Socket + REST)
  // -------------------------------------------------
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final tempMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: currentUserId,
      to: receiverId.value,
      message: text,
      timestamp: DateTime.now(),
      status: "sending",
    );
    messages.add(tempMsg);

    // --- Send via socket first ---
    socket.emit("send_message", {
      "receiverId": receiverId.value,
      "message": text,
    });

    // --- REST fallback / subscription tracking ---
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
        remainingMessages.value = data["remainingMessages"] ?? 0;

        // update status in message list
        final index = messages.indexWhere((m) => m.id == tempMsg.id);
        if (index != -1) {
          messages[index] = MessageModel(
            id: tempMsg.id,
            from: tempMsg.from,
            to: tempMsg.to,
            message: tempMsg.message,
            timestamp: tempMsg.timestamp,
            status: "sent",
          );
        }
      } else if (response.statusCode == 403) {
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Limit Reached",
          error["message"] ?? "Subscription expired",
        );
      } else {
        Get.snackbar("Error", "Failed to send message");
      }
    } catch (e) {
      print("Error sending message: $e");
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          final convos = (data["conversations"] as List)
              .map((e) => ChatPreviewModel.fromJson(e))
              .toList();
          return convos;
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
