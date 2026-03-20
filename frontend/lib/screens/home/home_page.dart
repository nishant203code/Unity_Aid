import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import 'widgets/home_stat_card.dart';
import 'widgets/animated_circular_stat.dart';

class HomePage extends StatelessWidget {
  final bool isNGO; // ⭐ NEW

  const HomePage({
    super.key,
    this.isNGO = false, // default = user
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            /// 🔥 HERO SECTION
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    Colors.white.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 25,
                    color: Colors.black.withOpacity(0.05),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.12),
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: AppColors.primary,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "UnityAid",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Together we rise, together we rebuild.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Impact",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// Stats
            const Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                AnimatedCircularStat(
                  title: "Cases Today",
                  value: 76,
                  color: Colors.orange,
                ),
                AnimatedCircularStat(
                  title: "Verified",
                  value: 54,
                  color: Colors.green,
                ),
                AnimatedCircularStat(
                  title: "Resolved",
                  value: 31,
                  color: Colors.blue,
                ),
                AnimatedCircularStat(
                  title: "Fake Cases",
                  value: 7,
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const HomeStatCard(
              title: "Total Donations",
              value: "₹12.4L",
              subtitle: "Across all campaigns",
              icon: Icons.favorite,
            ),

            const SizedBox(height: 14),

            const HomeStatCard(
              title: "Cases Supported",
              value: "2,184",
              subtitle: "People helped through UnityAid",
              icon: Icons.groups,
            ),

            const SizedBox(height: 40),

            /// ⭐ ROLE-AWARE BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                ),
                onPressed: () {},

                /// 🔥 DYNAMIC ICON
                icon: Icon(
                  isNGO ? Icons.warning_amber_rounded : Icons.map,
                ),

                /// 🔥 DYNAMIC TEXT
                label: Text(
                  isNGO ? "Locate Nearby Emergencies" : "Locate Nearby NGO",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
