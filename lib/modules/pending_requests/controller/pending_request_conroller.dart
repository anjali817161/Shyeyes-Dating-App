// lib/modules/accepted/controller/accepted_request_controller.dart

import 'package:get/get.dart';
import 'package:shyeyes/modules/pending_requests/model/pending_Requests_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class PendingRequestConroller extends GetxController {
  var isLoading = false.obs;
  var acceptedRequests = <Request>[].obs; // ✅ Single Request objects

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
              .map((json) => Request.fromJson(json))
              .toList(),
        );
      }
    } catch (e) {
      print("❌ Error fetching accepted requests: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
