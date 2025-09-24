import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class AboutController extends GetxController {
  var isLoading = false.obs;
  var aboutModel = Rxn<AboutModel>();

  Future<void> fetchUserProfile(String userId) async {
    try {
      isLoading.value = true;

      String? token = await SharedPrefHelper.getToken();
      final url = "https://shyeyes-b.onrender.com/api/user/$userId";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        aboutModel.value = AboutModel.fromJson(jsonData);
      } else {
        print(" API failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print(" Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
