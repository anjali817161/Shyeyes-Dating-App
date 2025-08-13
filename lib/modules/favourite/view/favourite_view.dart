import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<Map<String, dynamic>> likedProfiles = [
    {
      "name": "Mansi Chaudhary",
      "age": 25,
      "location": "Indore, India",
      "image": "https://randomuser.me/api/portraits/women/44.jpg",
      "liked": true,
      "active": true
    },
    {
      "name": "Rahul Sharma",
      "age": 28,
      "location": "Delhi, India",
      "image": "https://randomuser.me/api/portraits/men/35.jpg",
      "liked": true,
      "active": false
    },
    {
      "name": "Priya Singh",
      "age": 24,
      "location": "Mumbai, India",
      "image": "https://randomuser.me/api/portraits/women/68.jpg",
      "liked": true,
      "active": true
    },
  ];

  void toggleLike(int index) {
    setState(() {
      likedProfiles[index]["liked"] = !likedProfiles[index]["liked"];
      if (!likedProfiles[index]["liked"]) {
        likedProfiles.removeAt(index);
      }
    });
  }

  // void onChatPressed(String name) => debugPrint("Chat with $name");
  // void onCallPressed(String name) => debugPrint("Call to $name");
  // void onVideoCallPressed(String name) => debugPrint("Video call to $name");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dummy user for ChatScreen
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
      body: likedProfiles.isEmpty
          ? const Center(
              child: Text(
                "No favourites yet 💔",
                style: TextStyle(fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.60, // adjusted for better fit
                ),
                itemCount: likedProfiles.length,
                itemBuilder: (context, index) {
                  final profile = likedProfiles[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: theme.cardColor,
                    ),
                    child: Column(
                      children: [
                        // Image section
                        Expanded(
                          flex: 6,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    profile["image"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => toggleLike(index),
                                  child: Icon(
                                    profile["liked"]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: theme.colorScheme.primary,
                                    size: 28,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: profile["active"]
                                            ? Colors.green
                                            : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      profile["active"]
                                          ? "Active now"
                                          : "Offline",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            blurRadius: 3,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Details + icons section
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile["name"],
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.cake,
                                            size: 16,
                                            color:
                                                theme.colorScheme.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${profile["age"]} years",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 16,
                                            color:
                                                theme.colorScheme.primary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            profile["location"],
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: Colors.grey[700],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Action buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildCircleIcon(
                                      icon: Icons.chat_bubble,
                                      onPressed: () =>
                                         Get.to(() => ChatScreen(user: dummyUser)),
                                      theme: theme,
                                    ),
                                    _buildCircleIcon(
                                      icon: Icons.call,
                                      
                                      onPressed: () =>
                                           showDialog(
                            context: context,
                            barrierDismissible: false,
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
                                    SizedBox(height: 10),
                                    Text(
                                      'Subscription Required',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'To Proceed with Audio call, You have to Subscribe your Plan.',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) =>
                                              const SubscriptionBottomSheet(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: Text(
                                        'Subscribe Now',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                                      theme: theme,
                                    ),
                                    _buildCircleIcon(
                                      icon: Icons.videocam,
                                      onPressed: () =>
                                           showDialog(
                            context: context,
                            barrierDismissible: false,
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
                                    SizedBox(height: 10),
                                    Text(
                                      'Subscription Required',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'To Proceed with Video call, You have to Subscribe your Plan.',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) =>
                                              const SubscriptionBottomSheet(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: Text(
                                        'Subscribe Now',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                                      theme: theme,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCircleIcon({
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeData theme,
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
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
      ),
    );
  }
}
