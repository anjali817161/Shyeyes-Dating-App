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

  Future<void> fetchSentLikes() async {
    try {
      isLoading(true);
      String? token = await SharedPrefHelper.getToken(); // token local से ले लो
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
}
