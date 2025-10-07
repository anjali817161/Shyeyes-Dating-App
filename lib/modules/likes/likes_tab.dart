import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';
import 'package:shyeyes/modules/likes/showlikescontroller.dart';
import 'package:intl/intl.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final LikesController controller = Get.put(LikesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Likes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.primary.withOpacity(0.02),
              Colors.transparent,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          if (controller.errorMessage.isNotEmpty) {
            return _buildErrorState(controller.errorMessage.value, theme);
          }

          if (controller.likesList.isEmpty) {
            return _buildEmptyState(context, theme);
          }

          return _buildLikesList(controller, theme);
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading your likes...",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              "Oops! Something went wrong",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.find<LikesController>().fetchLikedProfiles();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Try Again",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              "No Likes Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "When someone likes your profile, they'll appear here. Start connecting with people to get more likes!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikesList(LikesController controller, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.likesList.length,
      itemBuilder: (context, index) {
        final like = controller.likesList[index];
        final likedUser = like.liker;
        final createdAt = like.createdAt;

        return GestureDetector(
          onTap: () {
            // Navigate to about page when profile is clicked
            if (likedUser != null) {
              Get.to(() => AboutView(userId: likedUser?.sId ?? ''));
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture with Online Indicator
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child:
                                (likedUser?.profilePic != null &&
                                    likedUser!.profilePic!.isNotEmpty)
                                ? Image.network(
                                    "https://shyeyes-b.onrender.com/uploads/${likedUser.profilePic!}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholderAvatar(theme);
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return _buildPlaceholderAvatar(theme);
                                        },
                                  )
                                : _buildPlaceholderAvatar(theme),
                          ),
                        ),
                        // Online Status Indicator
                        if (likedUser?.status?.toLowerCase() == "active")
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // User Info and Like Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Age Row
                          Row(
                            children: [
                              Text(
                                "${likedUser?.name?.firstName ?? ''} ${likedUser?.name?.lastName ?? ''}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (likedUser?.age != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${likedUser!.age}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // Like Message
                          Text(
                            "liked your profile",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Date and Time
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDateTime(createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),

                          // Status with better styling
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (likedUser?.status?.toLowerCase() == "active")
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color:
                                      (likedUser?.status?.toLowerCase() ==
                                          "active")
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 8,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  (likedUser?.status?.toLowerCase() == "active")
                                      ? "Online Now"
                                      : "Offline",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        (likedUser?.status?.toLowerCase() ==
                                            "active")
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chevron Icon
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderAvatar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: 30, color: Colors.grey.shade400),
    );
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return "Recently";

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inHours < 1) {
        return "${difference.inMinutes} min ago";
      } else if (difference.inDays < 1) {
        return "${difference.inHours} hours ago";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        return DateFormat('MMM dd, yyyy').format(dateTime);
      }
    } catch (e) {
      return "Recently";
    }
  }
}
