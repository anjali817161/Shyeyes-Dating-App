// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class CallPage extends StatelessWidget {
//   final String callID;
//   final String userID;
//   final String userName;
//   final bool isVideo;

//   const CallPage({
//     Key? key,
//     required this.callID,
//     required this.userID,
//     required this.userName,
//     required this.isVideo,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ZegoUIKitPrebuiltCall(
//         appID: 1855474960, // 🔴 Apna AppID Zego dashboard se dalo
//         appSign:
//             "dffcc3933e01e9debe08f228e3ac8e2f17bcdf8c7556e5f59062d94b6e9d2ffa", // 🔴 Apna AppSign dalo
//         userID: userID,
//         userName: userName,
//         callID: callID,
//         config: isVideo
//             ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//             : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
//       ),
//     );
//   }
// }
