import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  final String roomID;
  final String userID;
  final String userName;
  final String? userPic;
  final String? receiverName;
  final String receiverId;

  const VideoCallPage({
    Key? key,
    required this.roomID,
    required this.userID,
    required this.userName,
    required this.receiverId,
    this.userPic,
    this.receiverName,
  }) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool micOn = true;
  bool cameraOn = true;
  bool isJoined = false;
  bool isFrontCamera = true;
  bool isSpeakerOn = true;
  String? remoteStreamID;
  Widget? previewViewWidget;
  Widget? playViewWidget;
  int? previewViewID;
  int? playViewID;

  Timer? callTimer;
  int callDuration = 0;

  @override
  void initState() {
    super.initState();
    _checkAndInit();
  }

  /// ✅ Step 1: Check permissions before initializing Zego
  Future<void> _checkAndInit() async {
    final cam = await Permission.camera.request();
    final mic = await Permission.microphone.request();

    if (cam.isGranted && mic.isGranted) {
      await initZegoEngine();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please allow camera & microphone permissions to start the call."),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  /// ✅ Step 2: Initialize Engine
  Future<void> initZegoEngine() async {
    debugPrint("🚀 Initializing Zego Engine for Video Call...");

    ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
      debugPrint("Room [$roomID] State: $state, Error: $errorCode");
    };

    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) {
      if (updateType == ZegoUpdateType.Add && streamList.isNotEmpty) {
        final streamID = streamList.first.streamID;
        debugPrint("🟢 Remote Stream Added: $streamID");
        setState(() => remoteStreamID = streamID);
        startPlayingStream(streamID);
        startCallTimer();
      } else if (updateType == ZegoUpdateType.Delete && streamList.isNotEmpty) {
        final streamID = streamList.first.streamID;
        debugPrint("🔴 Remote Stream Removed: $streamID");
        if (remoteStreamID == streamID) {
          setState(() {
            remoteStreamID = null;
            playViewWidget = null;
            playViewID = null;
          });

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) endCall();
          });
        }
        ZegoExpressEngine.instance.stopPlayingStream(streamID);
      }
    };

    await joinRoom();
  }

  /// ✅ Step 3: Join Room
  Future<void> joinRoom() async {
    try {
      debugPrint("Joining Room ID: ${widget.roomID}");
      debugPrint("Current User ID: ${widget.userID}");
      debugPrint("Receiver ID: ${widget.receiverId}");

      await ZegoExpressEngine.instance.loginRoom(
        widget.roomID,
        ZegoUser(widget.userID, widget.userName),
      );

      await ZegoExpressEngine.instance.enableCamera(true);
      await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
      await ZegoExpressEngine.instance.muteMicrophone(false);
      await ZegoExpressEngine.instance.setAudioRouteToSpeaker(isSpeakerOn);

      final preview = await ZegoExpressEngine.instance.createCanvasView((viewID) {
        previewViewID = viewID;
        ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas(viewID));
      });

      setState(() {
        previewViewWidget = preview;
        isJoined = true;
      });

      await ZegoExpressEngine.instance.startPublishingStream(widget.userID);
      debugPrint("✅ Joined room successfully");
    } catch (e) {
      debugPrint("❌ Error joining room: $e");
    }
  }

  Future<void> startPlayingStream(String streamID) async {
    final playView = await ZegoExpressEngine.instance.createCanvasView((viewID) {
      playViewID = viewID;
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: ZegoCanvas(viewID));
    });

    setState(() => playViewWidget = playView);
  }

  void startCallTimer() {
    callTimer?.cancel();
    callDuration = 0;
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => callDuration++);
    });
  }

  void stopCallTimer() {
    callTimer?.cancel();
    callTimer = null;
  }

  String formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void toggleMic() {
    setState(() => micOn = !micOn);
    ZegoExpressEngine.instance.muteMicrophone(!micOn);
  }

  void toggleCamera() {
    setState(() => cameraOn = !cameraOn);
    ZegoExpressEngine.instance.enableCamera(cameraOn);
  }

  void switchCamera() {
    setState(() => isFrontCamera = !isFrontCamera);
    ZegoExpressEngine.instance.useFrontCamera(isFrontCamera);
  }

  void toggleSpeaker() {
    setState(() => isSpeakerOn = !isSpeakerOn);
    ZegoExpressEngine.instance.setAudioRouteToSpeaker(isSpeakerOn);
  }

  Future<void> endCall() async {
    stopCallTimer();
    try {
      await ZegoExpressEngine.instance.stopPreview();
      await ZegoExpressEngine.instance.stopPublishingStream();
      if (remoteStreamID != null) {
        await ZegoExpressEngine.instance.stopPlayingStream(remoteStreamID!);
      }

      if (previewViewID != null) {
        ZegoExpressEngine.instance.destroyCanvasView(previewViewID!);
      }
      if (playViewID != null) {
        ZegoExpressEngine.instance.destroyCanvasView(playViewID!);
      }

      await ZegoExpressEngine.instance.logoutRoom(widget.roomID);
      debugPrint("📴 Left Room: ${widget.roomID}");
    } catch (e) {
      debugPrint("⚠️ Error ending call: $e");
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    stopCallTimer();
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onRoomStreamUpdate = null;
    endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.receiverName != null
              ? 'Video Call - ${widget.receiverName}'
              : 'Video Call - ${widget.roomID}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (callDuration > 0)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  formatDuration(callDuration),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (playViewWidget != null)
            Positioned.fill(child: playViewWidget!)
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          if (previewViewWidget != null)
            Positioned(
              right: 16,
              top: 60,
              width: 120,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: previewViewWidget!,
              ),
            ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                controlButton(Icons.mic, micOn, toggleMic),
                controlButton(Icons.videocam, cameraOn, toggleCamera),
                controlButton(Icons.flip_camera_android, true, switchCamera),
                controlButton(Icons.volume_up, isSpeakerOn, toggleSpeaker),
                endCallButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget controlButton(IconData icon, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.2) : Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget endCallButton() {
    return GestureDetector(
      onTap: endCall,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.call_end, color: Colors.white, size: 24),
      ),
    );
  }
}
