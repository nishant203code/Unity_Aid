import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/theme/app_colors.dart';
import '../../services/auth_service.dart';

class NGODashboardPage extends StatefulWidget {
  const NGODashboardPage({super.key});

  @override
  State<NGODashboardPage> createState() => _NGODashboardPageState();
}

class _NGODashboardPageState extends State<NGODashboardPage> {
  List<Map<String, dynamic>> activeCases = [];
  List<Map<String, dynamic>> completedCases = [];
  bool _isLoading = true;
  int _totalCases = 0;

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      // Load posts created by this NGO user
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('createdBy', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      final active = <Map<String, dynamic>>[];
      final completed = <Map<String, dynamic>>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        data['docId'] = doc.id;
        if (data['status'] == 'completed') {
          completed.add(data);
        } else {
          active.add(data);
        }
      }

      if (mounted) {
        setState(() {
          activeCases = active;
          completedCases = completed;
          _totalCases = snapshot.docs.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> markCompleted(int index) async {
    try {
      final caseData = activeCases[index];
      final docId = caseData['docId'] as String?;

      if (docId != null) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(docId)
            .update({'status': 'completed'});
      }

      setState(() {
        final removed = activeCases.removeAt(index);
        completedCases.add(removed);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating case: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          /// ðŸ”¥ STATS GRID (ZERO OVERFLOW GUARANTEED)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                statCard("Active Cases", "${activeCases.length}", Icons.medical_services, context),
                statCard("Funds Managed", "₹8.2L", Icons.account_balance, context),
                statCard("Total Posts", "$_totalCases", Icons.verified, context),
                statCard("Completed", "${completedCases.length}", Icons.check_circle, context),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,

                /// â­ MAGIC LINE â€” prevents overflow forever
                mainAxisExtent: 130,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 28),
          ),

          /// ACTIVE CASES
          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ))
                : buildCasesSection(
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
            child: _isLoading
                ? const SizedBox()
                : buildCasesSection(
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

  /// â­ PREMIUM STAT CARD
  Widget statCard(String title, String value, IconData icon, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              color: AppColors.primary.withValues(alpha: 0.12),
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
                    color: Theme.of(context).textTheme.bodySmall?.color,
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
    required List<Map<String, dynamic>> cases,
    required bool isActive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            ...cases.asMap().entries.map(
              (entry) {
                final index = entry.key;
                final caseData = entry.value;
                final caseTitle = caseData['title'] as String? ?? 'Untitled Case';
                final caseId = caseData['docId'] as String? ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder_copy_outlined),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              caseTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (caseId.isNotEmpty)
                              Text(
                                "ID: ${caseId.substring(0, caseId.length.clamp(0, 8))}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isActive)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => markCompleted(index),
                          child: const Text("Completed"),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
