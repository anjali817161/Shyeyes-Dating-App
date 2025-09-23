import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/invitation/controller/invitation_controller.dart';

class InvitationPage extends StatelessWidget {
  final InvitationController controller = Get.put(InvitationController());

  InvitationPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchInvitations(); // fetch on load

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitations"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.invitations.isEmpty) {
          return const Center(child: Text("No Invitations Yet 🎉"));
        }

        return ListView.builder(
          itemCount: controller.invitations.length,
          itemBuilder: (context, index) {
            final invite = controller.invitations[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    invite.sender.img ?? 'https://via.placeholder.com/150',
                  ),
                ),
                title: Text(
                  invite.sender.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text("Sent you a request"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () => controller.acceptInvitation(invite.id),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.cancel, color: Colors.red),
                    //   onPressed: () => controller.rejectInvitation(invite.id),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
