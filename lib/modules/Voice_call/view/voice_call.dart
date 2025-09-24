import 'package:flutter/material.dart';

class AudioCallScreen extends StatelessWidget {
  const AudioCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Section
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Abhishek",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Calling",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Image
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/profile.jpg"), // replace with your image
              ),
            ),

            // Bottom Controls
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // More
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[800],
                      child: Icon(Icons.more_horiz, color: Colors.white),
                    ),

                    // Video Call
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[800],
                      child: Icon(Icons.videocam, color: Colors.white),
                    ),

                    // Speaker
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[800],
                      child: Icon(Icons.volume_up, color: Colors.white),
                    ),

                    // Mute
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[800],
                      child: Icon(Icons.mic_off, color: Colors.white),
                    ),

                    // End Call
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
