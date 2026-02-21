import 'package:flutter/material.dart';
import '../../widgets/user_home/bottom_nav_bar.dart';
import '../../widgets/user_home/home_app_bar.dart';
import '../../widgets/user_home/ask_ai.dart';
import '../../widgets/user_home/side_drawer.dart';
import '../../widgets/theme/app_colors.dart';
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

  List<Widget> pages = [
    const HomePage(isNGO: true),
    const NewsFeedPage(isNGO: true),
    const NGODashboardPage(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      extendBody: true,

      drawer: const SideDrawer(
        role: AppRole.ngo,
      ), // later we can role-control this

      appBar: HomeAppBar(
        onMenuTap: () => _scaffoldKey.currentState!.openDrawer(),
        onProfileTap: openNGOProfile, // ⭐ DIFFERENCE
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

      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: BottomNavBar(
            selectedIndex: selectedIndex,
            onItemTapped: onItemTapped,
            isNGO: true, // ⭐ IMPORTANT
          ),
        ),
      ),
    );
  }
}
