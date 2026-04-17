import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../widgets/theme/app_colors.dart';
import '../../services/post_service.dart';
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

  List<Post> _applyFilter(List<Post> posts) {
    switch (_selectedFilter) {
      case 1: // Most Upvoted — sort by raised (proxy for upvotes)
        final sorted = List<Post>.from(posts);
        sorted.sort((a, b) => b.raised.compareTo(a.raised));
        return sorted;
      case 2: // Verified only
        return posts
            .where((p) => p.status == VerificationStatus.verified)
            .toList();
      case 3: // Nearby — just show all for now
        return posts;
      case 4: // Critical — highest goal gap
        final sorted = List<Post>.from(posts);
        sorted.sort(
            (a, b) => (b.goal - b.raised).compareTo(a.goal - a.raised));
        return sorted;
      default: // Recent (already sorted by createdAt desc from Firestore)
        return posts;
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
      body: StreamBuilder<List<Post>>(
        stream: PostService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load posts',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allPosts = snapshot.data ?? [];
          final filteredPosts = _applyFilter(allPosts);

          if (filteredPosts.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredPosts.length,
              itemBuilder: (_, index) => PostCard(
                post: filteredPosts[index],
                onDonateTap: widget.onDonateTap,
                isNGO: widget.isNGO,
              ),
            ),
          );
        },
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
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.2),
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
