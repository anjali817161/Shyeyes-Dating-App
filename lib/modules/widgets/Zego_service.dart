import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit/zego_uikit.dart';

import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart' as active;
import 'package:shyeyes/modules/edit_profile/edit_model.dart' as edit;
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZegoService {
  static const int appID = 1855474960;
  static const String appSign =
      'dffcc3933e01e9debe08f228e3ac8e2f17bcdf8c7556e5f59062d94b6e9d2ffa';

  static ZegoExpressEngine? engine;
  static String? currentUserId;
  static String? currentUserName;
  static String? currentUserAvatar;

  // ----------------------------------------------------------------
  // ✅ Initialize Engine
  // ----------------------------------------------------------------
  static Future<void> initZegoEngine() async {
    if (engine != null) return;

    final profile = ZegoEngineProfile(
      appID,
      ZegoScenario.General,
      appSign: appSign,
    );
    ZegoExpressEngine.createEngineWithProfile(profile);
    engine = ZegoExpressEngine.instance;
    print("✅ Zego Engine Initialized");
  }

  // ✅ Initialize User (ZIMKit)
  // ----------------------------------------------------------------
  static Future<void> initZego(edit.EditUser user) async {
    currentUserId = user.id;
    currentUserName = user.name?.firstName ?? "User";
    currentUserAvatar = user.profilePic ?? "";

    await ZIMKit().connectUser(
      id: currentUserId!,
      name: currentUserName!,
      avatarUrl: currentUserAvatar!,
    );

    print("👤 ZIMKit user connected => $currentUserId ($currentUserName)");
  }

  // ----------------------------------------------------------------
  //  Outgoing Call using Zego Call Invitation (v4.x compatible)
  // ----------------------------------------------------------------
static Future<void> startCall({
  required dynamic targetUser,
  required bool isVideoCall,
}) async {
  String? targetId;
  String? targetName;

  if (targetUser is active.Users) {
    targetId = targetUser.id;
    targetName = targetUser.name?.firstName ?? "User";
  } else if (targetUser is edit.EditUser) {
    targetId = targetUser.id;
    targetName = targetUser.name?.firstName ?? "User";
  } else {
    print("❌ Unsupported target user type");
    return;
  }

  if (currentUserId == null) {
    print("⚠️ Initialize current user before starting call.");
    return;
  }

  // ✅ Ensure ZIMKit connection is active
  if (ZIMKit().currentUser == null) {
    await ZIMKit().connectUser(
      id: currentUserId!,
      name: currentUserName ?? "User",
      avatarUrl: currentUserAvatar ?? "",
    );
    print("🔄 Reconnected ZIM user before call.");
  }

  final callID = DateTime.now().millisecondsSinceEpoch.toString();

  try {
    await ZegoUIKitPrebuiltCallInvitationService().send(
      isVideoCall: isVideoCall,
      invitees: [ZegoCallUser(targetId!, targetName)],
      callID: callID,
      resourceID: "zegouikit_call",
    );
    print("📞 ${isVideoCall ? 'Video' : 'Voice'} call invitation sent to $targetName ($targetId)");
  } catch (e) {
    print("❌ Failed to send call invitation: $e");
  }
}


  // ----------------------------------------------------------------
  // ⚙️ Optional Room Control
  // ----------------------------------------------------------------
  static Future<void> loginRoom(String roomID) async {
    if (engine == null) {
      print("❌ Engine not initialized");
      return;
    }

    await engine!.loginRoom(
      roomID,
      ZegoUser(currentUserId!, currentUserName ?? "User"),
    );
    print("🎉 Joined room: $roomID");
  }

  static Future<void> logoutRoom(String roomID) async {
    await engine?.logoutRoom(roomID);
    print("🚪 Logged out from $roomID");
  }

  static Future<void> startPublishing(String streamID) async {
    await engine?.startPublishingStream(streamID);
    await engine?.startPreview();
    print("📡 Publishing stream: $streamID");
  }

  static Future<void> startPlaying(String streamID, int viewID) async {
    await engine?.startPlayingStream(streamID, canvas: ZegoCanvas(viewID));
    print("🎥 Playing stream: $streamID");
  }

  static Future<void> stopPublishing() async {
    await engine?.stopPublishingStream();
    await engine?.stopPreview();
    print("🛑 Publishing stopped");
  }

  static Future<void> stopPlaying(String streamID) async {
    await engine?.stopPlayingStream(streamID);
    print("🛑 Stopped playing: $streamID");
  }
}
