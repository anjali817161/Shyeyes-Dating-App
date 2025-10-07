import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class AboutController extends GetxController {
  var isLoading = false.obs;
  var aboutModel = Rxn<AboutModel>();

  var requestStatus = "cancelled".obs;
  var requestLoading = false.obs;

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

        // ✅ Correctly handle API "Requested" status
        final status =
            aboutModel.value?.user?.friendshipStatus?.toLowerCase() ??
            "cancelled";

        if (status == "requested" || status == "pending") {
          requestStatus.value = "requested";
        } else {
          requestStatus.value = "cancelled";
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Correct: only true if status is "requested" or "pending"
  bool get isRequestPending =>
      requestStatus.value == "requested" || requestStatus.value == "pending";

  Future<void> toggleRequest(String receiverId) async {
    requestLoading.value = true;
    try {
      final response = await AuthRepository.sendRequest(receiverId);
      if (response != null) {
        final status = (response['status'] ?? "cancelled").toLowerCase();

        if (status == "requested" || status == "pending") {
          requestStatus.value = "requested";
        } else {
          requestStatus.value = "cancelled";
        }

        // ✅ Refresh profile after toggle
        await fetchUserProfile(receiverId);
      }
    } finally {
      requestLoading.value = false;
    }
  }
}
