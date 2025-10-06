import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class VideoCallPage extends StatefulWidget {
  final String roomID;
  final String userID;
  final String userName;

  const VideoCallPage({
    Key? key,
    required this.roomID,
    required this.userID,
    required this.userName,
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

  /// ✅ Timer
  Timer? callTimer;
  int callDuration = 0; // seconds

  @override
  void initState() {
    super.initState();
    initZegoEngine();
  }

  Future<void> initZegoEngine() async {
    ZegoExpressEngine.onRoomStateUpdate = (
      roomID,
      state,
      errorCode,
      extendedData,
    ) {
      debugPrint("Room state update: $state, error: $errorCode");
    };

    ZegoExpressEngine.onRoomStreamUpdate = (
      roomID,
      updateType,
      streamList,
      extendedData,
    ) {
      if (updateType == ZegoUpdateType.Add) {
        debugPrint("Remote stream added: ${streamList.first.streamID}");
        setState(() {
          remoteStreamID = streamList.first.streamID;
        });
        startPlayingStream(streamList.first.streamID);

        /// ✅ Start Timer when call is connected
        startCallTimer();
      } else if (updateType == ZegoUpdateType.Delete) {
        debugPrint("Remote stream removed: ${streamList.first.streamID}");
        if (remoteStreamID == streamList.first.streamID) {
          setState(() {
            remoteStreamID = null;
            playViewWidget = null;
            playViewID = null;
          });

          /// ✅ Auto end call if other user leaves
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              endCall();
            }
          });
        }
        ZegoExpressEngine.instance.stopPlayingStream(streamList.first.streamID);
      }
    };

    joinRoom();
  }

  /// Start Playing
  Future<void> startPlayingStream(String streamID) async {
    final playView = await ZegoExpressEngine.instance.createCanvasView((viewID) {
      playViewID = viewID;
      ZegoExpressEngine.instance.startPlayingStream(
        streamID,
        canvas: ZegoCanvas(viewID),
      );
    });

    setState(() {
      playViewWidget = playView;
    });
  }

  /// Join Room
  Future<void> joinRoom() async {
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
  }

  /// ✅ Timer Start
  void startCallTimer() {
    callTimer?.cancel();
    callDuration = 0;
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        callDuration++;
      });
    });
  }

  /// ✅ Timer Stop
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
      await ZegoExpressEngine.instance.logoutRoom(widget.roomID);
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
    } catch (e) {
      debugPrint("Error ending call: $e");
    }

    if (mounted) {
      Navigator.pop(context);
    }
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
          'Video Call - ${widget.roomID}',
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
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          if (previewViewWidget != null)
            Positioned(
              right: 16,
              top: 50,
              width: 120,
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: previewViewWidget!,
              ),
            ),

          /// Bottom Controls
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
