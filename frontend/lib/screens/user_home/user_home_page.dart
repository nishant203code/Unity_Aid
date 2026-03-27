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

  /// Controls whether the bottom nav bar is visible
  bool _isNavBarVisible = true;

  List<Widget> get pages => [
        const HomePage(isNGO: false),
        NewsFeedPage(
          onDonateTap: openDonateWithCase,
        ),
        const CreatePostPage(),
        const NGOSearchPage(),
        DonatePage(
          prefilledCaseId: selectedCaseId,
        ),
      ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index != 4) {
        selectedCaseId = null;
      }
      // Always show the bar when switching tabs
      _isNavBarVisible = true;
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
      selectedIndex = 4;
      _isNavBarVisible = true;
    });
  }

  /// Called on each scroll notification — hides bar on scroll down, shows on scroll up
  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && _isNavBarVisible) {
        // Scrolling DOWN → hide
        setState(() => _isNavBarVisible = false);
      } else if (delta < 0 && !_isNavBarVisible) {
        // Scrolling UP → show
        setState(() => _isNavBarVisible = true);
      }
    }
    return false; // don't absorb the notification
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBody: true,
        drawer: const SideDrawer(
          role: AppRole.user,
        ),
        appBar: HomeAppBar(
          onMenuTap: () => _scaffoldKey.currentState!.openDrawer(),
          onProfileTap: openUserProfile,
        ),
        body: Container(
          color: AppColors.background,
          child: IndexedStack(
            index: selectedIndex,
            children: pages,
          ),
        ),
        floatingActionButton: const AskAI(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: AnimatedSlide(
          offset: _isNavBarVisible ? Offset.zero : const Offset(0, 1),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: SafeArea(
            child: Container(
              color: Colors.transparent,
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
    );
  }
}
