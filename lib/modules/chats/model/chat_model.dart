class MessageModel {
  final String id;
  final String from;
  final String to;
  final String message;
  final DateTime timestamp;
  final String status;
  final int? remainingMessages;
  final dynamic? messagesUsedTotal;

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
    // -------------------------------
    // Parse from / to fields
    // -------------------------------
    String fromId = '';
    String toId = '';

    final fromData = json['from'];
    if (fromData is String) {
      fromId = fromData;
    } else if (fromData is Map) {
      fromId = fromData['_id']?.toString() ?? '';
    }

    final toData = json['to'];
    if (toData is String) {
      toId = toData;
    } else if (toData is Map) {
      toId = toData['_id']?.toString() ?? '';
    }

    // -------------------------------
    // Parse message text
    // -------------------------------
    String msgText = '';
    if (json['message'] != null) {
      if (json['message'] is String) {
        msgText = json['message'];
      } else if (json['message'] is Map) {
        msgText = json['message']['text'] ?? '';
      }
    } else if (json['sentMessage'] != null) {
      msgText = json['sentMessage']?.toString() ?? '';
    }

    // -------------------------------
    // Parse timestamp
    // -------------------------------
    DateTime timestamp = DateTime.now();
    if (json['createdAt'] != null) {
      timestamp =
          DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    }

    // -------------------------------
    // Parse status
    // -------------------------------
    String status =
        json['status']?.toString() ??
        json['deliveryStatus']?.toString() ??
        'pending';

    int remaining = int.tryParse(json['remainingMessages'].toString()) ?? 0;

    // -------------------------------
    // Parse remainingMessages
    // -------------------------------
    // dynamic remaining;
    // final rm = json['remainingMessages'];
    // if (rm != null) {
    //   if (rm is int)
    //     remaining = rm;
    //   else if (rm is String)
    //     remaining = rm; // Keep "Unlimited" string
    // }

    // -------------------------------
    // Parse messagesUsedTotal
    // -------------------------------
    dynamic usedTotal;
    final rawUsed = json['messagesUsedTotal'];
    if (rawUsed != null) {
      if (rawUsed is int)
        usedTotal = rawUsed;
      else if (rawUsed is String)
        usedTotal = int.tryParse(rawUsed);
    }

    return MessageModel(
      id:
          json['petitionId']?.toString() ??
          json['_id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      from: fromId,
      to: toId,
      message: msgText,
      timestamp: timestamp,
      status: status,
      remainingMessages: remaining,
      messagesUsedTotal: usedTotal,
    );
  }

  bool isMe(String currentUserId) => from == currentUserId;

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
}
