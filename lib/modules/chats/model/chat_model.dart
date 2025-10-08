class MessageModel {
  final String id;
  final String from;
  final String to;
  final String message;
  final DateTime timestamp;
  final String status;
  final dynamic remainingMessages; // can be int or String
  final int? messagesUsedTotal;

  MessageModel({
    required this.id,
    required this.from,
    required this.to,
    required this.message,
    required this.timestamp,
    required this.status,
    this.remainingMessages,
    this.messagesUsedTotal,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Handle message as String or Map
    String msgText = '';
    DateTime? msgTimestamp;

    final msgData = json['message'] ?? json['sentMessage'] ?? '';
    if (msgData is String) {
      msgText = msgData;
    } else if (msgData is Map<String, dynamic>) {
      msgText = msgData['text'] ?? '';
      msgTimestamp = DateTime.tryParse(msgData['timestamp'] ?? '');
    }

    return MessageModel(
      id: json['petitionId'] ?? json['_id'] ?? json['id'] ?? '',
      from: json['from'] ?? json['senderId'] ?? '',
      to: json['to'] ?? json['receiverId'] ?? '',
      message: msgText,
      timestamp:
          msgTimestamp ??
          DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.now(),
      status: json['status'] ?? json['deliveryStatus'] ?? 'pending',
      remainingMessages: json['remainingMessages'], // dynamic
      messagesUsedTotal: json['messagesUsedTotal'] is int
          ? json['messagesUsedTotal']
          : int.tryParse(json['messagesUsedTotal']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'from': from,
    'to': to,
    'message': message,
    'createdAt': timestamp.toIso8601String(),
    'status': status,
    'remainingMessages': remainingMessages,
    'messagesUsedTotal': messagesUsedTotal,
  };

  bool get isMe => from == currentUserId;
}

String currentUserId = "";
