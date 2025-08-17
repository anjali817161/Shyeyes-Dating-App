import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  var isPlaying = true.obs; // 👈 track music state

  @override
  void onInit() {
    super.onInit();
    playBackgroundMusic();
  }

  Future<void> playBackgroundMusic() async {
    try {
      await player.setAsset('assets/audio/bg.mp3');
      await player.setLoopMode(LoopMode.all);
      await player.play();
      isPlaying.value = true;
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void toggleMusic() {
    if (isPlaying.value) {
      player.pause();
      isPlaying.value = false;
    } else {
      player.play();
      isPlaying.value = true;
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
