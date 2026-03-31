import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import 'media_carousel.dart';
import '../../../widgets/theme/app_colors.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(String caseId)? onDonateTap;
  final bool isNGO;
  const PostCard({
    super.key,
    required this.post,
    this.onDonateTap,
    this.isNGO = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool expanded = false;
  bool _upvoted = false;
  int _upvoteCount = 128;

  // ── Report reasons ─────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _reportCategories = [
    {
      'icon': Icons.cancel_outlined,
      'label': 'False / Fake Case',
      'color': Colors.red,
    },
    {
      'icon': Icons.money_off_outlined,
      'label': 'Fraudulent Fundraiser',
      'color': Colors.deepOrange,
    },
    {
      'icon': Icons.image_not_supported_outlined,
      'label': 'Inappropriate Content',
      'color': Colors.orange,
    },
    {
      'icon': Icons.person_off_outlined,
      'label': 'Impersonation',
      'color': Colors.purple,
    },
    {
      'icon': Icons.warning_amber_outlined,
      'label': 'Misleading Information',
      'color': Colors.amber,
    },
    {
      'icon': Icons.thumb_down_outlined,
      'label': 'Spam or Repetitive Post',
      'color': Colors.blueGrey,
    },
    {
      'icon': Icons.more_horiz,
      'label': 'Other',
      'color': Colors.grey,
    },
  ];

  // ── Verification badge ──────────────────────────────────────────────────────
  Widget buildVerificationBadge(VerificationStatus status) {
    Color color;
    IconData icon;
    String label;
    switch (status) {
      case VerificationStatus.verified:
        color = Colors.green;
        icon = Icons.verified;
        label = "Verified";
        break;
      case VerificationStatus.falseCase:
        color = Colors.red;
        icon = Icons.cancel;
        label = "False";
        break;
      case VerificationStatus.pending:
        color = Colors.orange;
        icon = Icons.hourglass_top;
        label = "Pending";
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Report bottom sheet ─────────────────────────────────────────────────────
  void _showReportSheet(BuildContext context) {
    String? selectedReason;
    final detailsController = TextEditingController();
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flag_outlined,
                            color: Colors.red, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Report Post',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Help us understand the problem',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Divider(),

                // Reasons list
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    children: [
                      ..._reportCategories.map((cat) {
                        final isSelected = selectedReason == cat['label'];
                        return GestureDetector(
                          onTap: () =>
                              setSheetState(() => selectedReason = cat['label']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (cat['color'] as Color).withOpacity(0.1)
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? cat['color'] as Color
                                    : theme.dividerColor,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(cat['icon'] as IconData,
                                    color: cat['color'] as Color, size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    cat['label'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? cat['color'] as Color
                                          : null,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle,
                                      color: cat['color'] as Color, size: 18),
                              ],
                            ),
                          ),
                        );
                      }),

                      // Optional details field
                      const SizedBox(height: 8),
                      Text('Additional details (optional)',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: detailsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Describe the issue in more detail…',
                          filled: true,
                          fillColor: theme.brightness == Brightness.dark
                              ? Colors.white10
                              : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Submit button
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    top: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: selectedReason == null
                          ? null
                          : () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Report submitted: $selectedReason'),
                                  backgroundColor: Colors.red.shade700,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.red.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Submit Report',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Comment sheet ───────────────────────────────────────────────────────────
  void _showCommentSheet(BuildContext context) {
    final theme = Theme.of(context);
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Text("Comments",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _commentItem(context, "Priya S.",
                        "Praying for your recovery 🙏",
                        "https://i.pravatar.cc/150?img=1"),
                    _commentItem(context, "Amit K.", "Shared this with friends!",
                        "https://i.pravatar.cc/150?img=2"),
                    _commentItem(context, "Sunita R.", "Stay strong ❤️",
                        "https://i.pravatar.cc/150?img=3"),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                  top: 8,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage:
                          NetworkImage("https://i.pravatar.cc/150?img=10"),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Write a comment…",
                          filled: true,
                          fillColor: theme.brightness == Brightness.dark
                              ? Colors.white10
                              : Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.send,
                            color: Colors.white, size: 18),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentItem(
      BuildContext context, String name, String text, String avatar) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(text,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BUILD ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subtleColor = isDark ? Colors.white38 : Colors.grey.shade600;
    final iconColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: theme.cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP USER ROW
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundImage: NetworkImage(post.profilePic)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(post.userName,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            buildVerificationBadge(post.status),
                          ]),
                          Text(post.location,
                              style:
                                  TextStyle(color: subtleColor, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.more_horiz, color: subtleColor),
                  ],
                ),
              ),

              /// TITLE + DESCRIPTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.caseTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Case ID: ${post.caseId}",
                        style: TextStyle(color: subtleColor)),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => setState(() => expanded = !expanded),
                      child: Text(
                        post.description,
                        style: theme.textTheme.bodyMedium,
                        maxLines: expanded ? null : 2,
                        overflow: expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              /// MEDIA
              MediaCarousel(mediaUrls: post.mediaUrls),

              /// COUNTS ROW
              if (!widget.isNGO)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      const Text('❤️', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text("$_upvoteCount upvotes",
                          style: TextStyle(color: subtleColor, fontSize: 12)),
                      const Spacer(),
                      Text("24 comments",
                          style: TextStyle(color: subtleColor, fontSize: 12)),
                    ],
                  ),
                ),

              Divider(
                  height: 1, thickness: 0.6, color: theme.dividerColor),

              /// ACTION BUTTONS
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.isNGO
                      ? [
                          _iconTextButton(
                              icon: Icons.verified,
                              label: "Verify",
                              color: Colors.green,
                              onTap: () {}),
                          _iconTextButton(
                              icon: Icons.assignment_turned_in,
                              label: "Take Case",
                              color: AppColors.primary,
                              onTap: () {}),
                          _iconTextButton(
                              icon: Icons.share_outlined,
                              label: "Share",
                              color: iconColor,
                              onTap: () {}),
                        ]
                      : [
                          // UPVOTE
                          _iconTextButton(
                            icon: _upvoted
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            label: "Upvote",
                            color: _upvoted ? AppColors.primary : iconColor,
                            onTap: () => setState(() {
                              _upvoted = !_upvoted;
                              _upvoteCount += _upvoted ? 1 : -1;
                            }),
                          ),
                          // COMMENT
                          _iconTextButton(
                              icon: Icons.chat_bubble_outline,
                              label: "Comment",
                              color: iconColor,
                              onTap: () => _showCommentSheet(context)),
                          // REPORT  ← replaced React
                          _iconTextButton(
                              icon: Icons.flag_outlined,
                              label: "Report",
                              color: Colors.red.shade400,
                              onTap: () => _showReportSheet(context)),
                          // SHARE
                          _iconTextButton(
                              icon: Icons.share_outlined,
                              label: "Share",
                              color: iconColor,
                              onTap: () {}),
                        ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          thickness: 8,
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _iconTextButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
