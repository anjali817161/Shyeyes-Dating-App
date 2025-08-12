// main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/explore/view/explore_view.dart';
import 'package:shyeyes/modules/home/view/home_view.dart';
import 'package:shyeyes/modules/profile/view/profile_view.dart';
import 'package:shyeyes/modules/tabView/view/likes_screen.dart';
import 'package:shyeyes/modules/bottom_tab/bottom_navbar.dart';

class BottomTab extends StatefulWidget {
  final int initialIndex;

  const BottomTab({this.initialIndex = 0});

  @override
  State<BottomTab> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<BottomTab> {
  late int _currentIndex;

  final List<Widget> _screens = [
    HomeView(),
    ExploreView(),
    LikesScreen(),
    // ChatScreen(user: user),
    // ProfileView(),
  ];

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
