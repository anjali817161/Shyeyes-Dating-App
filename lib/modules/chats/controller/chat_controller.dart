import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  final _box = GetStorage();

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

    socket.onConnect((_) => print("✅ Socket connected to /chat namespace"));
    socket.onDisconnect((_) => print("❌ Socket disconnected"));
    socket.on("error", (data) => print("⚠️ Socket error: $data"));

    // 🧹 Prevent duplicate listeners
    socket.off("new_message");
    socket.on("new_message", (rawData) {
      try {
        // ✅ Safely convert to Map<String, dynamic>
        final Map<String, dynamic> data = {};
        (rawData as Map).forEach((key, value) {
          data[key.toString()] = value;
        });

        // ✅ Handle message as string or map
        final msgData = data['message'];
        final safeMessage = msgData is Map
            ? msgData['text'] ?? ''
            : msgData?.toString() ?? '';

        data['message'] = safeMessage;

        final msg = MessageModel.fromJson(data);

        // ✅ Prevent duplicates
        if (!messages.any((m) => m.id == msg.id && m.message == msg.message)) {
          messages.add(msg);
          saveMessagesToLocal(); // 💾 Save locally
        }

        print("📩 New message received: ${msg.message}");
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

          // Prevent duplicates based on id
          final uniqueMessages = [
            ...messages,
            ...fetchedMessages.where((f) => !messages.any((m) => m.id == f.id)),
          ];

          messages.assignAll(uniqueMessages);
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
      print("body:-------${response.body}");
      print("status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final rm = data["remainingMessages"];
        if (rm is int) {
          remainingMessages.value = rm;
        } else if (rm is String) {
          final parsed = int.tryParse(rm);
          if (parsed != null) {
            remainingMessages.value = parsed;
          } else {
            print("⚠️ Unexpected string for remainingMessages: $rm");
            remainingMessages.value = 999999; // or keep previous value
          }
        } else {
          remainingMessages.value = 0;
        }

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
