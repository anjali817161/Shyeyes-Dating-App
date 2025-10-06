import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class PhotosController extends GetxController {
  RxList<String> photos = <String>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      String token = await SharedPrefHelper.getToken() ?? '';
      var response = await http.get(
        Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.getPhotos), // replace with actual endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['photos'] != null && data['photos'] is List) {
          photos.value = List<String>.from(data['photos']);
        }
      } else {
        errorMessage.value = 'Failed to fetch photos';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
