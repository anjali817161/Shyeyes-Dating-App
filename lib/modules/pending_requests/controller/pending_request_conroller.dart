import 'package:get/get.dart';
import 'package:shyeyes/modules/pending_requests/model/pending_Requests_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class PendingRequestController extends GetxController {
  var isLoading = false.obs;
  var pendingRequests = <Request>[].obs;

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
      pendingRequests.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
