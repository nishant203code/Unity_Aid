import 'package:flutter/material.dart';
import '../../../models/donation_case_model.dart';
import '../../../widgets/theme/app_colors.dart';
import 'case_detail_dialog.dart';

class DonationCaseCard extends StatelessWidget {
  final DonationCase donationCase;
  const DonationCaseCard({super.key, required this.donationCase});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CaseDetailDialog(donationCase: donationCase),
      ),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    donationCase.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : Colors.grey.shade200,
                      child: Icon(Icons.image,
                          size: 64, color: theme.iconTheme.color),
                    ),
                  ),
                ),
                if (donationCase.isVerified)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12)),
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.verified, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('Verified',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: _getUrgencyColor(donationCase.urgencyLevel),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(donationCase.urgencyLevel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category,
                          size: 16, color: theme.textTheme.bodySmall?.color),
                      const SizedBox(width: 4),
                      Text(donationCase.category,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on,
                          size: 16, color: theme.textTheme.bodySmall?.color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(donationCase.location,
                            style: TextStyle(
                                color: theme.textTheme.bodySmall?.color,
                                fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(donationCase.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  Text(donationCase.shortDescription,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),

                  // Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '₹${_formatAmount(donationCase.raisedAmount)} raised',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Goal: ₹${_formatAmount(donationCase.targetAmount)}',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: donationCase.progressPercentage / 100,
                      minHeight: 8,
                      backgroundColor:
                          isDark ? Colors.white12 : Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.people,
                            size: 16, color: theme.textTheme.bodySmall?.color),
                        const SizedBox(width: 4),
                        Text('${donationCase.supportersCount} supporters',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontSize: 12)),
                      ]),
                      Row(children: [
                        Icon(Icons.schedule,
                            size: 16,
                            color: donationCase.isExpiringSoon
                                ? Colors.red
                                : theme.textTheme.bodySmall?.color),
                        const SizedBox(width: 4),
                        Text('${donationCase.daysRemaining} days left',
                            style: TextStyle(
                              color: donationCase.isExpiringSoon
                                  ? Colors.red
                                  : theme.textTheme.bodySmall?.color,
                              fontSize: 12,
                              fontWeight: donationCase.isExpiringSoon
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            )),
                      ]),
                    ],
                  ),

                  if (donationCase.handlingNGO != null) ...[
                    const SizedBox(height: 12),
                    Divider(color: theme.dividerColor),
                    Row(children: [
                      if (donationCase.ngoLogoUrl != null)
                        CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                NetworkImage(donationCase.ngoLogoUrl!),
                            backgroundColor:
                                isDark ? Colors.white12 : Colors.grey.shade200),
                      const SizedBox(width: 8),
                      Text('Handled by: ${donationCase.handlingNGO}',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'critical':
        return Colors.red.shade700;
      case 'high':
        return Colors.orange.shade700;
      case 'medium':
        return Colors.blue.shade700;
      case 'low':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(2)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}
