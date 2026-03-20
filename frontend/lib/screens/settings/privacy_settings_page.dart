import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _shareDataWithNGOs = true;
  bool _shareDataForAnalytics = false;
  bool _publicProfile = true;
  bool _showDonationHistory = false;
  bool _locationAccess = true;
  bool _cameraAccess = true;
  bool _microphoneAccess = false;
  bool _activityTracking = true;
  String _profileVisibility = 'Public';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy & Permissions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          /// DATA SHARING PREFERENCES
          _buildSection(
            title: "Data Sharing Preferences",
            children: [
              _buildSwitchTile(
                icon: Icons.share,
                title: "Share Data with NGOs",
                subtitle: "Allow NGOs to see your donation history",
                value: _shareDataWithNGOs,
                onChanged: (value) {
                  setState(() => _shareDataWithNGOs = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.analytics,
                title: "Share Data for Analytics",
                subtitle: "Help us improve the app",
                value: _shareDataForAnalytics,
                onChanged: (value) {
                  setState(() => _shareDataForAnalytics = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// VISIBILITY CONTROLS
          _buildSection(
            title: "Visibility Controls",
            children: [
              _buildSwitchTile(
                icon: Icons.public,
                title: "Public Profile",
                subtitle: "Make your profile visible to others",
                value: _publicProfile,
                onChanged: (value) {
                  setState(() => _publicProfile = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.history,
                title: "Show Donation History",
                subtitle: "Display your donations publicly",
                value: _showDonationHistory,
                onChanged: (value) {
                  setState(() => _showDonationHistory = value);
                },
              ),
              _buildListTile(
                icon: Icons.visibility,
                title: "Profile Visibility",
                subtitle: _profileVisibility,
                onTap: () => _showVisibilityDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// APP PERMISSIONS
          _buildSection(
            title: "App Permissions",
            children: [
              _buildSwitchTile(
                icon: Icons.location_on,
                title: "Location Access",
                subtitle: "Find nearby NGOs and events",
                value: _locationAccess,
                onChanged: (value) {
                  setState(() => _locationAccess = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.camera_alt,
                title: "Camera Access",
                subtitle: "Upload photos and documents",
                value: _cameraAccess,
                onChanged: (value) {
                  setState(() => _cameraAccess = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.mic,
                title: "Microphone Access",
                subtitle: "Record audio for posts",
                value: _microphoneAccess,
                onChanged: (value) {
                  setState(() => _microphoneAccess = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ACTIVITY TRACKING
          _buildSection(
            title: "Activity Tracking",
            children: [
              _buildSwitchTile(
                icon: Icons.track_changes,
                title: "Activity Tracking",
                subtitle: "Track app usage for personalized experience",
                value: _activityTracking,
                onChanged: (value) {
                  setState(() => _activityTracking = value);
                },
              ),
              _buildListTile(
                icon: Icons.info_outline,
                title: "Privacy Policy",
                subtitle: "Read our privacy policy",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening privacy policy...')),
                  );
                },
              ),
              _buildListTile(
                icon: Icons.description,
                title: "Data Download",
                subtitle: "Download your data",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preparing data download...')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Icon(Icons.chevron_right, 
        color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
      onTap: onTap,
    );
  }

  void _showVisibilityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Visibility'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Public'),
              subtitle: const Text('Everyone can see your profile'),
              value: 'Public',
              groupValue: _profileVisibility,
              onChanged: (value) {
                setState(() => _profileVisibility = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Friends Only'),
              subtitle: const Text('Only your connections'),
              value: 'Friends Only',
              groupValue: _profileVisibility,
              onChanged: (value) {
                setState(() => _profileVisibility = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Private'),
              subtitle: const Text('Only you can see your profile'),
              value: 'Private',
              groupValue: _profileVisibility,
              onChanged: (value) {
                setState(() => _profileVisibility = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
