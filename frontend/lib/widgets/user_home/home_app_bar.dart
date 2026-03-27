import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.onMenuTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuTap,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 20,
              foregroundImage: const NetworkImage(
                "https://www.iconpacks.net/icons/2/free-user-icon-3297-thumb.png",
              ),
              onForegroundImageError: (_, __) {},
              child: const Icon(Icons.person, size: 20),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
