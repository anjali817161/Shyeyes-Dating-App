import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  RxBool isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    player.playingStream.listen((playing) {
      isPlaying.value = playing;
    });
    playBackgroundMusic();
  }

  Future<void> playBackgroundMusic() async {
    try {
      await player.setAsset('assets/audio/bg.mp3');
      await player.setLoopMode(LoopMode.all);
      await player.play();
      // isPlaying will be updated by the stream
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void toggleMusic() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
