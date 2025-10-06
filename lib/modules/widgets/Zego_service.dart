import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoService {
  static const int appID = 1855474960;
  static const String appSign =
      'dffcc3933e01e9debe08f228e3ac8e2f17bcdf8c7556e5f59062d94b6e9d2ffa';

  static ZegoExpressEngine? engine;

  /// ✅ Init Engine (call in main.dart once)
  static Future<void> initZegoEngine() async {
    ZegoEngineProfile profile = ZegoEngineProfile(
      appID,
      ZegoScenario.General,
      appSign: appSign,
    );
    ZegoExpressEngine.createEngineWithProfile(profile);
    engine = ZegoExpressEngine.instance;

    print("✅ Zego Engine Initialized");
  }

  /// ✅ Connect user (for chat etc.)
  static Future<void> initZego(
      String userID, String userName, String profilePic) async {
    await ZIMKit().connectUser(id: userID, name: userName, avatarUrl: profilePic);
  }

  /// ✅ Login Room
  static Future<void> loginRoom(
      String roomID, String userID, String userName) async {
    await engine?.loginRoom(roomID, ZegoUser(userID, userName));
    print("👤 User $userID joined room $roomID");
  }

  /// ✅ Logout Room
  static Future<void> logoutRoom(String roomID) async {
    await engine?.logoutRoom(roomID);
    print("🚪 Logged out from $roomID");
  }

  /// ✅ Start Publishing (camera+mic)
  static Future<void> startPublishing(String streamID) async {
    await engine?.startPublishingStream(streamID);
    await engine?.startPreview();
    print("📡 Publishing Stream: $streamID");
  }

  /// ✅ Stop Publishing
  static Future<void> stopPublishing() async {
    await engine?.stopPreview();
    await engine?.stopPublishingStream();
    print("🛑 Publishing Stopped");
  }

  /// ✅ Start Playing Remote
  static Future<void> startPlaying(String streamID, int viewID) async {
    await engine?.startPlayingStream(streamID, canvas: ZegoCanvas(viewID));
    print("🎥 Playing Remote: $streamID");
  }

  /// ✅ Stop Playing Remote
  static Future<void> stopPlaying(String streamID) async {
    await engine?.stopPlayingStream(streamID);
    print("🛑 Stopped Remote: $streamID");
  }

  /// ✅ Mic Control
  static Future<void> toggleMic(bool enable) async {
    await engine?.muteMicrophone(!enable);
  }

  /// ✅ Camera Control
  static Future<void> toggleCamera(bool enable) async {
    await engine?.enableCamera(enable);
  }

  /// ✅ Switch Camera
  static Future<void> switchCamera(bool useFront) async {
    await engine?.useFrontCamera(useFront);
  }

  /// ✅ Destroy Engine (on app exit)
  static Future<void> destroyEngine() async {
    await ZegoExpressEngine.destroyEngine();
    engine = null;
    print("💥 Engine Destroyed");
  }

  // ----------------------------------------------------------------
  // 🚀 New Functions
  // ----------------------------------------------------------------

  /// ✅ Start Call using Users model
  static Future<void> startCall({
    required Users targetUser,
    required String myUserId,
    required String myName,
    required bool isVideoCall,
  }) async {
    String roomId = DateTime.now().millisecondsSinceEpoch.toString();

    // Step 1: Login Room (caller)
    await loginRoom(roomId, myUserId, myName);

    // Step 2: Start Publishing (caller ke liye apna camera/mic on)
    await startPublishing(roomId);

    // Step 3: Send Push Notification (to receiver)
    print("📨 Sending call notification to ${targetUser.id}");
    await sendCallNotification(
      toUserId: targetUser.id!,
      roomId: roomId,
      callerId: myUserId,
      callerName: myName,
      isVideoCall: isVideoCall,
    );

    print("✅ Call Started with ${targetUser.name?.firstName ?? 'Unknown'}");
  }

  /// ✅ Show Incoming Call Popup (Receiver side)
  static void showIncomingCallDialog({
    required String callerId,
    required String callerName,
    required String roomId,
    required bool isVideoCall,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text("📞 Incoming ${isVideoCall ? "Video" : "Voice"} Call"),
        content: Text("Caller: $callerName ($callerId)"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              print("❌ Call Rejected");
              logoutRoom(roomId);
            },
            child: const Text("Reject", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              print("✅ Call Accepted");

              // ✅ Receiver room join karega
              await loginRoom(roomId, callerId, callerName);

              // ✅ Go to call screen
              if (isVideoCall) {
                Get.toNamed("/videoCall",
                    arguments: {"roomId": roomId, "callerId": callerId});
              } else {
                Get.toNamed("/voiceCall",
                    arguments: {"roomId": roomId, "callerId": callerId});
              }
            },
            child: const Text("Accept", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ----------------------------------------------------------------
  // 🔔 Send FCM Notification
  // ----------------------------------------------------------------
  static Future<void> sendCallNotification({
    required String toUserId,
    required String roomId,
    required String callerId,
    required String callerName,
    required bool isVideoCall,
  }) async {
    // ⚡ Ye API call tumhare backend se hoga jo Firebase FCM server key use karega
    // Flutter se direct server key expose mat karna.

    // Sample JSON payload:
    final notificationPayload = {
      "to": toUserId, // receiver ka FCM token (backend se milega)
      "data": {
        "type": "call",
        "callerId": callerId,
        "callerName": callerName,
        "roomId": roomId,
        "callType": isVideoCall ? "video" : "voice",
      },
      "notification": {
        "title": "Incoming ${isVideoCall ? "Video" : "Voice"} Call",
        "body": "Call from $callerName",
        "sound": "default"
      }
    };

    print("📤 Sending Notification Payload: $notificationPayload");

    // TODO: is payload ko apne backend par bhejna hoga jahan se FCM ke through push jayega
  }
}
