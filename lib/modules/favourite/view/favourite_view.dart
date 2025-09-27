import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/favourite/controller/favorite_controller.dart';
import 'package:shyeyes/modules/favourite/model.dart';

class FavouritePage extends StatelessWidget {
  FavouritePage({Key? key}) : super(key: key);

  final FavouriteController controller = Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    UserModel dummyUser = UserModel(
      name: 'Shaan',
      imageUrl: 'https://i.pravatar.cc/150?img=65',
      lastMessage: "Hey, how are you?🥰",
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Profiles"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.likesList.isEmpty) {
          return const Center(
            child: Text("No favourites yet 💔", style: TextStyle(fontSize: 16)),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.60,
            ),
            itemCount: controller.likesList.length,
            itemBuilder: (context, index) {
              Likes profile = controller.likesList[index];
              final likedUser = profile.liked;

              // full image url
              String profilePicUrl =
                  (likedUser?.profilePic != null &&
                      likedUser!.profilePic!.isNotEmpty)
                  ? "https://shyeyes-b.onrender.com/uploads/${likedUser.profilePic!}"
                  : "";

              // userId safe fallback
              final userId = likedUser?.sId ?? "";

              return InkWell(
                onTap: () {
                  if (userId.isNotEmpty) {
                    Get.to(
                      () => AboutView(userId: userId),
                      transition: Transition.upToDown,
                      duration: const Duration(milliseconds: 400),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: theme.cardColor,
                  ),
                  child: Column(
                    children: [
                      // Profile image
                      Expanded(
                        flex: 6,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: profilePicUrl.isNotEmpty
                                    ? Image.network(
                                        profilePicUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.person, size: 50),
                                      )
                                    : const Center(
                                        child: Icon(Icons.person, size: 50),
                                      ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.favorite,
                                color: theme.colorScheme.primary,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Details
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${likedUser?.name?.firstName ?? ""} ${likedUser?.name?.lastName ?? ""}",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFDF314D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.cake, size: 16),
                                  const SizedBox(width: 4),
                                  Text("${likedUser?.age ?? ''} years"),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "${likedUser?.location?.state ?? ''}, ${likedUser?.location?.country ?? ''}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              // Action buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildCircleIcon(
                                    icon: Icons.chat_bubble,
                                    theme: theme,
                                    onPressed: () {
                                      
                                    },
                                    // onPressed: () => Get.to(
                                    //  // () => ChatScreen(user: dummyUser),
                                    // ),
                                  ),
                                  _buildCircleIcon(
                                    icon: Icons.call,
                                    theme: theme,
                                    onPressed: () => _showSubscriptionDialog(
                                      context,
                                      theme,
                                      "Audio call",
                                    ),
                                  ),
                                  _buildCircleIcon(
                                    icon: Icons.videocam,
                                    theme: theme,
                                    onPressed: () => _showSubscriptionDialog(
                                      context,
                                      theme,
                                      "Video call",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildCircleIcon({
    required IconData icon,
    required ThemeData theme,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
    );
  }

  void _showSubscriptionDialog(
    BuildContext context,
    ThemeData theme,
    String type,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: HeartShapeBorder(),
        backgroundColor: theme.colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.primary,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Subscription Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'To proceed with $type, please subscribe your plan.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => const SubscriptionBottomSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Subscribe Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
