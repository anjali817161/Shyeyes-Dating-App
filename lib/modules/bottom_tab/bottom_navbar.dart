// bottom_navbar.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int? centerHeartPlayKey;

  const BottomNavBar({required this.currentIndex, required this.onTap, this.centerHeartPlayKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: "Explore",
        ),
        BottomNavigationBarItem(
          icon: _CenterHeartIcon(
            playKey: null,
          ),
          activeIcon: _CenterHeartIcon(
            playKey: centerHeartPlayKey,
          ),
          label: "Likes",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Chats",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}

class _CenterHeartIcon extends StatelessWidget {
  final int? playKey;

  const _CenterHeartIcon({this.playKey});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.favorite_outline),
        if (playKey != null)
          IgnorePointer(
            ignoring: true,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Lottie.asset(
                'assets/lotties/newHeart.json',
                key: ValueKey(playKey),
                repeat: false,
              ),
            ),
          ),
      ],
    );
  }
}
