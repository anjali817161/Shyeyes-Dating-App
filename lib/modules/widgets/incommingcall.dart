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
      title: const Text(
        "Incoming Call",
        style: TextStyle(color: Colors.white),
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
        /// Reject Button
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text(
            "Reject",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),

        /// Accept Button
        TextButton(
          onPressed: () async {
            Get.back(); // Close the dialog

            final myUserId = await SharedPrefHelper.getUserId() ?? "";
            final myUserName = await SharedPrefHelper.getUserName() ?? "";

            if (myUserId.isEmpty) {
              Get.snackbar("Error", "User ID not found");
              return;
            }

            if (isVideoCall) {
              /// ✅ Navigate to Video Call Screen
              Get.to(() => VideoCallPage(
                    roomID: roomId,
                    userID: myUserId,       // Current user (receiver)
                    userName: myUserName,   // Current user's name
                    receiverId: callerId,   // ✅ Caller ID (opposite user)
                    receiverName: callerName,
                  ));
            } else {
              /// ✅ Navigate to Voice Call Screen
              Get.to(() => AudioCallPage(
                    roomID: roomId,
                    userID: myUserId,
                    userName: myUserName,
                    receiverId: callerId,   // ✅ Add here also if your VoiceCallPage supports it
                    receiverName: callerName,
                  ));
            }
          },
          child: const Text(
            "Accept",
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
