import 'package:get/get.dart';
import 'package:shyeyes/modules/invitation/model/invitation_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';


class InvitationController extends GetxController {
  var isLoading = false.obs;
  var invitations = <ReceivedRequest>[].obs;

  /// Fetch all invitations
  Future<void> fetchInvitations() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository.getInvitations();

      if (response != null && response['requests'] != null) {
        invitations.assignAll(
          (response['requests'] as List)
              .map((json) => ReceivedRequest.fromJson(json))
              .toList(),
        );
      }
    } catch (e) {
      print("❌ Error fetching invitations: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Accept invitation
  Future<void> acceptInvitation(int requestId) async {
    try {
      final response = await AuthRepository.acceptRequest(requestId);
      if (response != null) {
        invitations.removeWhere((inv) => inv.id == requestId);
        Get.snackbar("Success", "Invitation Accepted ✅");
      }
    } catch (e) {
      print("❌ Error accepting invitation: $e");
    }
  }

  // /// Reject invitation
  // Future<void> rejectInvitation(int requestId) async {
  //   try {
  //     final response = await AuthRepository.cancelRequest(requestId);
  //     if (response != null) {
  //       invitations.removeWhere((inv) => inv.id == requestId);
  //       Get.snackbar("Success", "Invitation Rejected ❌");
  //     }
  //   } catch (e) {
  //     print("❌ Error rejecting invitation: $e");
  //   }
  // }
}
