// lib/modules/accepted/controller/accepted_request_controller.dart

import 'package:get/get.dart';
import 'package:shyeyes/modules/accepted_requests/model/accepted_Requests_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class AcceptedRequestController extends GetxController {
  var isLoading = false.obs;
  var acceptedRequests = <AcceptedRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAcceptedRequests();
  }

  /// Fetch accepted requests
  Future<void> fetchAcceptedRequests() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository.getAcceptedRequests();

      if (response != null && response['requests'] != null) {
        acceptedRequests.assignAll(
          (response['requests'] as List)
              .map((json) => AcceptedRequest.fromJson(json))
              .toList(),
        );
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
