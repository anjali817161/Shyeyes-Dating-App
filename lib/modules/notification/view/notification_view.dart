import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
import 'package:shyeyes/modules/invitation/controller/invitation_controller.dart';
import 'package:shyeyes/modules/likes/showlikescontroller.dart';
import 'package:shyeyes/modules/notification/controller/notification_controller.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  final friendController = Get.put(FriendController());
  final invitationController = Get.put(InvitationController());
  final likesController = Get.put(LikesController());
  final notificationsController = Get.put(NotificationsController());

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _fetchAll();
    tabController.addListener(() {
      if (tabController.index == 1) {
        notificationsController.unreadRequests.clear();
      } else if (tabController.index == 2) {
        notificationsController.unreadLikes.clear();
      }
    });
  }

  void _fetchAll() async {
    await Future.wait([
      friendController.fetchFriends(),
      invitationController.fetchInvitations(),
      likesController.fetchLikedProfiles(),
    ]);

    // Mark all new ones as unread
    notificationsController.unreadRequests.addAll(
      invitationController.invitations.map((e) => e.id.toString()).toList(),
    );

    notificationsController.unreadLikes.addAll(
      likesController.likesList.map((e) => e.liker!.sId.toString()).toList(),
    );
  }

  String formatIndianTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return "Just now";
    }

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes}m ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours}h ago";
      } else if (difference.inDays < 7) {
        return "${difference.inDays}d ago";
      } else {
        return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      }
    } catch (e) {
      return "Just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(text: "All"),
            Obx(
              () => Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Requests"),
                    if (notificationsController.unreadRequests.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          notificationsController.unreadRequests.length
                              .toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Likes"),
                    if (notificationsController.unreadLikes.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          notificationsController.unreadLikes.length.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildAllTab(theme),
          _buildRequestsTab(theme),
          _buildLikesTab(theme),
        ],
      ),
    );
  }

  String imageUrl = ApiEndpoints.imgUrl;

  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return "https://via.placeholder.com/150";
    }

    if (imagePath.startsWith("http")) {
      return imagePath;
    }

    return "$imageUrl$imagePath";
  }

  /// 🔹 ALL TAB (Combine all notifications)
  Widget _buildAllTab(ThemeData theme) {
    return Obx(() {
      if (friendController.isLoading.value ||
          invitationController.isLoading.value ||
          likesController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final allNotifications = [
        ..._mapInvitations(invitationController),
        ..._mapLikes(likesController),
      ];

      if (allNotifications.isEmpty) {
        return _buildEmptyState(
          theme,
          "No notifications yet",
          Icons.notifications_off,
        );
      }

      return _buildNotificationList(theme, allNotifications);
    });
  }

  /// 🔹 REQUESTS TAB
  Widget _buildRequestsTab(ThemeData theme) {
    return Obx(() {
      if (invitationController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final items = _mapInvitations(invitationController);
      if (items.isEmpty) {
        return _buildEmptyState(
          theme,
          "No new requests",
          Icons.person_add_disabled,
        );
      }

      return _buildNotificationList(theme, items);
    });
  }

  /// 🔹 LIKES TAB
  Widget _buildLikesTab(ThemeData theme) {
    return Obx(() {
      if (likesController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final items = _mapLikes(likesController);
      if (items.isEmpty) {
        return _buildEmptyState(theme, "No likes yet", Icons.favorite_border);
      }

      return _buildNotificationList(theme, items);
    });
  }

  /// 🔸 Empty State Widget
  Widget _buildEmptyState(ThemeData theme, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔸 Map Invitations -> Unified format
  List<Map<String, dynamic>> _mapInvitations(InvitationController ctrl) {
    return ctrl.invitations.map((inv) {
      final firstName = inv.user1?.name?.firstName ?? "";
      final lastName = inv.user1?.name?.lastName ?? "";
      final fullName = "$firstName $lastName".trim();

      final avatarUrl = getFullImageUrl(inv.user1?.profilePic);

      return {
        "id": inv.id.toString(),
        "name": fullName.isNotEmpty ? fullName : "Someone",
        "avatar": avatarUrl,
        "message": "sent you a friend request",
        "type": "request",
        "time": inv.createdAt ?? "",
        "icon": Icons.person_add,
        "iconColor": Colors.blue,
        "rawData": inv,
      };
    }).toList();
  }

  /// 🔸 Map Likes -> Unified format
  List<Map<String, dynamic>> _mapLikes(LikesController ctrl) {
    return ctrl.likesList.map((like) {
      final firstName = like.liker?.name?.firstName ?? "";
      final lastName = like.liker?.name?.lastName ?? "";
      final fullName = "$firstName $lastName".trim();

      final avatarUrl = getFullImageUrl(like.liker?.profilePic);

      return {
        "id": like.liker?.sId.toString() ?? like.sId.toString(),
        "name": fullName.isNotEmpty ? fullName : "Unknown",
        "avatar": avatarUrl,
        "message": "liked your profile",
        "type": "like",
        "time": like.createdAt ?? "",
        "icon": Icons.favorite,
        "iconColor": Colors.red,
        "rawData": like,
      };
    }).toList();
  }

  /// 🔹 Build Notification List
  Widget _buildNotificationList(
    ThemeData theme,
    List<Map<String, dynamic>> notifications,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final notif = notifications[index];

        final isRequest = notif["type"] == "request";
        final id = notif["id"].toString();
        final isUnread = isRequest
            ? notificationsController.unreadRequests.contains(id)
            : notificationsController.unreadLikes.contains(id);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              print("Tapped on ${notif["name"]}");

              if (notif["type"] == "request") {
                notificationsController.unreadRequests.remove(
                  notif["id"].toString(),
                );
                invitationController.invitations.removeWhere(
                  (inv) => inv.id.toString() == notif["id"].toString(),
                );
              } else if (notif["type"] == "like") {
                notificationsController.unreadLikes.remove(
                  notif["id"].toString(),
                );
                likesController.likesList.removeWhere(
                  (like) => like.sId.toString() == notif["id"].toString(),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUnread
                    ? theme.colorScheme.primary.withOpacity(0.08)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: isUnread
                    ? Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar with notification type indicator
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(notif["avatar"]),
                          radius: 26,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            notif["icon"],
                            color: notif["iconColor"],
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: notif["name"],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: " ${notif["message"]}",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          formatIndianTime(notif["time"]),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Unread indicator and chevron
                  Column(
                    children: [
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const SizedBox(height: 8),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
