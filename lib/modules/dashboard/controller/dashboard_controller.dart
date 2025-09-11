import 'package:get/get.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class ActiveUsersController extends GetxController {
  final AuthRepository _userRepository = AuthRepository();

  /// Observables
  var isLoading = false.obs;
  var Loading = <int, bool>{}.obs; // per-user loading state

  var activeUsers = <ActiveUserModel>[].obs;
  var errorMessage = "".obs;
  var bestMatches = <BestMatchModel>[].obs;
  var successMessage = "".obs;
  // Keep track of which userIds have requests sent
  var requestStatus = <int, String>{}.obs; // receiverId -> "pending" / "none"
  var sentRequests = <int, int>{}.obs; // receiverId -> requestId

  /// Fetch Active Users
  Future<void> fetchActiveUsers() async {
    try {
      isLoading.value = true;
      final users = await _userRepository.getActiveUsers();
      activeUsers.assignAll(users);
      errorMessage.value = "";
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ Error fetching active users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBestMatches() async {
    try {
      isLoading.value = true;
      final matches = await _userRepository.fetchBestMatches();
      bestMatches.assignAll(matches);
    } catch (e) {
      print("Error fetching matches: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendRequest(int receiverId) async {
    final response = await AuthRepository.sendRequest(receiverId);
    if (response != null && response['request'] != null) {
      int requestId = response['request']['id'];

      // Store requestId
      sentRequests[receiverId] = requestId;
      requestStatus[receiverId] = "pending";

      update();
      Get.snackbar("Success", "Request sent successfully!");
    } else {
      Get.snackbar("Error", "Failed to send request");
    }
  }

  /// Cancel request
  Future<void> cancelRequest(int receiverId) async {
    try {
      final requestId = sentRequests[receiverId];
      if (requestId == null) {
        Get.snackbar("Error", "No request found for this user");
        return;
      }

      print("❌ Canceling request (ID: $requestId) for receiver: $receiverId");
      final response = await AuthRepository.cancelRequest(requestId);

      if (response == null) {
        Get.snackbar("Error", "No response from server");
        return;
      }

      final message = response['message'] ?? '';

      if (message.contains("cancelled") || message.contains("deleted")) {
        requestStatus[receiverId] = "none";
        sentRequests.remove(receiverId);
        Get.snackbar("Success", "Request cancelled");
      } else {
        Get.snackbar("Info", "Could not cancel request");
      }
    } catch (e) {
      print("❌ Error canceling request: $e");
      Get.snackbar("Error", "Could not cancel request");
    }
  }

  bool isRequestSent(int receiverId) => requestStatus[receiverId] == "pending";
}
