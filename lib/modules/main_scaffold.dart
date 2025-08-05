import 'package:flutter/material.dart';
import 'package:shyeyes/modules/bottom_tab/bottom_navbar.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';
import 'package:shyeyes/modules/chats/view/users.dart';
import 'package:shyeyes/modules/explore/view/explore_view.dart';
import 'package:shyeyes/modules/home/view/home_view.dart';
import 'package:shyeyes/modules/profile/view/profile_view.dart';
import 'package:shyeyes/modules/tabView/view/likes_screen.dart';
import 'package:shyeyes/modules/chats/model/chat_model.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // // Dummy user for ChatScreen
    // UserModel dummyUser = UserModel(
    //   name: 'Shaan',
    //   imageUrl: 'https://i.pravatar.cc/150?img=65',
    //   lastMessage: "Hey, how are you?🥰",
    // );

    _screens = [
      HomeView(),
      ExploreView(),
      LikesScreen(),
      ProfileListPage(),
      ProfileView(),
    ];
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Likes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
