import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';

class FriendListScreen extends StatelessWidget {
  FriendListScreen({super.key});

  // Yeh TextEditingController banaya hai yahan
  final TextEditingController _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FriendController controller = Get.put(FriendController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 2,
        shadowColor: Colors.red.shade100,
        title: Obx(
          () => controller.searchController.isNotEmpty
              ? TextField(
                  controller: _searchTextController,
                  onChanged: (val) {
                    controller.searchController.value = val;
                  },
                  decoration: InputDecoration(
                    hintText: "Search friends by name...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  autofocus: true,
                )
              : const Text(
                  "Friends List",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            bool isSearching = controller.searchController.isNotEmpty;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                key: ValueKey(isSearching),
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (isSearching) {
                    _searchTextController.clear();
                    controller.searchController.value = "";
                  } else {
                    controller.searchController.value = " ";
                    Future.delayed(Duration.zero, () {
                      controller.searchController.value = "";
                    });
                  }
                },
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                SizedBox(height: 16),
                Text(
                  "Loading friends...",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Friends Counter with improved design
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade50, Colors.red.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade200, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade100.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TOTAL FRIENDS",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.filteredFriends.length.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.people_alt_rounded,
                        size: 32,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Results Info with better styling
              if (controller.searchController.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Search results for '${controller.searchController.value}'",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        "${controller.filteredFriends.length} found",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              if (controller.searchController.isNotEmpty)
                const SizedBox(height: 12),

              // Friends List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.filteredFriends.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline_rounded,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                controller.searchController.isNotEmpty
                                    ? "No friends found"
                                    : "No friends yet",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.searchController.isNotEmpty
                                    ? "Try searching with a different name"
                                    : "Start adding friends to build your network",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: controller.filteredFriends.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final friend = controller.filteredFriends[index];
                        return _FriendListItem(
                          friend: friend,
                          onTap: () {
                            // Get.to(
                            //   () => AboutView(
                            //     profileData: AboutModel(
                            //       image: friend.profilePic ?? "",
                            //       name: friend.name ?? "No Name",
                            //       age: friend.age ?? 0,
                            //       distance: "2 km away",
                            //       job: "Not specified",
                            //       college: "Not specified",
                            //       location: "Unknown",
                            //       about: "No about info",
                            //       interests: ["Unknown"],
                            //       pets: "N/A",
                            //       drinking: "N/A",
                            //       smoking: "N/A",
                            //       workout: "N/A",
                            //       zodiac: "N/A",
                            //       education: "N/A",
                            //       vaccine: "N/A",
                            //       communication: "N/A",
                            //       height: "",
                            //       active: "Recently",
                            //     ),
                            //   ),
                            // );
                          },
                          onDelete: () => controller.unfriendFriend(friend.id!),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _FriendListItem extends StatelessWidget {
  final dynamic friend;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FriendListItem({
    required this.friend,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = friend.profilePic != null && friend.profilePic!.isNotEmpty;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.red.shade50,
        highlightColor: Colors.red.shade100,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width - 32, // Prevent overflow
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              // Profile Avatar with improved design
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red.shade300, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade100.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 28, // Slightly reduced to fit better
                      backgroundColor: Colors.red.shade50,
                      backgroundImage: hasImage
                          ? NetworkImage(friend.profilePic!)
                          : null,
                      child: !hasImage
                          ? Icon(
                              Icons.person_rounded,
                              size: 28,
                              color: Colors.red.shade300,
                            )
                          : null,
                    ),
                  ),

                  // Online indicator
                ],
              ),
              const SizedBox(width: 12), // Reduced spacing
              // Friend Info with better layout and constraints
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            friend.name ?? "Unknown Name",
                            style: const TextStyle(
                              fontSize: 16, // Slightly smaller
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4), // Reduced spacing
                    // Additional info row with wrapping
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Age: ${friend.age} Years Old",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Status indicator
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Online",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete Button with better design
              IconButton(
                onPressed: onDelete,
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ), // Reduced padding
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "UnFriend",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
