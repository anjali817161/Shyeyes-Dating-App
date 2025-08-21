import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shyeyes/modules/about/model/about_model.dart';
import 'package:shyeyes/modules/about/widgets/block_bottomsheet.dart';
import 'package:shyeyes/modules/about/widgets/report_bottomsheet.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';

class AboutView extends StatefulWidget {
  final AboutModel profileData;

  AboutView({super.key, required this.profileData});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  bool isLiked = false;
  bool playHeartAnimation = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final secondaryColor = theme.colorScheme.secondary;
    final onSecondaryColor = theme.colorScheme.onSecondary;

   
  AboutModel dummyUser = AboutModel(
    image: 'assets/images/profile_image1.png',
    name: 'Shaan',
    age: 25,
    distance: '2 km away',
    job: 'Software Engineer',
    college: 'IIT Delhi',
    location: 'New Delhi',
    about: 'Loves traveling and coffee.',
    interests: ['Music', 'Travel', 'Coding', 'Gaming'],
    pets: 'Dog',
    drinking: 'Socially',
    smoking: 'No',
    workout: 'Daily',
    zodiac: 'Leo',
    education: 'Masters',
    vaccine: 'Yes',
    communication: 'English, Hindi',
    height: '',
    active: '',
  );

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          widget.profileData.name ?? '',
          style: TextStyle(color: onPrimaryColor),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: onPrimaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image + Bottom Actions in Stack
            GestureDetector(
              onTap: () {
                Get.to(() => AboutView(profileData: dummyUser));
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.profileData.image!,
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(bottom: -28, child: _bottomActions(theme)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.profileData.name ?? '',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: onSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Active ${widget.profileData.active} ago',
              style: TextStyle(color: onSecondaryColor.withOpacity(0.6)),
            ),

            const SizedBox(height: 24),

            _infoTile(theme, Icons.work, "Job", "Software Engineer"),
            _infoTile(theme, Icons.school, "College", "IIT Bombay"),
            _infoTile(theme, Icons.location_on, "Location", "Mumbai"),
            _infoTile(
              theme,
              Icons.info_outline,
              "About",
              "I love building cool apps and exploring new places.",
            ),
            _infoTile(
              theme,
              Icons.favorite,
              "Interests",
              "Music, Coding, Movies",
            ),

            const SizedBox(height: 24),

            _sectionTitle(theme, Icons.chat, "Send a First Impression"),
            const SizedBox(height: 10),
            _firstImpressionBox(theme),

            const SizedBox(height: 30),

            // Share Button
            GestureDetector(
              onTap: () {
                Share.share(
                  'Check out ${widget.profileData.name}\'s profile!',
                  subject: 'Profile from ShyEyes',
                );
              },
              child: _actionButton(theme, "Share Profile"),
            ),

            // Block Button
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlockReasonBottomSheet(
                    onReasonSelected: (reason) {
                      Navigator.pop(context);
                      // Handle block logic
                    },
                  ),
                );
              },
              child: _actionButton(theme, "Block User"),
            ),

            // Report Button
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ReportReasonBottomSheet(
                    onReasonSelected: (reason) {
                      Navigator.pop(context);
                      // Handle report logic
                    },
                  ),
                );
              },
              child: _actionButton(theme, "Report", isDestructive: true),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(ThemeData theme, IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _firstImpressionBox(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Say something to break the ice!",
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: "Write a message...",
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    ThemeData theme,
    String text, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _bottomActions(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Close button
        CircleAvatar(
          radius: 28,
          backgroundColor: theme.colorScheme.surfaceVariant,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.close, color: Colors.blue, size: 28),
          ),
        ),
        const SizedBox(width: 16),

        // Like button with animation
        GestureDetector(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
              if (isLiked) {
                playHeartAnimation = true;
              }
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.surfaceVariant,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),

              if (playHeartAnimation)
                Positioned(
                  top: -77,
                  child: Lottie.asset(
                    'assets/lotties/newHeart.json',
                    width: 200,
                    height: 200,
                    repeat: false,
                    onLoaded: (composition) {
                      Future.delayed(composition.duration, () {
                        if (mounted) {
                          setState(() => playHeartAnimation = false);
                        }
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
