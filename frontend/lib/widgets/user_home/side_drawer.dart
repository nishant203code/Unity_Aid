import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppRole { user, ngo }

class SideDrawer extends StatelessWidget {
  final AppRole role;

  const SideDrawer({
    super.key,
    required this.role,
  });

  /// 🔥 Centralized Navigation Function
  void navigate(BuildContext context, String route) {
    Navigator.pop(context);

    Navigator.popUntil(context, (route) => route.isFirst);

    Navigator.pushNamed(context, route);
  }

  Widget drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: () => navigate(context, route),
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
              isUser ? '/userHome' : '/ngoHome',
            ),

            drawerItem(
              context,
              Icons.newspaper,
              "News",
              '/news',
            ),

            /// USER ONLY
            if (isUser) ...[
              drawerItem(context, Icons.add_box, "Post", '/post'),
              drawerItem(context, Icons.volunteer_activism, "NGOs", '/ngos'),
              drawerItem(context, Icons.favorite, "Donate", '/donate'),
            ],

            /// NGO ONLY
            if (!isUser)
              drawerItem(
                context,
                Icons.dashboard,
                "Dashboard",
                '/dashboard',
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
