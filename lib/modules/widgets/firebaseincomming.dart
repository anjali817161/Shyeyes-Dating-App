// import 'package:http/http.dart' as http;
// import 'dart:convert';

// static const String fcmServerKey = "YOUR_FIREBASE_SERVER_KEY_HERE";

// static Future<void> sendCallNotification({
//   required String toUserId,
//   required String roomId,
//   required String callerId,
//   required String callerName,
//   required bool isVideoCall,
// }) async {
//   final payload = {
//     "to": toUserId, // ✅ this must be the receiver's FCM token, not userId
//     "data": {
//       "type": "call",
//       "callerId": callerId,
//       "callerName": callerName,
//       "roomId": roomId,
//       "callType": isVideoCall ? "video" : "voice",
//     },
//     "notification": {
//       "title": "Incoming ${isVideoCall ? 'Video' : 'Voice'} Call",
//       "body": "Call from $callerName",
//       "sound": "default",
//     },
//   };

//   final res = await http.post(
//     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$fcmServerKey',
//     },
//     body: jsonEncode(payload),
//   );

//   print("📤 FCM Response: ${res.statusCode} => ${res.body}");
// }
