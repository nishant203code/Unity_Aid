import 'package:flutter/material.dart';
import '../../widgets/user_home/bottom_nav_bar.dart';
import '../../widgets/user_home/side_drawer.dart';
import '../../widgets/user_home/ask_ai.dart';
import '../../widgets/user_home/home_app_bar.dart';
import '../ngo_search/ngo_search_page.dart';
import '../news_feed/news_feed_page.dart';
import '../donate/donate_page.dart';
import '../create_post/create_post_page.dart';
import '../../widgets/theme/app_colors.dart';
import '../home/home_page.dart';
import 'user_profile_page.dart'; // create later

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int selectedIndex = 0;
  String? selectedCaseId;
  bool _navBarVisible = true;
  double _lastScrollOffset = 0;

  List<Widget> get pages => [
        const HomePage(isNGO: false),
        NewsFeedPage(
          onDonateTap: openDonateWithCase, // 🔥 NEW
        ),
        const CreatePostPage(),
        const NGOSearchPage(),
        DonatePage(
          prefilledCaseId: selectedCaseId, // 🔥 NEW
        ),
      ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index != 4) {
        selectedCaseId = null;
      }
      // Always show nav bar when switching tabs
      _navBarVisible = true;
      _lastScrollOffset = 0;
    });
  }

  void openUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UserProfilePage(),
      ),
    );
  }

  void openDonateWithCase(String caseId) {
    setState(() {
      selectedCaseId = caseId;
      selectedIndex = 4; // Donate tab index
      _navBarVisible = true;
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      // Scrolling down → hide; scrolling up → show
      if (delta > 2 && _navBarVisible) {
        setState(() => _navBarVisible = false);
      } else if (delta < -2 && !_navBarVisible) {
        setState(() => _navBarVisible = true);
      }
      _lastScrollOffset = notification.metrics.pixels;
    }
    // Always show when at top
    if (notification is ScrollUpdateNotification &&
        notification.metrics.pixels <= 0) {
      setState(() => _navBarVisible = true);
    }
    return false;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBody: true, // ⭐⭐⭐ CRITICAL
        drawer: const SideDrawer(
          role: AppRole.user,
        ),
        appBar: HomeAppBar(
          onMenuTap: () => _scaffoldKey.currentState!.openDrawer(),
          onProfileTap: openUserProfile,
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor, // theme adaptive
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
                color: Colors.transparent, // ⭐ kills white background
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: BottomNavBar(
                  selectedIndex: selectedIndex,
                  onItemTapped: onItemTapped,
                  isNGO: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
