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
    bool isSelected,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.grey.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => navigate(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = role == AppRole.user;
    final currentRoute =
        ModalRoute.of(context)?.settings.name ?? (isUser ? '/userHome' : '/ngoHome');

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Profile
            CircleAvatar(
              radius: 40,
              foregroundImage: const NetworkImage(
                "https://www.iconpacks.net/icons/2/free-user-icon-3297-thumb.png",
              ),
              onForegroundImageError: (_, __) {},
              child: const Icon(Icons.person, size: 36),
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
              currentRoute == (isUser ? '/userHome' : '/ngoHome'),
            ),

            drawerItem(
              context,
              Icons.newspaper,
              "News",
              '/news',
              currentRoute == '/news',
            ),

            /// USER ONLY
            if (isUser) ...[
              drawerItem(
                context,
                Icons.add_box,
                "Post",
                '/post',
                currentRoute == '/post',
              ),
              drawerItem(
                context,
                Icons.volunteer_activism,
                "NGOs",
                '/ngos',
                currentRoute == '/ngos',
              ),
              drawerItem(
                context,
                Icons.favorite,
                "Donate",
                '/donate',
                currentRoute == '/donate',
              ),
            ],

            /// NGO ONLY
            if (!isUser)
              drawerItem(
                context,
                Icons.dashboard,
                "Dashboard",
                '/dashboard',
                currentRoute == '/dashboard',
              ),

            /// Shared
            drawerItem(
              context,
              Icons.info,
              "About Us",
              '/about',
              currentRoute == '/about',
            ),

            drawerItem(
              context,
              Icons.settings,
              "Settings",
              '/settings',
              currentRoute == '/settings',
            ),
          ],
        ),
      ),
    );
  }
}
