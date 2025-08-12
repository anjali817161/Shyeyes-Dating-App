import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:shyeyes/modules/home/view/home_view.dart';
import 'package:shyeyes/modules/tabView/view/likes_tab.dart';
import 'package:shyeyes/modules/tabView/view/top_picks_tab.dart';
import 'package:shyeyes/modules/bottom_tab/bottom_navbar.dart';

class LikesScreen extends StatefulWidget {
  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 2;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     Get.offAll(() => HomeView());
        //   },
        // ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/images/logo.png', height: 60),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade300,
          tabs: const [
            Tab(text: '0 likes'),
            Tab(text: 'Top Picks'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [LikesPage(), TopPicksTab()],
      ),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
