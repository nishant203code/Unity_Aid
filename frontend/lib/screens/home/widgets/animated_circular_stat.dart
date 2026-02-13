import 'package:flutter/material.dart';

class AnimatedCircularStat extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const AnimatedCircularStat({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  /// Formats large numbers -> 1200 → 1.2K
  String formatNumber(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// 🔥 Animated Number
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value.toInt()),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            builder: (_, val, __) {
              return Text(
                formatNumber(val),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26, // ⭐ Bigger = premium feel
                  color: color,
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          /// Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
