import 'package:get/get.dart';
import 'package:shyeyes/modules/chats/model/user_chat_model.dart';

class ChatController extends GetxController {
  var chats = <ChatUserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  void fetchChats() {
    chats.value = [
      ChatUserModel(
        name: "Martin Randolph",
        message: "What's man!",
        time: "9:40 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
      ),
      ChatUserModel(
        name: "Andrew Parker",
        message: "Ok, thanks!",
        time: "9:25 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=4",
        isRead: true,
      ),
      ChatUserModel(
        name: "Karen Castillo",
        message: "See you tomorrow",
        time: "Fri",
        avatarUrl: "https://i.pravatar.cc/150?img=5",
      ),
      ChatUserModel(
        name: "Maisy Humphrey",
        message: "Have a good day",
        time: "Fri",
        avatarUrl: "https://i.pravatar.cc/150?img=6",
        isRead: true,
      ),
    ];
  }
}
