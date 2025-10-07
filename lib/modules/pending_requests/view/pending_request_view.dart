import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/dashboard/controller/dashboard_controller.dart';
import 'package:shyeyes/modules/pending_requests/controller/pending_request_conroller.dart';
import 'package:shyeyes/modules/pending_requests/model/pending_Requests_model.dart';

class PendingRequestView extends StatelessWidget {
  final PendingRequestController controller = Get.put(
    PendingRequestController(),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Pending Requests",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchPendingRequests();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          if (controller.pendingRequests.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pendingRequests.length,
            itemBuilder: (context, index) {
              final req = controller.pendingRequests[index];
              return _buildRequestCard(req);
            },
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            "Loading pending requests...",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "No pending Requests",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pending friend requests will appear here",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Request req) {
    final user = req.recipient;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Profile Avatar
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child:
                        user?.profilePic != null && user!.profilePic!.isNotEmpty
                        ? Image.network(
                            "https://shyeyes-b.onrender.com/uploads/${user.profilePic}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderAvatar();
                            },
                          )
                        : _buildPlaceholderAvatar(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getStatusColor(req.status ?? ''),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getUserName(user),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user?.age != null
                        ? '${user!.age} years old'
                        : 'Age not set',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(req.status ?? '').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      req.status?.toUpperCase() ?? 'UNKNOWN',
                      style: TextStyle(
                        color: _getStatusColor(req.status ?? ''),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Action Button
            IconButton(
              onPressed: () => _showRemoveConfirmation(req),
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_remove,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.person, color: Colors.grey[400], size: 30),
    );
  }

  String _getUserName(Recipient? user) {
    if (user?.name?.firstName != null && user?.name?.lastName != null) {
      return '${user!.name!.firstName} ${user.name!.lastName}';
    } else if (user?.name?.firstName != null) {
      return user!.name!.firstName!;
    } else if (user?.email != null) {
      return user!.email!;
    } else {
      return 'Unknown User';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showRemoveConfirmation(Request req) {
    final controller = Get.find<PendingRequestController>();
    final activeUsersController = Get.find<ActiveUsersController>();

    Get.dialog(
      AlertDialog(
        title: const Text("Remove Request?"),
        content: Text(
          "Are you sure you want to remove ${_getUserName(req.recipient)} from your pending requests?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Call API to remove/cancel request
                await activeUsersController.sendRequest(
                  req.recipient?.id ?? '',
                );
                // Close the dialog **before showing snackbar**
                if (Get.isDialogOpen ?? false) Get.back();

                // Remove the request from the controller list
                controller.pendingRequests.removeWhere((r) => r.id == req.id);

                // Show success snackbar
                // Get.snackbar(
                //   "Success",
                //   "Request removed successfully!",
                //   snackPosition: SnackPosition.BOTTOM,
                //   backgroundColor: Colors.green.withOpacity(0.8),
                //   colorText: Colors.white,
                // );
              } catch (e) {
                // Handle error
                Get.snackbar(
                  "Error",
                  "Failed to remove request.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
              }
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false, // user must choose
    );
  }
}
