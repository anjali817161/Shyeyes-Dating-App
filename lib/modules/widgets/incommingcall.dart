import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Voice_call/view/voice_call.dart';
import 'package:shyeyes/modules/profile/controller/current_plan_controller.dart';
import 'package:shyeyes/modules/videocall_screen/view/videocall.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

Future<void> showIncomingCallDialog({
  required String callerName,
  required String callerId,
  required String roomId,
  required bool isVideoCall,
  required String friendshipStatus,
}) async {
  final ActivePlanController planController = Get.put(
    ActivePlanController(),
    permanent: true,
  );

  // --- Force fresh fetch ---
  await planController.fetchActivePlan();

  // --- Safe check ---
  final bool hasPlan = planController.hasActivePaidPlan;
  final bool isFriend =
      friendshipStatus.toLowerCase() == "friend" ||
      friendshipStatus.toLowerCase() == "accepted";

  // --- Block if no active paid plan OR not friend ---
  if (!hasPlan || !isFriend) {
    debugPrint("❌ Incoming call blocked: no active paid plan or not friends.");
    return; // <--- completely block incoming call
  }

  // ✅ Only show dialog if checks passed
  return Get.dialog(
    AlertDialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Incoming Call", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVideoCall ? Icons.videocam : Icons.call,
            size: 60,
            color: Colors.greenAccent,
          ),
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
          onPressed: () => Get.back(),
          child: const Text(
            "Reject",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: () async {
            Get.back();

            final myUserId = await SharedPrefHelper.getUserId() ?? "";
            final myUserName = await SharedPrefHelper.getUserName() ?? "";

            if (myUserId.isEmpty) {
              Get.snackbar("Error", "User ID not found");
              return;
            }

            if (isVideoCall) {
              Get.to(
                () => VideoCallPage(
                  roomID: roomId,
                  userID: myUserId,
                  userName: myUserName,
                  receiverId: callerId,
                  receiverName: callerName,
                ),
              );
            } else {
              Get.to(
                () => AudioCallPage(
                  roomID: roomId,
                  userID: myUserId,
                  userName: myUserName,
                  receiverId: callerId,
                  receiverName: callerName,
                ),
              );
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
