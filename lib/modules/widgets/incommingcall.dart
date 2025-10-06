import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Voice_call/view/voice_call.dart';
import 'package:shyeyes/modules/videocall_screen/view/videocall.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

Future<void> showIncomingCallDialog({
  required String callerName,
  required String callerId,
  required String roomId,
  required bool isVideoCall,
}) async {
  return Get.dialog(
    AlertDialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        "Incoming Call",
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.call, size: 60, color: Colors.greenAccent),
          const SizedBox(height: 10),
          Text(
            "$callerName is calling...",
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            /// Reject -> Just close dialog
            Get.back();
          },
          child: const Text("Reject", style: TextStyle(color: Colors.redAccent)),
        ),
        TextButton(
        onPressed: () async {
  /// Accept -> Open call page
  Get.back();

  final myUserId = await SharedPrefHelper.getUserId() ?? "";
  final myUserName = await SharedPrefHelper.getUserName() ?? "";

  if (isVideoCall) {
    Get.to(() => VideoCallPage(
          roomID: roomId,
          userID: myUserId,     // ✅ apna ID
          userName: myUserName, // ✅ apna Name
        ));
  } else {
    Get.to(() => VoiceCallPage(
          roomID: roomId,
          userID: myUserId,
          userName: myUserName,
        ));
  }
},

          child: const Text("Accept", style: TextStyle(color: Colors.greenAccent)),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
