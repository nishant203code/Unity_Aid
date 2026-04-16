import 'package:flutter/material.dart';
import '../../models/ngo_model.dart';
import '../theme/app_colors.dart';
import '../../screens/ngo_search/ngo_detail_page.dart';

class NGOCard extends StatelessWidget {
  final NGO ngo;
  final String? distanceText;

  const NGOCard({
    super.key,
    required this.ngo,
    this.distanceText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NGODetailPage(ngo: ngo),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    foregroundImage: NetworkImage(ngo.logoUrl),
                    onForegroundImageError: (_, __) {},
                    child: Text(ngo.name.isNotEmpty ? ngo.name[0] : '?'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ngo.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              ngo.location,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                            if (distanceText != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  distanceText!,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                ngo.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              /// Stats
              Row(
                children: [
                  Text("${ngo.members} Members"),
                  const SizedBox(width: 12),
                  Text("${ngo.followers} Followers"),
                ],
              ),

              const SizedBox(height: 12),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("Follow"),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("Join"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text("Donate"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
