import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../widgets/theme/app_colors.dart';
import 'widgets/post_card.dart';

class NewsFeedPage extends StatefulWidget {
  final Function(String caseId)? onDonateTap;
  final bool isNGO;

  const NewsFeedPage({
    super.key,
    this.onDonateTap,
    this.isNGO = false,
  });

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  int _selectedFilter = 0;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Recent', 'icon': Icons.schedule},
    {'label': 'Most Upvoted', 'icon': Icons.thumb_up_outlined},
    {'label': 'Verified', 'icon': Icons.verified_outlined},
    {'label': 'Nearby', 'icon': Icons.location_on_outlined},
    {'label': 'Critical', 'icon': Icons.warning_amber_outlined},
  ];

  final List<Post> _allPosts = [
    // ── 1. Car Accident Emergency ─────────────────────────────────────────────
    Post(
      userName: "Rahul Sharma",
      profilePic: "https://i.pravatar.cc/150?img=5",
      location: "Delhi",
      mediaUrls: [
        "https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800&q=80",
        "https://images.unsplash.com/photo-1516549655169-df83a0774514?w=800&q=80",
      ],
      caseTitle: "Car Accident Emergency",
      caseId: "UA10234",
      description:
          "Met with a severe accident last night on NH-44. Both legs fractured and internal bleeding. Need urgent financial help for emergency surgeries and ICU stay. Family has exhausted all savings. Please help us in this critical time.",
      raised: 25000,
      goal: 50000,
      status: VerificationStatus.verified,
    ),

    // ── 2. Child Cancer Treatment ─────────────────────────────────────────────
    Post(
      userName: "Sunita Mehra",
      profilePic: "https://i.pravatar.cc/150?img=47",
      location: "Mumbai, Maharashtra",
      mediaUrls: [
        "https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800&q=80",
        "https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=800&q=80",
      ],
      caseTitle: "Help 6-Year-Old Aryan Beat Leukemia",
      caseId: "UA10245",
      description:
          "My son Aryan was diagnosed with Acute Lymphoblastic Leukemia three months ago. Chemotherapy sessions cost ₹40,000 each and he needs 12 cycles. We are a daily-wage family from Dharavi and cannot afford this alone. Your help can give my child a second chance at life.",
      raised: 88000,
      goal: 480000,
      status: VerificationStatus.verified,
    ),

    // ── 3. Flood Disaster Relief ──────────────────────────────────────────────
    Post(
      userName: "Pradeep Nair",
      profilePic: "https://i.pravatar.cc/150?img=60",
      location: "Wayanad, Kerala",
      mediaUrls: [
        "https://images.unsplash.com/photo-1547683905-f686c993aae5?w=800&q=80",
        "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&q=80",
        "https://images.unsplash.com/photo-1601134467661-3d775b999c0b?w=800&q=80",
      ],
      caseTitle: "Wayanad Flood Victims Need Your Help",
      caseId: "UA10258",
      description:
          "The devastating floods in Wayanad have destroyed over 200 homes in our village. Families have lost everything — shelter, food, livestock, and their livelihoods. We are working with local authorities to rebuild. Every rupee donated goes directly to affected families for food kits and temporary shelter.",
      raised: 210000,
      goal: 500000,
      status: VerificationStatus.verified,
    ),

    // ── 4. Girls Education ────────────────────────────────────────────────────
    Post(
      userName: "Kavitha Reddy",
      profilePic: "https://i.pravatar.cc/150?img=44",
      location: "Hyderabad, Telangana",
      mediaUrls: [
        "https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=800&q=80",
        "https://images.unsplash.com/photo-1588072432836-e10032774350?w=800&q=80",
      ],
      caseTitle: "Send 50 Girls to School This Year",
      caseId: "UA10263",
      description:
          "In rural Telangana, nearly 50 girls between ages 8–14 are forced to drop out due to poverty and early marriage pressures. Our NGO Akanksha Foundation is running a scholarship + mentorship program. Help us cover school fees, uniforms, books, and a safe hostel for one full academic year.",
      raised: 175000,
      goal: 300000,
      status: VerificationStatus.verified,
    ),

    // ── 5. House Fire Relief ──────────────────────────────────────────────────
    Post(
      userName: "Anita Verma",
      profilePic: "https://i.pravatar.cc/150?img=8",
      location: "Pune, Maharashtra",
      mediaUrls: [
        "https://images.unsplash.com/photo-1562159278-1253a58da141?w=800&q=80",
        "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80",
      ],
      caseTitle: "House Fire Destroyed Our Home Overnight",
      caseId: "UA10290",
      description:
          "A short circuit fire gutted our entire house at 2 AM last Tuesday. We managed to escape with just the clothes on our backs. My husband is a rickshaw driver and we have two school-going children. We have nowhere to go. Any support — even ₹100 — will help us restart our lives.",
      raised: 40000,
      goal: 80000,
      status: VerificationStatus.pending,
    ),

    // ── 6. Cancer Treatment ───────────────────────────────────────────────────
    Post(
      userName: "Suresh Patel",
      profilePic: "https://i.pravatar.cc/150?img=12",
      location: "Ahmedabad, Gujarat",
      mediaUrls: [
        "https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80",
        "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&q=80",
      ],
      caseTitle: "Stage 3 Cancer Treatment — Time Is Running Out",
      caseId: "UA10301",
      description:
          "Fighting stage 3 colon cancer while raising three kids alone. My wife passed away last year. I am a retired government employee with a small pension that barely covers food. Surgery and radiation are the only options left. The hospital requires upfront payment. Please help — my kids need their father.",
      raised: 73000,
      goal: 150000,
      status: VerificationStatus.verified,
    ),

    // ── 7. Clean Water NGO Campaign ───────────────────────────────────────────
    Post(
      userName: "GreenEarth NGO",
      profilePic: "https://i.pravatar.cc/150?img=33",
      location: "Rajasthan",
      mediaUrls: [
        "https://images.unsplash.com/photo-1594398901394-4e34939a4fd0?w=800&q=80",
        "https://images.unsplash.com/photo-1541544537156-7627a7a4aa1c?w=800&q=80",
        "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800&q=80",
      ],
      caseTitle: "Clean Water for 3 Desert Villages",
      caseId: "UA10315",
      description:
          "Three villages in the Barmer district of Rajasthan have zero access to clean drinking water. Women walk 8 km daily to fetch water from contaminated ponds. We are installing solar-powered borewells and water purification units. Help us bring safe water to 1,200 families by summer 2026.",
      raised: 320000,
      goal: 750000,
      status: VerificationStatus.verified,
    ),

    // ── 8. Spinal Injury ──────────────────────────────────────────────────────
    Post(
      userName: "Ritu Agarwal",
      profilePic: "https://i.pravatar.cc/150?img=25",
      location: "Lucknow, Uttar Pradesh",
      mediaUrls: [
        "https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=800&q=80",
        "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=800&q=80",
      ],
      caseTitle: "Spinal Surgery for 24-Year-Old Ravi",
      caseId: "UA10329",
      description:
          "My younger brother Ravi met with a construction site accident eight months ago and has been paralysed from the waist down ever since. Doctors say a spinal decompression surgery has a 70% chance of restoring mobility. He was the sole earner for our family of five. Please help him walk again.",
      raised: 95000,
      goal: 220000,
      status: VerificationStatus.verified,
    ),

    // ── 9. Orphanage Meals Drive ──────────────────────────────────────────────
    Post(
      userName: "Aasha Children's Trust",
      profilePic: "https://i.pravatar.cc/150?img=56",
      location: "Chennai, Tamil Nadu",
      mediaUrls: [
        "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800&q=80",
        "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&q=80",
      ],
      caseTitle: "Feed 80 Orphaned Children for 6 Months",
      caseId: "UA10337",
      description:
          "Aasha Orphanage is home to 80 children between ages 3–16 who have lost their parents. Our food fund runs dry at the end of this month. ₹4,500 feeds one child for a month — nutritious meals, three times a day. Help us bridge this crisis and ensure no child sleeps hungry.",
      raised: 156000,
      goal: 216000,
      status: VerificationStatus.verified,
    ),

    // ── 10. Suspicious fundraiser (falseCase) ─────────────────────────────────
    Post(
      userName: "Mohan Das",
      profilePic: "https://i.pravatar.cc/150?img=18",
      location: "Kolkata, West Bengal",
      mediaUrls: [
        "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&q=80",
      ],
      caseTitle: "Help Rebuild My Restaurant After Robbery",
      caseId: "UA10341",
      description:
          "Armed robbers broke into my restaurant last week and stole all cash, equipment and damaged the interiors. Police FIR has been filed. I need help to restart my business and feed my family of four. Attached police complaint and damage photos.",
      raised: 8000,
      goal: 60000,
      status: VerificationStatus.falseCase,
    ),
  ];

  List<Post> get _filteredPosts {
    switch (_selectedFilter) {
      case 1: // Most Upvoted — sort by raised (proxy for upvotes in demo)
        final sorted = List<Post>.from(_allPosts);
        sorted.sort((a, b) => b.raised.compareTo(a.raised));
        return sorted;
      case 2: // Verified only
        return _allPosts
            .where((p) => p.status == VerificationStatus.verified)
            .toList();
      case 3: // Nearby — just show all in demo
        return _allPosts;
      case 4: // Critical — highest goal gap
        final sorted = List<Post>.from(_allPosts);
        sorted.sort((a, b) => (b.goal - b.raised).compareTo(a.goal - a.raised));
        return sorted;
      default: // Recent
        return _allPosts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "UnityAid",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: _buildFilterBar(),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: _filteredPosts.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _filteredPosts.length,
                itemBuilder: (_, index) => PostCard(
                  post: _filteredPosts[index],
                  onDonateTap: widget.onDonateTap,
                  isNGO: widget.isNGO,
                ),
              ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _filters.length,
        itemBuilder: (_, i) {
          final selected = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _filters[i]['icon'] as IconData,
                    size: 15,
                    color: selected ? Colors.white : AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _filters[i]['label'] as String,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Builder(builder: (context) {
      final theme = Theme.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: theme.dividerColor),
            const SizedBox(height: 12),
            Text(
              "No posts found",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Try a different filter",
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
            ),
          ],
        ),
      );
    });
  }
}
