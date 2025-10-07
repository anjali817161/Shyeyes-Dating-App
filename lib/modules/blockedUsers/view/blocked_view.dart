import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/about/controller/block_controller.dart';
import 'package:shyeyes/modules/blockedUsers/controller/blocked_controller.dart';
import 'package:shyeyes/modules/blockedUsers/model/blocked_model.dart';
import 'package:intl/intl.dart';

class BlockedUserView extends StatelessWidget {
  final BlockedUserController controller = Get.put(BlockedUserController());
  final BlockController blockController = Get.put(BlockController());

  BlockedUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blocked Users"),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchBlockedUsers();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Loading blocked users...",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (controller.blockedUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, size: 80, color: Colors.grey.shade400),
                  SizedBox(height: 16),
                  Text(
                    "No Blocked Users",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Users you block will appear here",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header with count
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.block,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Blocked Users",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              "${controller.blockedUsers.length} ${controller.blockedUsers.length == 1 ? 'person' : 'people'} blocked",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You can unblock users anytime",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Blocked users list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: controller.blockedUsers.length,
                  itemBuilder: (context, index) {
                    final BlockedUserModel user =
                        controller.blockedUsers[index];
                    final formattedDate = DateFormat(
                      'MMM dd, yyyy • hh:mm a',
                    ).format(user.blockedAt.toLocal());

                    return _buildBlockedUserCard(
                      user,
                      formattedDate,
                      theme,
                      screenWidth,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBlockedUserCard(
    BlockedUserModel user,
    String formattedDate,
    ThemeData theme,
    double screenWidth,
  ) {
    final isSmallScreen = screenWidth < 360;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        color: theme.cardColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with fallback
                    Stack(
                      children: [
                        Container(
                          width: isSmallScreen ? 50 : 60,
                          height: isSmallScreen ? 50 : 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: user.profilePic != null
                                ? Image.network(
                                    "https://shyeyes-b.onrender.com/uploads/${user.profilePic}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildFallbackAvatar(
                                        theme,
                                        isSmallScreen,
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return _buildFallbackAvatar(
                                            theme,
                                            isSmallScreen,
                                          );
                                        },
                                  )
                                : _buildFallbackAvatar(theme, isSmallScreen),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.cardColor,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.block,
                              color: Colors.white,
                              size: isSmallScreen ? 10 : 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: isSmallScreen ? 12 : 16),

                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "No Name",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 14 : 16,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: isSmallScreen ? 10 : 12,
                                color: Colors.grey.shade500,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: isSmallScreen ? 10 : 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),

                          // Blocked Status - Kept as it is
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "Blocked",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: isSmallScreen ? 9 : 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Unblock Button at Bottom Right Corner
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  height: isSmallScreen ? 32 : 36,
                  child: ElevatedButton(
                    onPressed: () => _showUnblockConfirmation(user, theme),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      "Unblock",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Decorative corner (moved to top left to avoid conflict with button)
              if (!isSmallScreen)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: theme.colorScheme.primary.withOpacity(0.05),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(ThemeData theme, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: theme.colorScheme.primary.withOpacity(0.6),
          size: isSmallScreen ? 22 : 28,
        ),
      ),
    );
  }

  void _showUnblockConfirmation(BlockedUserModel user, ThemeData theme) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_remove,
                  color: Colors.orange,
                  size: 32,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Unblock User?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  user.name.length > 30
                      ? "Are you sure you want to unblock this user?"
                      : "Are you sure you want to unblock ${user.name}?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back(); // Close the dialog first
                        try {
                          // Call unblock API
                          await blockController.toggleBlockUser(user.id);

                          // Show success message
                          Get.snackbar(
                            "Unblocked",
                            "${user.name.length > 30 ? 'User has been unblocked' : '${user.name} has been unblocked'}",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            borderRadius: 12,
                            margin: EdgeInsets.all(16),
                            duration: Duration(seconds: 3),
                          );

                          // Refresh the blocked users list
                          await controller.fetchBlockedUsers();
                        } catch (e) {
                          // Show error message if something goes wrong
                          Get.snackbar(
                            "Error",
                            "Failed to unblock user",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            borderRadius: 12,
                            margin: EdgeInsets.all(16),
                            duration: Duration(seconds: 3),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Unblock",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
