import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import 'media_carousel.dart';
import 'donation_progress.dart';
import '../../../widgets/theme/app_colors.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(String caseId)? onDonateTap;
  final bool isNGO;
  const PostCard({
    super.key,
    required this.post,
    this.onDonateTap,
    this.isNGO = false, // ⭐ NEW
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool expanded = false;
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
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP USER ROW
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.profilePic),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              buildVerificationBadge(post.status),
                            ],
                          ),
                          Text(
                            post.location,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    DonationProgress(
                      raised: post.raised,
                      goal: post.goal,
                    ),
                  ],
                ),
              ),

              /// MEDIA
              MediaCarousel(mediaUrls: post.mediaUrls),

              /// ACTION BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.isNGO
                      ? [
                          _actionButton(
                            icon: Icons.verified,
                            label: "Verify",
                            color: Colors.green,
                            onTap: () {},
                          ),
                          _actionButton(
                            icon: Icons.assignment_turned_in,
                            label: "Take Case",
                            color: AppColors.primary,
                            onTap: () {},
                          ),
                          _actionButton(
                            icon: Icons.share,
                            label: "Share",
                            color: Colors.grey,
                            onTap: () {},
                          ),
                        ]
                      : [
                          _actionButton(
                            icon: Icons.favorite_border,
                            label: "Upvote",
                            color: Colors.redAccent,
                            onTap: () {},
                          ),
                          _actionButton(
                            icon: Icons.volunteer_activism,
                            label: "Donate",
                            color: AppColors.primary,
                            onTap: () => widget.onDonateTap?.call(post.caseId),
                          ),
                          _actionButton(
                            icon: Icons.share,
                            label: "Share",
                            color: Colors.grey,
                            onTap: () {},
                          ),
                        ],
                ),
              ),

              /// TITLE + DESCRIPTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.caseTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Case ID: ${post.caseId}",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                      child: Text(
                        post.description,
                        maxLines: expanded ? null : 2,
                        overflow: expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 0.6,
          thickness: 0.6,
          color: Colors.grey.withOpacity(0.3),
        ),
      ],
    );
  }
}
