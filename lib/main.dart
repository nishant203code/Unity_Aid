import 'package:day14/screens/create_post/create_post_page.dart';
import 'package:day14/screens/donate/donate_page.dart';
import 'package:day14/screens/ngo_search/ngo_search_page.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/news_feed/news_feed_page.dart';
import 'screens/ngo_home/ngo_dashboard_page.dart';
import 'screens/home/home_page.dart';

void main() {
  runApp(const UnityAidApp());
}

class UnityAidApp extends StatelessWidget {
  const UnityAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UnityAid',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      routes: {
        '/userHome': (_) => const HomePage(isNGO: false),
        '/ngoHome': (_) => const HomePage(isNGO: true),
        '/news': (_) => const NewsFeedPage(),
        '/dashboard': (_) => const NGODashboardPage(),
        '/post': (_) => const CreatePostPage(), // placeholder
        '/ngos': (_) => const NGOSearchPage(), // placeholder
        '/donate': (_) => const DonatePage(), // placeholder for donate page
      },
    );
  }
}
