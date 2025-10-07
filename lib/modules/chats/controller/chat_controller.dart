import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/model/user_chat_model.dart';
import 'package:shyeyes/modules/chats/services/chat_services.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class ChatController extends GetxController {
  final ChatService _service = Get.put(ChatService());

  var messages = <MessageModel>[].obs;
  var isLoading = false.obs;
  var isTyping = false.obs;

  var chats = <ChatPreviewModel>[].obs;
  var filteredChats = <ChatPreviewModel>[].obs;
  var onlineUsers = <ChatPreviewModel>[].obs;

  late String currentUserId;
  late String receiverId;
  late String receiverName;
  late String receiverImage;

  @override
  void onInit() {
    super.onInit();
    _service.init();
  }

  Future<void> initChat({
    required String receiverId,
    required String receiverName,
    required String receiverImage,
    String? baseUrl,
  }) async {
    isLoading.value = true;

    final userId = await SharedPrefHelper.getUserId();
    if (userId == null || userId.isEmpty) {
      print('User ID not found! Please login again.');
      isLoading.value = false; // ✅ important
      Get.snackbar('Error', 'User ID not found. Please login again.');
      return; // stop further execution
    }
    currentUserId = userId;

    this.receiverId = receiverId;
    this.receiverName = receiverName;
    this.receiverImage = receiverImage;

    if (baseUrl != null) _service.baseUrl = baseUrl;

    await _service.init();
    _service.connectSocket();
    _service.joinChat(receiverId);

    try {
      final oldMessages = await _service.getMessagesRest(receiverId);
      messages.assignAll(oldMessages);
    } catch (e) {
      print('Error loading old messages: $e');
    }

    _service.listenNewMessage((msg) => messages.add(msg));

    isLoading.value = false;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: currentUserId,
      to: receiverId,
      message: text,
      timestamp: DateTime.now(),
      status: 'sent',
    );

    messages.add(msg);

    // Send via socket and REST fallback
    try {
      _service.sendMessageSocket(receiverId, text);
      await _service.sendMessageRest(receiverId, text);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void loadChatList() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800)); // simulate load
    chats.assignAll([
      ChatPreviewModel(
        receiverId: "123",
        name: "Shaan",
        avatarUrl: "https://i.pravatar.cc/150?img=65",
        lastMessage: "Hey, how are you?",
        time: "2:45 PM",
        isRead: false,
      ),
    ]);
    isLoading.value = false;
  }

  void searchChats(String query) {
    if (query.isEmpty) {
      filteredChats.clear();
    } else {
      filteredChats.value = chats
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void onClose() {
    _service.socket?.disconnect();
    super.onClose();
  }
}
