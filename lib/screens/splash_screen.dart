import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _revealAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOut),
    );

    startLoading();
  }

  void startLoading() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    setState(() => isCompleted = true);

    await _revealController.forward();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          SizedBox.expand(
            child: Image.asset(
              "assets/images/bgu.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Dark overlay
          Container(
            color: Colors.black.withOpacity(0.45),
          ),

          /// Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(color: Colors.transparent),
          ),

          /// CONTENT
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),

                /// BIG LOGO
                Column(
                  children: const [
                    Icon(
                      Icons.volunteer_activism,
                      size: 130,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "UnityAid",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// LOADING BAR
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: const Center(
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xff38ef7d),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// EXPANDING CIRCLE
          AnimatedBuilder(
            animation: _revealAnimation,
            builder: (context, child) {
              final size = MediaQuery.of(context).size;
              final radius = _revealAnimation.value * size.longestSide * 2.4;

              return Positioned(
                right: -radius / 2,
                bottom: -radius / 2,
                child: Container(
                  width: radius,
                  height: radius,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff134E5E),
                        Color(0xff71B280),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
