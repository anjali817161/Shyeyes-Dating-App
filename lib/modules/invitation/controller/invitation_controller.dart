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
  Future<void> acceptInvite(String invitationId) async {
    try {
      final response = await AuthRepository.acceptInvite(invitationId);
      invitations.removeWhere((inv) => inv.id == invitationId);

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

  /// Reject invitation
  Future<void> cancelInvite(String invitationId) async {
    try {
      final response = await AuthRepository.cancelInvite(invitationId);
      invitations.removeWhere((inv) => inv.id == invitationId);

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
