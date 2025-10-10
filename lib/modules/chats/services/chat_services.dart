import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService extends GetxService {
  IO.Socket? socket;
  String baseUrl = 'https://shyeyes-b.onrender.com/api/chats';
  String? _token;

  final profileController = Get.find<ProfileController>();

  Future<ChatService> init({String? baseUrlOverride}) async {
    if (baseUrlOverride != null) baseUrl = baseUrlOverride;
    final prefs = await SharedPreferences.getInstance();
    _token = await SharedPrefHelper.getToken();
    // Get current user ID from profileController
    final currentUserId =
        profileController.profile2.value?.data?.edituser?.id ?? '';
    print('✅ Current user id: $currentUserId');
    return this;
  }

  bool get isConnected => socket != null && socket!.connected;

  void connectSocket() {
    if (_token == null) {
      print('ChatService.connectSocket: No token found.');
      return;
    }

    // Avoid duplicate connections
    socket?.disconnect();
    socket = IO.io('$baseUrl/send', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'auth': {'token': _token},
    });

    socket!.onConnect((_) => print('✅ Socket connected'));
    socket!.onDisconnect((_) => print('❌ Socket disconnected'));
    socket!.on('error', (data) => print('⚠️ Socket error: $data'));
  }

  void joinChat(String receiverId) {
    if (socket == null) connectSocket();
    socket?.emit('join_chat', {'receiverId': receiverId});
  }

  void sendMessageSocket(String receiverId, String message) {
    socket?.emit('send_message', {
      'receiverId': receiverId,
      'message': message,
    });
  }

  void listenNewMessage(Function(MessageModel) onMessage) {
    socket?.on('new_message', (data) {
      try {
        final msg = MessageModel.fromJson(Map<String, dynamic>.from(data));
        onMessage(msg);
      } catch (e) {
        print('listenNewMessage parse error: $e');
      }
    });
  }

  Future<List<MessageModel>> getMessagesRest(String otherUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await SharedPrefHelper.getToken();

    final res = await http.get(
      Uri.parse('$baseUrl/messages/$otherUserId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = json.decode(res.body);
      final msgs = (body['messages'] as List?) ?? [];
      return msgs.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch messages: ${res.statusCode}');
    }
  }

  Future<void> sendMessageRest(String toUserId, String message) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await SharedPrefHelper.getToken();

    final res = await http.post(
      Uri.parse('$baseUrl/send'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'to': toUserId, 'message': message}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Send message failed: ${res.statusCode}');
    }
  }

  void disposeSocket() {
    try {
      socket?.disconnect();
      socket = null;
    } catch (e) {
      print('disposeSocket error: $e');
    }
  }
}
