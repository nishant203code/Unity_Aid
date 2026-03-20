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
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        color: AppColors.background, // use your theme color
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      floatingActionButton: const AskAI(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: SafeArea(
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
    );
  }
}
