import 'package:flutter/material.dart';
import '../../widgets/user_home/bottom_nav_bar.dart';
import '../../widgets/user_home/home_app_bar.dart';
import '../../widgets/user_home/ask_ai.dart';
import '../../widgets/user_home/side_drawer.dart';
import '../home/home_page.dart';
import '../news_feed/news_feed_page.dart';
import 'ngo_dashboard_page.dart'; // create later
import 'ngo_profile_page.dart'; // create later

class NGOHomePage extends StatefulWidget {
  const NGOHomePage({super.key});

  @override
  State<NGOHomePage> createState() => _NGOHomePageState();
}

class _NGOHomePageState extends State<NGOHomePage> {
  int selectedIndex = 0;
  bool _navBarVisible = true;

  List<Widget> pages = [
    const HomePage(isNGO: true),
    const NewsFeedPage(isNGO: true),
    const NGODashboardPage(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      _navBarVisible = true;
    });
  }

  void openNGOProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NGOProfilePage(),
      ),
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 2 && _navBarVisible) {
        setState(() => _navBarVisible = false);
      } else if (delta < -2 && !_navBarVisible) {
        setState(() => _navBarVisible = true);
      }
    }
    if (notification is ScrollUpdateNotification &&
        notification.metrics.pixels <= 0) {
      setState(() => _navBarVisible = true);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBody: true,

        drawer: const SideDrawer(
          role: AppRole.ngo,
        ),

        appBar: HomeAppBar(
          onMenuTap: () => _scaffoldKey.currentState!.openDrawer(),
          onProfileTap: openNGOProfile,
        ),

        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: IndexedStack(
            index: selectedIndex,
            children: pages,
          ),
        ),

        floatingActionButton: const AskAI(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        bottomNavigationBar: AnimatedSlide(
          offset: _navBarVisible ? Offset.zero : const Offset(0, 1),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: _navBarVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 220),
            child: SafeArea(
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: BottomNavBar(
                  selectedIndex: selectedIndex,
                  onItemTapped: onItemTapped,
                  isNGO: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
