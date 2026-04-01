import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../screens/login_page.dart';

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

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await AuthService.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleSwitchAccount(BuildContext context) async {
    await AuthService.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = role == AppRole.user;
    final currentRoute =
        ModalRoute.of(context)?.settings.name ?? (isUser ? '/userHome' : '/ngoHome');

    // Get Firebase Auth user info
    final firebaseUser = AuthService.currentUser;
    final displayName = firebaseUser?.displayName ?? (isUser ? "User" : "NGO");
    final email = firebaseUser?.email ?? "";
    final photoUrl = firebaseUser?.photoURL;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Profile
            CircleAvatar(
              radius: 40,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl)
                  : const NetworkImage(
                      "https://www.iconpacks.net/icons/2/free-user-icon-3297-thumb.png",
                    ),
              onBackgroundImageError: (_, __) {},
              child: photoUrl == null
                  ? null
                  : null,
            ),

            const SizedBox(height: 10),

            Text(
              displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            if (email.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
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

            const Spacer(),

            const Divider(),

            /// Switch Account
            ListTile(
              leading: Icon(Icons.switch_account, color: Colors.grey.shade700),
              title: const Text(
                "Switch Account",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () => _handleSwitchAccount(context),
            ),

            /// Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _handleLogout(context),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
