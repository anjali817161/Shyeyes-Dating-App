import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
import 'package:shyeyes/modules/invitation/controller/invitation_controller.dart';
import 'package:shyeyes/modules/likes/showlikescontroller.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';

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

  late TabController tabController;

  // For tracking unread items
  final RxSet<String> unreadRequests = <String>{}.obs;
  final RxSet<String> unreadLikes = <String>{}.obs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _fetchAll();
    tabController.addListener(() {
      if (tabController.index == 1) {
        unreadRequests.clear();
      } else if (tabController.index == 2) {
        unreadLikes.clear();
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
    unreadRequests.addAll(
      invitationController.invitations.map((e) => e.id.toString()).toList(),
    );

    unreadLikes.addAll(
      likesController.likesList.map((e) => e.liker!.sId.toString()).toList(),
    );
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
                    if (unreadRequests.isNotEmpty)
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
                          unreadRequests.length.toString(),
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
                    if (unreadLikes.isNotEmpty)
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
                          unreadLikes.length.toString(),
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
      return "https://via.placeholder.com/150"; // fallback image
    }

    // Check if it's already a complete URL
    if (imagePath.startsWith("http")) {
      return imagePath;
    }

    // Otherwise, append your base URL
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
        return const Center(child: Text("No notifications yet"));
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
        return const Center(child: Text("No new requests"));
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
        return const Center(child: Text("No likes yet"));
      }

      return _buildNotificationList(theme, items);
    });
  }

  /// 🔸 Map Invitations -> Unified format
  List<Map<String, dynamic>> _mapInvitations(InvitationController ctrl) {
    return ctrl.invitations.map((inv) {
      final firstName = inv.user1?.name?.firstName ?? "";
      final lastName = inv.user1?.name?.lastName ?? "";
      final fullName = "$firstName $lastName".trim();

      // ✅ Safely build avatar URL
      final avatarUrl = getFullImageUrl(inv.user1?.profilePic);

      return {
        "name": fullName.isNotEmpty ? fullName : "Someone",
        "avatar": avatarUrl,
        "message": "sent you a friend request",
        "type": "request",
        "time": inv.createdAt ?? "",
        "icon": Icons.person_add,
        "iconColor": Colors.blue,
      };
    }).toList();
  }

  /// 🔸 Map Likes -> Unified format
  List<Map<String, dynamic>> _mapLikes(LikesController ctrl) {
    return ctrl.likesList.map((like) {
      final firstName = like.liker?.name?.firstName ?? "";
      final lastName = like.liker?.name?.lastName ?? "";
      final fullName = "$firstName $lastName".trim();

      // ✅ Safely build avatar URL
      final avatarUrl = getFullImageUrl(like.liker?.profilePic);

      return {
        "name": fullName.isNotEmpty ? fullName : "Unknown",
        "avatar": avatarUrl,
        "message": "liked your profile",
        "type": "like",
        "time": like.createdAt ?? "",
        "icon": Icons.favorite,
        "iconColor": Colors.red,
      };
    }).toList();
  }

  /// 🔹 Build Notification List
  Widget _buildNotificationList(
    ThemeData theme,
    List<Map<String, dynamic>> notifications,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[index];

        final isRequest = notif["type"] == "request";
        final id = notif["id"].toString();
        final isUnread = isRequest
            ? unreadRequests.contains(id)
            : unreadLikes.contains(id);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isUnread
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(notif["avatar"]),
                  radius: 26,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white,
                    child: Icon(
                      notif["icon"],
                      color: notif["iconColor"],
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            title: Text.rich(
              TextSpan(
                text: notif["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [TextSpan(text: " ${notif["message"]}")],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              notif["time"].toString().isEmpty
                  ? "Just now"
                  : notif["time"].toString(),
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),

            // ✅ HERE is your onTap
            onTap: () {
              print("Tapped on ${notif["name"]}");

              if (notif["type"] == "request") {
                unreadRequests.remove(notif["id"].toString());
                // Optionally remove from list after accepting
                invitationController.invitations.removeWhere((inv) => inv.id.toString() == notif["id"].toString());
              } else if (notif["type"] == "like") {
                unreadLikes.remove(notif["id"].toString());
                likesController.likesList.removeWhere(
                  (like) => like.sId.toString() == notif["id"].toString(),
                );
              }
            },
          ),
        );
      },
    );
  }
}
