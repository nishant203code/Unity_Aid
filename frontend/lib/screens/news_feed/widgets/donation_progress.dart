import 'package:flutter/material.dart';
import '../../../widgets/theme/app_colors.dart';

class DonationProgress extends StatelessWidget {
  final double raised;
  final double goal;

  const DonationProgress({
    super.key,
    required this.raised,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final progress = raised / goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "₹${raised.toInt()} / ₹${goal.toInt()}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 90,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            color: AppColors.primary,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
