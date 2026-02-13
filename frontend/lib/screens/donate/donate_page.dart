import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import 'widgets/donation_stats.dart';
import 'widgets/donation_target_selector.dart';

class DonatePage extends StatelessWidget {
  final String? prefilledCaseId;

  const DonatePage({
    super.key,
    this.prefilledCaseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Donate",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DonationStats(),
            const SizedBox(height: 24),
            DonationTargetSelector(
              prefilledCaseId: prefilledCaseId,
            ),
          ],
        ),
      ),
    );
  }
}
