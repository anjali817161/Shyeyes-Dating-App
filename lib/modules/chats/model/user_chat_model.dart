class ChatPreviewModel {
  final String receiverId;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final bool isRead;

  ChatPreviewModel({
    required this.receiverId,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.isRead = true,
  });
}
