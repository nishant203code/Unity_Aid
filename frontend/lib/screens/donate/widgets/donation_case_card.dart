import 'package:flutter/material.dart';
import '../../../models/donation_case_model.dart';
import '../../../widgets/theme/app_colors.dart';
import 'case_detail_dialog.dart';

class DonationCaseCard extends StatelessWidget {
  final DonationCase donationCase;

  const DonationCaseCard({super.key, required this.donationCase});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => CaseDetailDialog(donationCase: donationCase),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with urgency badge
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      donationCase.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.image, size: 64, color: Colors.grey),
                        ),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        donationCase.urgencyLevel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Location
                  Row(
                    children: [
                      Icon(Icons.category,
                          size: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        donationCase.category,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on,
                          size: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          donationCase.location,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    donationCase.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Short Description
                  Text(
                    donationCase.shortDescription,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\u20B9${_formatAmount(donationCase.raisedAmount)} raised',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Goal: \u20B9${_formatAmount(donationCase.targetAmount)}',
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: donationCase.progressPercentage / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people,
                                  size: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                '${donationCase.supportersCount} supporters',
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: donationCase.isExpiringSoon
                                    ? Colors.red
                                    : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${donationCase.daysRemaining} days left',
                                style: TextStyle(
                                  color: donationCase.isExpiringSoon
                                      ? Colors.red
                                      : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600),
                                  fontSize: 12,
                                  fontWeight: donationCase.isExpiringSoon
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // NGO Info if available
                  if (donationCase.handlingNGO != null) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    Row(
                      children: [
                        if (donationCase.ngoLogoUrl != null)
                          CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                NetworkImage(donationCase.ngoLogoUrl!),
                            backgroundColor: Colors.grey.shade300,
                          ),
                        const SizedBox(width: 8),
                        Text(
                          'Handled by: ${donationCase.handlingNGO}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
    // Format as Indian number system with commas (e.g. 3,20,000)
    final intAmount = amount.toInt();
    final str = intAmount.toString();
    if (str.length <= 3) return str;
    // Indian number format: last 3 digits, then groups of 2
    final lastThree = str.substring(str.length - 3);
    final remaining = str.substring(0, str.length - 3);
    final buffer = StringBuffer();
    for (int i = 0; i < remaining.length; i++) {
      if (i > 0 && (remaining.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[i]);
    }
    return '${buffer.toString()},${lastThree}';
  }
}
