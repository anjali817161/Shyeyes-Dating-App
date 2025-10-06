// lib/modules/pending_requests/controller/pending_request_controller.dart

import 'package:get/get.dart';
import 'package:shyeyes/modules/pending_requests/model/pending_requests_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class PendingRequestController extends GetxController {
  var isLoading = false.obs;
  var pendingRequests = <Request>[].obs; // ✅ Correct name according to model

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  /// Fetch Pending Requests
  Future<void> fetchPendingRequests() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository.getAcceptedRequests();

      if (response != null && response['requests'] != null) {
        pendingRequests.assignAll(
          (response['requests'] as List)
              .map((json) => Request.fromJson(json))
              .toList(),
        );
      } else {
        pendingRequests.clear();
      }
    } catch (e) {
      print("❌ Error fetching pending requests: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
