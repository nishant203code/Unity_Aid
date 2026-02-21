import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import '../../data/sample_donation_cases.dart';
import 'widgets/donation_stats.dart';
import 'widgets/donation_target_selector.dart';
import 'widgets/donation_case_card.dart';

class DonatePage extends StatefulWidget {
  final String? prefilledCaseId;

  const DonatePage({
    super.key,
    this.prefilledCaseId,
  });

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // If prefilled case ID is provided, go directly to donation form
    if (widget.prefilledCaseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController.animateTo(1);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Donate",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Browse Cases"),
            Tab(text: "Direct Donation"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCaseListTab(),
          _buildDirectDonationTab(),
        ],
      ),
    );
  }

  Widget _buildCaseListTab() {
    final allCases = getSampleDonationCases();
    final categories = ['All', 'Medical Emergency', 'Education', 'Disaster Relief', 
                        'Medical Aid', 'Community Development'];

    final filteredCases = selectedCategory == 'All'
        ? allCases
        : allCases.where((c) => c.category == selectedCategory).toList();

    return Column(
      children: [
        // Stats Section
        const Padding(
          padding: EdgeInsets.all(16),
          child: DonationStats(),
        ),

        // Category Filter
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),

        // Cases List
        Expanded(
          child: filteredCases.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No cases found in this category',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredCases.length,
                  itemBuilder: (context, index) {
                    return DonationCaseCard(donationCase: filteredCases[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDirectDonationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DonationStats(),
          const SizedBox(height: 24),
          DonationTargetSelector(
            prefilledCaseId: widget.prefilledCaseId,
          ),
        ],
      ),
    );
  }
}
