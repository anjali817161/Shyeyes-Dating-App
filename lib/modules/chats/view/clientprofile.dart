import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class UserBottomSheet {
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "User Sheet",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: const Color(0xFFFFF3F3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3F3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Pic
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(color: const Color(0xFFDF314D)),
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Name
                    const Text(
                      "Shaan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Row with Call, Video Call, Share
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Column(
                          children: [
                            Icon(Icons.call, color: Colors.green),
                            Text("Call"),
                          ],
                        ),
                        const Column(
                          children: [
                            Icon(Icons.videocam, color: Colors.blue),
                            Text("Video"),
                          ],
                        ),
                        // 👉 Share icon with onTap
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Share.share(
                                  "Hey! Check out Shaan's profile.\n📞 +91 9876543210\nAbout: Flutter developer & tech enthusiast",
                                  subject: "Profile Share",
                                );
                              },
                              child: const Icon(
                                Icons.share,
                                color: Colors.purple,
                              ),
                            ),
                            const Text("Share"),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Phone Number
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "📞 +91 9876543210",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "About: Flutter developer & tech enthusiast ",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const ListTile(
                      leading: Icon(Icons.block, color: Colors.red),
                      title: Text("Block"),
                    ),

                    const ListTile(
                      leading: Icon(Icons.report, color: Colors.orange),
                      title: Text("Report"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, -1), // 👈 top se aayega
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }
}
