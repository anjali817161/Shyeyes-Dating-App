import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shyeyes/firebase_options.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:shyeyes/modules/splash/splash_screen.dart';
import 'package:shyeyes/modules/home/controller/notificationController.dart';
import 'package:shyeyes/modules/theme/theme.dart';
import 'package:shyeyes/modules/widgets/Zego_service.dart';
import 'package:shyeyes/modules/widgets/camera.dart';
import 'package:shyeyes/modules/widgets/music_controller.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

/// 🔹 यह function background में notification handle करेगा
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background Message: ${message.messageId}");

  if (message.data['type'] == 'call') {
    print("📞 Incoming Call from ${message.data['callerName']}");
    // Background me sirf log print hoga
    // yaha tum local notification trigger kara sakte ho agar chaho
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Init
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Push Notification Setup
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// iOS के लिए permission लेनी पड़ती है
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print("🔔 Notification permission: ${settings.authorizationStatus}");
  await requestPermissions();
  // Get FCM Token (हर user का unique होगा)
  String? token = await messaging.getToken();
  print("✅ FCM Token: $token");

  /// 👇 Foreground Message Listener
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  if (message.data['type'] == 'CALL') {
    ZegoService.showIncomingCallDialog(
      callerId: message.data['callerId'],
      callerName: message.data['callerName'],
      roomId: message.data['roomId'],
      isVideoCall: message.data['isVideoCall'] == "true",
    );
  }
});



  /// 🔹 Zego Init
  await ZegoService.initZegoEngine();
  await ZIMKit().init(appID: ZegoService.appID, appSign: ZegoService.appSign);

  /// 🔹 Controllers
  Get.put(ProfileController());
  Get.put(NotificationController());
  Get.put(MusicController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShyEyes',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

/// 🔔 Incoming Call Popup
void _showIncomingCallDialog({
  required String callerName,
  required String callerId,
  required String roomId,
  required bool isVideoCall,
}) {
  Get.dialog(
    AlertDialog(
      title: Text("📞 Incoming ${isVideoCall ? "Video" : "Voice"} Call"),
      content: Text("Caller: $callerName"),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            print("❌ Call Rejected");
          },
          child: const Text("Reject", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            print("✅ Call Accepted");

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
