import 'package:flutter/material.dart';
import '../../../models/donation_case_model.dart';
import '../../../widgets/theme/app_colors.dart';
import '../donate_page.dart';

class CaseDetailDialog extends StatelessWidget {
  final DonationCase donationCase;
  const CaseDetailDialog({super.key, required this.donationCase});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2)),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image
                      Stack(
                        children: [
                          Image.network(
                            donationCase.imageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 250,
                              color: isDark
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.grey.shade200,
                              child: Icon(Icons.image,
                                  size: 64, color: theme.iconTheme.color),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                              style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54),
                            ),
                          ),
                          if (donationCase.isVerified)
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(16)),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text('Verified Case',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category and Urgency chips
                            Row(
                              children: [
                                _chip(donationCase.category, AppColors.primary),
                                const SizedBox(width: 8),
                                _chip(
                                    '${donationCase.urgencyLevel} Priority',
                                    _getUrgencyColor(
                                        donationCase.urgencyLevel)),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Text(donationCase.title,
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 18,
                                    color: theme.textTheme.bodySmall?.color),
                                const SizedBox(width: 4),
                                Text(donationCase.location,
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 20),

                            _buildProgressSection(theme, isDark),
                            const SizedBox(height: 24),

                            _buildSectionTitle('Beneficiary', theme),
                            _buildInfoCard(
                              isDark: isDark,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('Name',
                                      donationCase.beneficiaryName, theme),
                                  if (donationCase.beneficiaryAge != null) ...[
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                        'Age',
                                        '${donationCase.beneficiaryAge} years',
                                        theme),
                                  ],
                                  if (donationCase.beneficiaryGender !=
                                      null) ...[
                                    const SizedBox(height: 8),
                                    _buildInfoRow('Gender',
                                        donationCase.beneficiaryGender!, theme),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            _buildSectionTitle('The Story', theme),
                            _buildInfoCard(
                              isDark: isDark,
                              child: Text(donationCase.caseStory,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(height: 1.6, fontSize: 15)),
                            ),
                            const SizedBox(height: 20),

                            _buildSectionTitle('Fund Breakdown', theme),
                            _buildInfoCard(
                              isDark: isDark,
                              child: Column(
                                children: donationCase.requirements
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: entry.key ==
                                                donationCase
                                                        .requirements.length -
                                                    1
                                            ? 0
                                            : 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(Icons.check_circle,
                                              size: 18,
                                              color: AppColors.primary),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(entry.value,
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(fontSize: 14))),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 20),

                            _buildSectionTitle('Current Status', theme),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.blue.withOpacity(0.15)
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Colors.blue.shade400),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text(donationCase.currentStatus,
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.blue.shade200
                                                  : Colors.blue.shade900,
                                              fontSize: 14))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            if (donationCase.additionalImages != null &&
                                donationCase.additionalImages!.isNotEmpty) ...[
                              _buildSectionTitle('Gallery', theme),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      donationCase.additionalImages!.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                          donationCase.additionalImages![index],
                                          width: 180,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                width: 180,
                                                height: 120,
                                                color: isDark
                                                    ? const Color(0xFF2A2A2A)
                                                    : Colors.grey.shade200,
                                                child: const Icon(Icons.image),
                                              )),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            if (donationCase.documents != null &&
                                donationCase.documents!.isNotEmpty) ...[
                              _buildSectionTitle('Supporting Documents', theme),
                              _buildInfoCard(
                                isDark: isDark,
                                child: Column(
                                  children: donationCase.documents!.entries
                                      .map((entry) => ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(
                                                Icons.description,
                                                color: AppColors.primary),
                                            title: Text(entry.key,
                                                style:
                                                    theme.textTheme.bodyMedium),
                                            trailing: Icon(Icons.download,
                                                color: theme.iconTheme.color),
                                          ))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            if (donationCase.handlingNGO != null) ...[
                              _buildSectionTitle('Handled By', theme),
                              _buildInfoCard(
                                isDark: isDark,
                                child: Row(
                                  children: [
                                    if (donationCase.ngoLogoUrl != null)
                                      CircleAvatar(
                                          radius: 24,
                                          backgroundImage: NetworkImage(
                                              donationCase.ngoLogoUrl!)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(donationCase.handlingNGO!,
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          const Text('Verified NGO Partner',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 16, color: theme.iconTheme.color),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Supporters stats
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.green.withOpacity(0.12)
                                    : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatColumn(
                                      Icons.people,
                                      '${donationCase.supportersCount}',
                                      'Supporters',
                                      isDark),
                                  Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.green.withOpacity(0.3)),
                                  _buildStatColumn(
                                      Icons.schedule,
                                      '${donationCase.daysRemaining}',
                                      'Days Left',
                                      isDark),
                                  Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.green.withOpacity(0.3)),
                                  _buildStatColumn(Icons.share, 'Share',
                                      'This Case', isDark),
                                ],
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Fixed Bottom Donate Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Still Needed',
                              style: theme.textTheme.bodySmall),
                          Text(
                              '₹${_formatAmount(donationCase.remainingAmount)}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonatePage(
                                    prefilledCaseId: donationCase.id),
                              ));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.volunteer_activism),
                            SizedBox(width: 8),
                            Text('Donate Now',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12)),
      child: Text(text,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildProgressSection(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹${_formatAmount(donationCase.raisedAmount)}',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('raised of ₹${_formatAmount(donationCase.targetAmount)}',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle),
                child: Text(
                    '${donationCase.progressPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: donationCase.progressPercentage / 100,
              minHeight: 12,
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoCard({required Widget child, bool isDark = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 80,
            child: Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600))),
        Expanded(
            child: Text(value,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildStatColumn(
      IconData icon, String value, String label, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label,
            style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                fontSize: 11)),
      ],
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
