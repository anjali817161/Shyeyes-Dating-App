import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/invitation/controller/invitation_controller.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';

class InvitationPage extends StatelessWidget {
  final InvitationController controller = Get.put(InvitationController());

  InvitationPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchInvitations(); // fetch on load
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Invitations",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchInvitations();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepOrange,
                    ),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Loading invitations...",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (controller.invitations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    "No Invitations Yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You'll see friend requests here",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.invitations.length,
            itemBuilder: (context, index) {
              final invite = controller.invitations[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
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
                                color: Colors.deepOrange.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child:
                                  (invite.user1?.profilePic != null &&
                                      invite.user1!.profilePic!.isNotEmpty)
                                  ? Image.network(
                                      ApiEndpoints.imgUrl +
                                          invite.user1!.profilePic!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.grey[400],
                                                size: 30,
                                              ),
                                            );
                                          },
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey[400],
                                        size: 30,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // User Info and Buttons
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${invite.user1?.name?.firstName ?? ''} ${invite.user1?.name?.lastName ?? ''}"
                                      .trim()
                                      .isEmpty
                                  ? "Unknown User"
                                  : "${invite.user1?.name?.firstName ?? ''} ${invite.user1?.name?.lastName ?? ''}",
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
                              "Friend Request",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => controller.acceptInvite(
                                      invite.user1?.id ?? '',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check, size: 18),
                                        SizedBox(width: 6),
                                        Text(
                                          "Accept",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        controller.cancelInvite(invite.user1?.id ?? ''),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close, size: 18),
                                        SizedBox(width: 6),
                                        Text(
                                          "Reject",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
