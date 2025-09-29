import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/invitation/model/invitation_model.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class InvitationController extends GetxController {
  var isLoading = false.obs;
  var invitations = <RequestsResponse>[].obs;

  /// Fetch all invitations
  Future<void> fetchInvitations() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository.getInvitations();

      if (response != null && response['requests'] != null) {
        invitations.assignAll(
          (response['requests'] as List)
              .map((json) => RequestsResponse.fromJson(json))
              .toList(),
        );
      }
    } catch (e) {
      print("❌ Error fetching invitations: $e");
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> acceptInvite(String userId) async {
  try {
    final response = await AuthRepository.acceptInvite(userId);
    invitations.removeWhere((inv) => inv.id == userId);

    Get.snackbar(
      'Success',
      response?['message'] ?? 'Invitation accepted successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    fetchInvitations();
    Get.snackbar(
      'Error',
      'Failed to accept invitation: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

Future<void> cancelInvite(String userId) async {
  try {
    final response = await AuthRepository.cancelInvite(userId);
    invitations.removeWhere((inv) => inv.id == userId);

    Get.snackbar(
      'Success',
      response?['message'] ?? 'Invitation rejected successfully',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } catch (e) {
    fetchInvitations();
    Get.snackbar(
      'Error',
      'Failed to reject invitation: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


}
