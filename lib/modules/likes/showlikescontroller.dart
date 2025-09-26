import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/likes/showlikesmodel.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class LikesController extends GetxController {
  var likesList = <Rlikes>[].obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchLikedProfiles();
  }

  Future<void> fetchLikedProfiles() async {
    try {
      isLoading.value = true;
      String? token = await SharedPrefHelper.getToken();
      if (token == null) {
        errorMessage.value = "No token found";
        return;
      }

      http.Response response = await AuthRepository().Showlikesprofiles(token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final data = showlikes.fromJson(jsonData);

        likesList.value = data.rlikes ?? [];
      } else {
        errorMessage.value = "Error: ${response.body}";
      }
    } catch (e) {
      errorMessage.value = "Exception: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
