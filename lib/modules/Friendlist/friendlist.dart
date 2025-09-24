import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/Friendlist/friendlistcontroller.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/about/view/about_view.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FriendController controller = Get.put(FriendController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => controller.searchController.isNotEmpty
              ? TextField(
                  onChanged: (val) => controller.searchController.value = val,
                  decoration: const InputDecoration(
                    hintText: "Search friends...",
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                )
              : const Text("Friend List"),
        ),
        actions: [
          Obx(() {
            bool isSearching = controller.searchController.isNotEmpty;
            return IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                if (isSearching) {
                  controller.searchController.value = "";
                } else {
                  controller.searchController.value = " "; // empty start
                  controller.searchController.value = "";
                }
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Total Friends: ${controller.filteredFriends.length}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3F3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.filteredFriends.isEmpty) {
                      return const Center(child: Text("No Friends Found"));
                    }
                    return ListView.builder(
                      itemCount: controller.filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = controller.filteredFriends[index];
                        return InkWell(
                          onTap: () {
                            // Get.to(
                            //   () => AboutView(
                            //     profileData: AboutModel(
                            //       image: friend.imageUrl,
                            //       name: friend.name,
                            //       age: friend.age,
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
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    friend.imageUrl,
                                  ),
                                ),
                              ),
                              title: Text(
                                friend.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text("Age: ${friend.age}"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    controller.deleteFriend(friend),
                              ),
                            ),
                          ),
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
