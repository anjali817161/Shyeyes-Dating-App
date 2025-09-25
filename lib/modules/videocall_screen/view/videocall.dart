import 'package:flutter/material.dart';



class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote video (full screen)
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
            ),
            child: const Center(
              child: Text(
                "Remote Video",
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
            ),
          ),

          // Local video (small preview)
          Positioned(
            bottom: 100,
            right: 20,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Text(
                  "Local Video",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
          ),

          // Top bar with name and call duration
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  "Abhishek",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "0:53",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Right side action buttons
          Positioned(
            top: 100,
            right: 15,
            child: Column(
              children: [
                _circleButton(Icons.person_add, Colors.black54),
                const SizedBox(height: 16),
                _circleButton(Icons.photo_camera, Colors.black54),
                const SizedBox(height: 16),
                _circleButton(Icons.flash_on, Colors.black54),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circleButton(Icons.more_horiz, Colors.black54),
                _circleButton(Icons.videocam, Colors.black54),
                _circleButton(Icons.volume_up, Colors.black54),
                _circleButton(Icons.mic_off, Colors.black54),
                _circleButton(Icons.call_end, Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, Color bgColor) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: bgColor,
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
