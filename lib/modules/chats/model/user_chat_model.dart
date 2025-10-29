// models/chat_preview_model.dart
class ChatPreviewModel {
  final String? chatId;
  final String? userId;
  final String? userName;
  final String? profilePic;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? senderName;

  ChatPreviewModel({
    this.chatId,
    this.userId,
    this.userName,
    this.profilePic,
    this.lastMessage,
    this.lastMessageTime,
    this.senderName,
  });

  factory ChatPreviewModel.fromJson(Map<String, dynamic> json) {
    final otherUser = json["otherUser"] ?? {};
    final lastMsg = json["lastMessage"] ?? {};

    return ChatPreviewModel(
      chatId: json["chatId"] ?? "",
      userId: otherUser["id"] ?? "",
      userName: otherUser["name"] ?? "User",
      profilePic: otherUser["profilePic"] ?? "",
      lastMessage: lastMsg["message"] ?? "",
      lastMessageTime: lastMsg["createdAt"] ?? "",
      senderName: lastMsg["senderName"] ?? "",
    );
  }
}
