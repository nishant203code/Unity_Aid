import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AskAI extends StatelessWidget {
  const AskAI({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.white.withOpacity(0.15), // glass tint
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.85),
              ),
              child: const Icon(
                Icons.psychology_alt,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
