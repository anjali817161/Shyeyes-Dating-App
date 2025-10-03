import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/subscription/model/subscription_model.dart';
import 'dart:convert';

import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class PlanController extends GetxController {
  var isLoading = false.obs;
  var plansList = <Plan>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    final String token = await SharedPrefHelper.getToken() ?? '';

    try {
      isLoading.value = true;

      // Replace with your API URL
      final uri = Uri.parse("https://shyeyes-b.onrender.com/api/plans");
      final response = await http.get(
        uri,

        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final planModel = PlanModel.fromJson(data);
        plansList.value = planModel.plans ?? [];
      } else {
        Get.snackbar("Error", "Failed to fetch plans");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
