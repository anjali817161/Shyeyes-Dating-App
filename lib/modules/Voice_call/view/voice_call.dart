import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class AudioCallPage extends StatefulWidget {
  final String roomID;
  final String userID;
  final String userName;
  final String? userPic;
  final String? receiverId;
  final String? receiverName;

  const AudioCallPage({
    Key? key,
    required this.roomID,
    required this.userID,
    required this.userName,
    this.userPic,
    this.receiverId,
    this.receiverName,
  }) : super(key: key);

  @override
  State<AudioCallPage> createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  bool micOn = true;
  bool isSpeakerOn = true;
  bool isJoined = false;
  String? remoteStreamID;

  /// ✅ Timer
  Timer? callTimer;
  int callDuration = 0; // seconds

  @override
  void initState() {
    super.initState();
    initZegoEngine();
  }

  Future<void> initZegoEngine() async {
    ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
      debugPrint("Room state update: $state, error: $errorCode");
    };

    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) {
      if (updateType == ZegoUpdateType.Add) {
        debugPrint("🎧 Remote stream added: ${streamList.first.streamID}");
        setState(() => remoteStreamID = streamList.first.streamID);
        ZegoExpressEngine.instance.startPlayingStream(streamList.first.streamID);
        startCallTimer();
      } else if (updateType == ZegoUpdateType.Delete) {
        debugPrint("❌ Remote stream removed: ${streamList.first.streamID}");
        if (remoteStreamID == streamList.first.streamID) {
          setState(() => remoteStreamID = null);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) endCall();
          });
        }
        ZegoExpressEngine.instance.stopPlayingStream(streamList.first.streamID);
      }
    };

    joinRoom();
  }

  /// Join Room
  Future<void> joinRoom() async {
    await ZegoExpressEngine.instance.loginRoom(
      widget.roomID,
      ZegoUser(widget.userID, widget.userName),
    );

    await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
    await ZegoExpressEngine.instance.muteMicrophone(false);
    await ZegoExpressEngine.instance.setAudioRouteToSpeaker(isSpeakerOn);

    setState(() => isJoined = true);
    await ZegoExpressEngine.instance.startPublishingStream(widget.userID);
  }

  /// ✅ Timer Start
  void startCallTimer() {
    callTimer?.cancel();
    callDuration = 0;
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => callDuration++);
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

  void toggleSpeaker() {
    setState(() => isSpeakerOn = !isSpeakerOn);
    ZegoExpressEngine.instance.setAudioRouteToSpeaker(isSpeakerOn);
  }

  Future<void> endCall() async {
    stopCallTimer();
    try {
      await ZegoExpressEngine.instance.logoutRoom(widget.roomID);
      await ZegoExpressEngine.instance.stopPublishingStream();

      if (remoteStreamID != null) {
        await ZegoExpressEngine.instance.stopPlayingStream(remoteStreamID!);
      }
    } catch (e) {
      debugPrint("Error ending call: $e");
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
          'Audio Call - ${widget.receiverName ?? widget.roomID}',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[800],
            backgroundImage:
                widget.userPic != null && widget.userPic!.isNotEmpty ? NetworkImage(widget.userPic!) : null,
            child: widget.userPic == null
                ? const Icon(Icons.person, color: Colors.white, size: 60)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            widget.receiverName ?? "Connecting...",
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),

          /// Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              controlButton(Icons.mic, micOn, toggleMic),
              controlButton(Icons.volume_up, isSpeakerOn, toggleSpeaker),
              endCallButton(),
            ],
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
