class ChatUserModel {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isRead;

  ChatUserModel({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.isRead = false,
  });
}
