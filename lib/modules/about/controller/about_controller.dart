// about_controller.dart
import 'package:get/get.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';

class AboutController extends GetxController {
  final selectedProfile = Rxn<AboutModel>();

  void setProfile(AboutModel profile) {
    selectedProfile.value = profile;
  }
}
