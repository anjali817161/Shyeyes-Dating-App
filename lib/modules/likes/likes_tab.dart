import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/likes/showlikescontroller.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final LikesController controller = Get.put(LikesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Likes"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.likesList.isEmpty) {
          return const Center(
            child: Text(
              "No Likes Found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.likesList.length,
          itemBuilder: (context, index) {
            final like = controller.likesList[index];
            final likedUser = like.liker;

            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ Profile Picture
                    (likedUser?.profilePic != null &&
                            likedUser!.profilePic!.isNotEmpty)
                        ? CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                              "https://shyeyes-b.onrender.com/uploads/${likedUser.profilePic!}",
                            ),
                          )
                        : CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),

                    const SizedBox(width: 16),

                    // ✅ Name + Age + Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            "${likedUser?.name?.firstName ?? ''} ${likedUser?.name?.lastName ?? ''}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Age
                          Text(
                            "Age: ${likedUser?.age ?? '-'}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          //  Status Badge (Chip style)
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color:
                                    (likedUser?.status?.toLowerCase() ==
                                        "active")
                                    ? Colors.green
                                    : Colors.grey,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                (likedUser?.status?.toLowerCase() == "active")
                                    ? "Active"
                                    : "Offline",
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      (likedUser?.status?.toLowerCase() ==
                                          "active")
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
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
    );
  }
}



  // Widget _buildEmptyState(BuildContext context, ThemeData theme) {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Lottie.asset(
  //             'assets/lotties/like_button.json',
  //             height: 120,
  //             width: 120,
  //             fit: BoxFit.fitHeight,
  //           ),
  //           const SizedBox(height: 16),
  //           const Text(
  //             "See people who liked you with ShyEye Gold™",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           const SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: () {
  //              // _showSubscriptionDialog(context, theme);
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: theme.primaryColor,
  //               shape: const StadiumBorder(),
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 32,
  //                 vertical: 12,
  //               ),
  //             ),
  //             child: const Text(
  //               "See who",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _showSubscriptionDialog(BuildContext context, ThemeData theme) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (ctx) => Dialog(
  //       shape: HeartShapeBorder(),
  //       backgroundColor: theme.colorScheme.secondary,
  //       child: Padding(
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               Icons.warning_amber_rounded,
  //               color: theme.colorScheme.primary,
  //               size: 50,
  //             ),
  //             const SizedBox(height: 10),
  //             Text(
  //               'Subscription Required',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //                 color: theme.colorScheme.primary,
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 10),
  //             const Text(
  //               'To see who likes your profile, you have to subscribe your plan.',
  //               style: TextStyle(fontSize: 16),
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () {
  //                 showModalBottomSheet(
  //                   context: context,
  //                   isScrollControlled: true,
  //                   shape: const RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.vertical(
  //                       top: Radius.circular(20),
  //                     ),
  //                   ),
  //                   builder: (context) => const SubscriptionBottomSheet(),
  //                 );
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: theme.colorScheme.primary,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 32,
  //                   vertical: 12,
  //                 ),
  //               ),
  //               child: const Text(
  //                 'Subscribe Now',
  //                 style: TextStyle(fontSize: 16, color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );


//}
