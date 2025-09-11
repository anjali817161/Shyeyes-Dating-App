import 'package:flutter/material.dart';
import 'package:shyeyes/modules/chats/view/users_chat.dart';
import 'package:shyeyes/modules/dashboard/view/dashboard_view.dart';
import 'package:shyeyes/modules/profile/view/profile_view.dart';
import 'package:shyeyes/modules/likes/likes_tab.dart';
import 'package:shyeyes/modules/chats/view/chats_view.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;
  late List<Widget> _screens;
  bool playHeartAnimation = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _screens = [DashboardPage(), ChatLobbyPage(),  LikesPage()];
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
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                  size: 28,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Empty, heart will be custom
                label: "",
                
                
                
                
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _currentIndex == 2
                
                      ? Icons.auto_awesome
                      : Icons.auto_awesome_outlined,
                  size: 26,
                  
                ),
                
                label: "Likes",
              ),
            ],
          ),
          // Floating heart button
          Positioned(
            top: -20, // Half outside
            left: MediaQuery.of(context).size.width / 2 - 30, // Centered
            child: GestureDetector(
              onTap: () => _onTabTapped(1),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  child: Icon(
                  _currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
                  color: _currentIndex == 1 ? Colors.red : Colors.grey[700],
                  
                  size: 32,
                ),
                onTap: () => _onTabTapped(1),
              ),
              ),

            ),
          ),
        ],
      ),
    );
  }
}
