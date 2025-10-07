class MessageModel {
  final String id;
  final String from;
  final String to;
  final String message;
  final DateTime timestamp;
  final String status; // e.g. sent, delivered, read

  MessageModel({
    required this.id,
    required this.from,
    required this.to,
    required this.message,
    required this.timestamp,
    required this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['petitionId'] ?? json['_id'] ?? json['id'] ?? '',
      from: json['from'] ?? json['senderId'] ?? '',
      to: json['to'] ?? json['receiverId'] ?? '',
      message: json['message'] ?? json['sentMessage'] ?? '',
      timestamp: DateTime.tryParse(json['createdAt'] ?? json['timestamp'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'from': from,
        'to': to,
        'message': message,
        'createdAt': timestamp.toIso8601String(),
        'status': status,
      };

  bool get isMe => from == currentUserId; // handled via controller at runtime
}

String currentUserId = ''; // Global temp var, assigned by controller
