import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dart:ui';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isNGO;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.isNGO = false,
  });

  Widget navItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index ? AppColors.primary : Colors.black,
      ),
      onPressed: () => onItemTapped(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.iconInactive.withOpacity(0.55),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
              bottom: Radius.circular(25),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: isNGO
                ? [
                    navItem(Icons.home, 0),
                    navItem(Icons.newspaper, 1),
                    navItem(Icons.dashboard, 2),
                  ]
                : [
                    navItem(Icons.home, 0),
                    navItem(Icons.newspaper, 1),
                    GestureDetector(
                      onTap: () => onItemTapped(2),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child:
                            const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                    navItem(Icons.search, 3),
                    navItem(Icons.favorite, 4),
                  ],
          ),
        ),
      ),
    );
  }
}
