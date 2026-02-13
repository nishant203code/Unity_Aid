import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';

class NGODashboardPage extends StatefulWidget {
  const NGODashboardPage({super.key});

  @override
  State<NGODashboardPage> createState() => _NGODashboardPageState();
}

class _NGODashboardPageState extends State<NGODashboardPage> {
  List<String> activeCases = [
    "UA10234",
    "UA10456",
  ];

  List<String> completedCases = [];

  void markCompleted(String caseId) {
    setState(() {
      activeCases.remove(caseId);
      completedCases.add(caseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          /// TOP SPACING
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          /// TITLE
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "NGO Dashboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),

          /// 🔥 STATS GRID (ZERO OVERFLOW GUARANTEED)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                statCard("Active Cases", "3", Icons.medical_services),
                statCard("Funds Managed", "₹8.2L", Icons.account_balance),
                statCard("Verification Queue", "12", Icons.verified),
                statCard("Nearby Emergencies", "5", Icons.warning_amber),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,

                /// ⭐ MAGIC LINE — prevents overflow forever
                mainAxisExtent: 130,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 28),
          ),

          /// ACTIVE CASES
          SliverToBoxAdapter(
            child: buildCasesSection(
              title: "Active Cases",
              cases: activeCases,
              isActive: true,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          /// COMPLETED CASES
          SliverToBoxAdapter(
            child: buildCasesSection(
              title: "Completed Cases",
              cases: completedCases,
              isActive: false,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  /// ⭐ PREMIUM STAT CARD
  static Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 12),

          /// TEXT AREA (EXPANDED = NO OVERFLOW)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ⭐ CASE SECTION
  Widget buildCasesSection({
    required String title,
    required List<String> cases,
    required bool isActive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            if (cases.isEmpty)
              Text(
                "No cases yet.",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ...cases.map(
              (caseId) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder_copy_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Case ID: $caseId",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isActive)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => markCompleted(caseId),
                        child: const Text("Completed"),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
