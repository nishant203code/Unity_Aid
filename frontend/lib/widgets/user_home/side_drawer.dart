import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppRole { user, ngo }

class SideDrawer extends StatelessWidget {
  final AppRole role;
  final Function(int)? onTabSwitch;

  const SideDrawer({
    super.key,
    required this.role,
    this.onTabSwitch,
  });

  /// 🔥 Centralized Navigation Function
  void navigate(BuildContext context, String route) {
    Navigator.pop(context);

    Navigator.popUntil(context, (route) => route.isFirst);

    Navigator.pushNamed(context, route);
  }

  /// Switch to tab instead of navigating
  void switchTab(BuildContext context, int tabIndex) {
    Navigator.pop(context); // Close drawer
    if (onTabSwitch != null) {
      onTabSwitch!(tabIndex);
    }
  }

  Widget drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route, {
    int? tabIndex,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: tabIndex != null
          ? () => switchTab(context, tabIndex)
          : () => navigate(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = role == AppRole.user;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Profile
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                "https://www.iconpacks.net/icons/2/free-user-icon-3297-thumb.png",
              ),
            ),

            const SizedBox(height: 10),

            Text(
              isUser ? "Welcome Back!" : "Welcome, NGO!",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const Divider(height: 40),

            /// Shared
            drawerItem(
              context,
              Icons.home,
              "Home",
              '',
              tabIndex: 0,
            ),

            drawerItem(
              context,
              Icons.newspaper,
              "News",
              '',
              tabIndex: 1,
            ),

            /// USER ONLY
            if (isUser) ...[
              drawerItem(context, Icons.add_box, "Post", '', tabIndex: 2),
              drawerItem(context, Icons.volunteer_activism, "NGOs", '',
                  tabIndex: 3),
              drawerItem(context, Icons.favorite, "Donate", '', tabIndex: 4),
            ],

            /// NGO ONLY
            if (!isUser)
              drawerItem(
                context,
                Icons.dashboard,
                "Dashboard",
                '',
                tabIndex: 2,
              ),

            /// Shared
            drawerItem(
              context,
              Icons.info,
              "About Us",
              '/about',
            ),

            drawerItem(
              context,
              Icons.settings,
              "Settings",
              '/settings',
            ),
          ],
        ),
      ),
    );
  }
}
