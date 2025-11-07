import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shyeyes/modules/subscription/model/subscription_model.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class PlanController extends GetxController {
  var isLoading = false.obs;
  var plansList = <Plan>[].obs;

  Rx<SubscriptionModel?> subscription = Rx<SubscriptionModel?>(null);

  final String baseUrl = "https://shyeyes-b.onrender.com/api";

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  // Fetch all plans
  Future<void> fetchPlans() async {
    final String token = await SharedPrefHelper.getToken() ?? '';

    try {
      isLoading.value = true;

      final uri = Uri.parse("$baseUrl/plans");
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

  // Step 2: Create Checkout
  Future<Map<String, dynamic>?> createCheckout(String planId) async {
    final String token = await SharedPrefHelper.getToken() ?? '';

    print(token);

    try {
      isLoading.value = true;
      final uri = Uri.parse("$baseUrl/payments/checkout");
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'planId': planId}),
      );
      print("body: ${response.body}");
      print("status code: ${response.statusCode}");
      print(planId);

      final data = json.decode(response.body);
      if (data['success'] == true) {
        return data;
      } else {
        Get.snackbar("Error", data['message'] ?? "Checkout failed");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Verify Payment
  Future<bool> verifyPayment({
    required String planId,
    required String orderId,
    String paymentId = "bypass",
    String signature = "bypass",
  }) async {
    final String token = await SharedPrefHelper.getToken() ?? '';

    try {
      isLoading.value = true;
      final uri = Uri.parse("$baseUrl/payments/verify");
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'planId': planId,
          'orderId': orderId,
          'paymentId': paymentId,
          'signature': signature,
        }),
      );

      final data = json.decode(response.body);
      if (data['success'] == true) {
        subscription.value = SubscriptionModel.fromJson(data['subscription']);
        Get.snackbar("Success", data['message'] ?? "Subscription activated");
        return true;
      } else {
        Get.snackbar("Error", data['message'] ?? "Payment verification failed");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Full purchase flow (button click)
  Future<void> purchasePlan(String planId) async {
    final checkout = await createCheckout(planId);
    if (checkout != null) {
      final orderId = checkout['order']['id'];
      final bypass = checkout['bypass'] ?? false;

      // If free plan or bypass mode, directly verify
      if (bypass) {
        await verifyPayment(planId: planId, orderId: orderId);
      } else {
        // Integrate real payment gateway here (Razorpay etc.)
        Get.snackbar("Info", "Integrate payment gateway for paid plans");
      }
    }
  }
}
