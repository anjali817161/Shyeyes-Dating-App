import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class VoiceCallPage extends StatefulWidget {
  final String roomID;
  final String userID;
  final String userName;

  const VoiceCallPage({
    Key? key,
    required this.roomID,
    required this.userID,
    required this.userName,
  }) : super(key: key);

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  bool micOn = true;
  bool isSpeakerOn = false;
  String? remoteStreamID;
  bool isJoined = false;

  @override
  void initState() {
    super.initState();
    initZegoEngine();
    isSpeakerOn = false;
  }

  /// Initialize Zego engine
  Future<void> initZegoEngine() async {
    ZegoExpressEngine.onRoomStateUpdate =
        (roomID, state, errorCode, extendedData) {
      debugPrint("Room state update: $state, error: $errorCode");
    };

    /// Detect when other user publishes a stream
    ZegoExpressEngine.onRoomStreamUpdate =
        (roomID, updateType, streamList, extendedData) {
      if (updateType == ZegoUpdateType.Add) {
        debugPrint("New stream added: ${streamList.first.streamID}");
        setState(() {
          remoteStreamID = streamList.first.streamID;
        });
        ZegoExpressEngine.instance
            .startPlayingStream(streamList.first.streamID);
      } else if (updateType == ZegoUpdateType.Delete) {
        debugPrint("Stream removed: ${streamList.first.streamID}");
        if (remoteStreamID == streamList.first.streamID) {
          setState(() {
            remoteStreamID = null;
          });
        }
        ZegoExpressEngine.instance.stopPlayingStream(streamList.first.streamID);
      }
    };

    joinRoom();
  }

  /// Join the voice call room
  Future<void> joinRoom() async {
    await ZegoExpressEngine.instance.loginRoom(
      widget.roomID,
      ZegoUser(widget.userID, widget.userName),
    );

    await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);

    /// Publish only your microphone audio, no video
    await ZegoExpressEngine.instance.startPublishingStream(widget.userID);

    // set default audio route
    await ZegoExpressEngine.instance.setAudioRouteToSpeaker(isSpeakerOn);

    setState(() {
      isJoined = true;
    });
  }

  /// Toggle microphone mute/unmute
  void toggleMic() {
    setState(() {
      micOn = !micOn;
    });
    ZegoExpressEngine.instance.muteMicrophone(!micOn);
  }

  /// Toggle speaker (loudspeaker vs earpiece)
  void toggleSpeaker() {
    setState(() {
      isSpeakerOn = !isSpeakerOn;
    });
    ZegoExpressEngine.instance.setAudioRouteToSpeaker(isSpeakerOn);
  }

  /// End the call and leave the room
  Future<void> endCall() async {
    await ZegoExpressEngine.instance.logoutRoom(widget.roomID);
    await ZegoExpressEngine.instance.stopPublishingStream();

    if (remoteStreamID != null) {
      await ZegoExpressEngine.instance.stopPlayingStream(remoteStreamID!);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
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
        title: const Text("Voice Call"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 120,
              color: remoteStreamID != null ? Colors.greenAccent : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              remoteStreamID != null
                  ? "Connected with ${widget.userName}"
                  : "Waiting for others to join...",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 50),

            /// Bottom controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Mic button
                FloatingActionButton(
                  backgroundColor: micOn ? Colors.green : Colors.grey,
                  onPressed: toggleMic,
                  heroTag: 'mic',
                  child: Icon(micOn ? Icons.mic : Icons.mic_off),
                ),
                const SizedBox(width: 30),

                /// Speaker toggle button
                FloatingActionButton(
                  backgroundColor: isSpeakerOn ? Colors.orange : Colors.grey,
                  onPressed: toggleSpeaker,
                  heroTag: 'speaker',
                  child: Icon(isSpeakerOn ? Icons.volume_up : Icons.hearing),
                ),
                const SizedBox(width: 30),

                /// End call button
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: endCall,
                  heroTag: 'end',
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
