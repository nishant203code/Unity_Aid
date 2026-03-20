import 'package:flutter/material.dart';
import '../../models/ngo_model.dart';
import '../theme/app_colors.dart';
import '../../screens/ngo_search/ngo_detail_page.dart';

class NGOCard extends StatelessWidget {
  final NGO ngo;

  const NGOCard({super.key, required this.ngo});

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
                    backgroundImage: NetworkImage(ngo.logoUrl),
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
                        Text(
                          ngo.location,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
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
