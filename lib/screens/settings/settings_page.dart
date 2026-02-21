import 'package:flutter/material.dart';
import 'account_settings_page.dart';
import 'privacy_settings_page.dart';
import 'notification_settings_page.dart';
import 'display_settings_page.dart';
import 'security_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          /// ACCOUNT SETTINGS
          _buildSettingCard(
            context: context,
            icon: Icons.account_circle,
            title: "Account Settings",
            subtitle: "Profile, password, linked accounts",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          /// PRIVACY & PERMISSIONS
          _buildSettingCard(
            context: context,
            icon: Icons.privacy_tip,
            title: "Privacy & Permissions",
            subtitle: "Data sharing, visibility, permissions",
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySettingsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          /// NOTIFICATIONS
          _buildSettingCard(
            context: context,
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "Push, email, SMS, event reminders",
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          /// DISPLAY & ACCESSIBILITY
          _buildSettingCard(
            context: context,
            icon: Icons.palette,
            title: "Display & Accessibility",
            subtitle: "Theme, font size, language",
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DisplaySettingsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          /// SECURITY SETTINGS
          _buildSettingCard(
            context: context,
            icon: Icons.security,
            title: "Security Settings",
            subtitle: "Login alerts, app lock, sessions",
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecuritySettingsPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          /// APP INFO
          const Center(
            child: Column(
              children: [
                Text(
                  "UnityAid",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
