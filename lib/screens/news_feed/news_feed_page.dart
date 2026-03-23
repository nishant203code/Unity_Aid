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
    Post(
      userName: "Rahul Sharma",
      profilePic: "https://i.pravatar.cc/150?img=5",
      location: "Delhi",
      mediaUrls: [
        "https://images.unsplash.com/photo-1627398242454-45a1465c2479",
        "https://images.unsplash.com/photo-1593113598332-cd288d649433"
      ],
      caseTitle: "Car Accident Emergency",
      caseId: "UA10234",
      description:
          "Met with a severe accident last night. Need urgent financial help for surgeries. Met with a severe accident last night. Need urgent financial help for surgeries.",
      raised: 25000,
      goal: 50000,
      status: VerificationStatus.verified,
    ),
    Post(
      userName: "Anita Verma",
      profilePic: "https://i.pravatar.cc/150?img=8",
      location: "Mumbai",
      mediaUrls: [
        "https://images.unsplash.com/photo-1593113598332-cd288d649433"
      ],
      caseTitle: "House Fire Relief",
      caseId: "UA10290",
      description:
          "Lost our home in a fire accident. Any support would mean the world to us. Lost our home in a fire accident. Any support would mean the world to us.",
      raised: 40000,
      goal: 80000,
      status: VerificationStatus.falseCase,
    ),
    Post(
      userName: "Suresh Patel",
      profilePic: "https://i.pravatar.cc/150?img=12",
      location: "Ahmedabad",
      mediaUrls: [
        "https://images.unsplash.com/photo-1579684385127-1ef15d508118"
      ],
      caseTitle: "Cancer Treatment Support",
      caseId: "UA10301",
      description:
          "Fighting stage 3 cancer and need help covering treatment costs. Every contribution matters. Fighting stage 3 cancer and need help covering treatment costs.",
      raised: 73000,
      goal: 150000,
      status: VerificationStatus.verified,
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
        sorted.sort(
            (a, b) => (b.goal - b.raised).compareTo(a.goal - a.raised));
        return sorted;
      default: // Recent
        return _allPosts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            Icon(Icons.search_off_rounded,
                size: 64, color: theme.dividerColor),
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
