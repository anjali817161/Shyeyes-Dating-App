class ChatPreviewModel {
  final String userId;          // sender or receiver id
  final String receiverId;      // new field
  final String userName;
  final String profilePic;
  final String lastMessage;
  final String lastMessageTime;
  final bool isRead;

  ChatPreviewModel({
    required this.userId,
    required this.receiverId,
    required this.userName,
    required this.profilePic,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isRead,
  });

  factory ChatPreviewModel.fromJson(Map<String, dynamic> json) {
    return ChatPreviewModel(
      userId: json['userId'] ?? json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? json['to'] ?? '',
      userName: json['userName'] ?? json['name'] ?? '',
      profilePic: json['profilePic'] ?? json['image'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: _formatTime(json['lastMessageTime']),
      isRead: json['isRead'] == true ||
              (json['status']?.toString().toLowerCase() == 'read'),
    );
  }

  static String _formatTime(dynamic value) {
    if (value == null) return '';
    try {
      final date = DateTime.tryParse(value.toString());
      if (date == null) return '';
      final now = DateTime.now();
      if (now.difference(date).inDays == 0) {
        // same day
        return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else {
        // show date
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return '';
    }
  }
}
