import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/favourite/model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class FavouriteController extends GetxController {
  var isLoading = true.obs;
  var likesList = <Likes>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSentLikes();
  }

  /// Fetch favourite profiles
  Future<void> fetchSentLikes() async {
    try {
      isLoading(true);
      String? token = await SharedPrefHelper.getToken();
      if (token == null) {
        print("No token found");
        return;
      }

      http.Response response = await AuthRepository().Sentlikes(token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        var parsed = alllikessent.fromJson(data);
        likesList.value = parsed.likes ?? [];
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Unlike profile locally in this page
  Future<void> unlikeLocally(String userId) async {
    try {
      String? token = await SharedPrefHelper.getToken();
      if (token == null) return;

      // Call API to unlike
      final uri = Uri.parse(
        "https://shyeyes-b.onrender.com/api/likes/$userId/like",
      );
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Remove profile from this controller's likesList only
        likesList.removeWhere((like) => like.liked?.sId == userId);

        Get.snackbar(
          "Removed",
          "Profile removed from favourites",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        print("Failed to unlike: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error in unlikeLocally: $e");
    }
  }
}
