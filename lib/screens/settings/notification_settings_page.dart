import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  
  // Specific notification types
  bool _donationUpdates = true;
  bool _ngoUpdates = true;
  bool _eventReminders = true;
  bool _casesUpdates = true;
  bool _promotionalMessages = false;
  bool _newsletterSubscription = true;
  bool _communityUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          /// NOTIFICATION CHANNELS
          _buildSection(
            title: "Notification Channels",
            children: [
              _buildSwitchTile(
                icon: Icons.notifications_active,
                title: "Push Notifications",
                subtitle: "Receive notifications on this device",
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() => _pushNotifications = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.email,
                title: "Email Notifications",
                subtitle: "Receive notifications via email",
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() => _emailNotifications = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.sms,
                title: "SMS Notifications",
                subtitle: "Receive important alerts via SMS",
                value: _smsNotifications,
                onChanged: (value) {
                  setState(() => _smsNotifications = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// DONATION & NGO UPDATES
          _buildSection(
            title: "Donation & NGO Updates",
            children: [
              _buildSwitchTile(
                icon: Icons.volunteer_activism,
                title: "Donation Updates",
                subtitle: "Updates about your donations",
                value: _donationUpdates,
                onChanged: (value) {
                  setState(() => _donationUpdates = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.business,
                title: "NGO Updates",
                subtitle: "News from NGOs you follow",
                value: _ngoUpdates,
                onChanged: (value) {
                  setState(() => _ngoUpdates = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.cases,
                title: "Case Updates",
                subtitle: "Updates on donation cases",
                value: _casesUpdates,
                onChanged: (value) {
                  setState(() => _casesUpdates = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// EVENT REMINDERS
          _buildSection(
            title: "Event Reminders",
            children: [
              _buildSwitchTile(
                icon: Icons.event,
                title: "Event Reminders",
                subtitle: "Get reminded about upcoming events",
                value: _eventReminders,
                onChanged: (value) {
                  setState(() => _eventReminders = value);
                },
              ),
              _buildListTile(
                icon: Icons.schedule,
                title: "Reminder Timing",
                subtitle: "1 day before event",
                onTap: () => _showReminderTimingDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// COMMUNITY & PROMOTIONAL
          _buildSection(
            title: "Community & Promotional",
            children: [
              _buildSwitchTile(
                icon: Icons.group,
                title: "Community Updates",
                subtitle: "News from the UnityAid community",
                value: _communityUpdates,
                onChanged: (value) {
                  setState(() => _communityUpdates = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.campaign,
                title: "Promotional Messages",
                subtitle: "Special offers and campaigns",
                value: _promotionalMessages,
                onChanged: (value) {
                  setState(() => _promotionalMessages = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.article,
                title: "Newsletter",
                subtitle: "Weekly/monthly newsletter",
                value: _newsletterSubscription,
                onChanged: (value) {
                  setState(() => _newsletterSubscription = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// NOTIFICATION SETTINGS
          _buildSection(
            title: "Advanced",
            children: [
              _buildListTile(
                icon: Icons.do_not_disturb,
                title: "Do Not Disturb",
                subtitle: "Set quiet hours",
                onTap: () => _showDoNotDisturbDialog(context),
              ),
              _buildListTile(
                icon: Icons.clear_all,
                title: "Clear All Notifications",
                subtitle: "Remove all pending notifications",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications cleared'),
                      backgroundColor: Colors.green,
                    ),
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

  void _showReminderTimingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Reminder Timing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('1 hour before'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder set to 1 hour before')),
                );
              },
            ),
            ListTile(
              title: const Text('1 day before'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder set to 1 day before')),
                );
              },
            ),
            ListTile(
              title: const Text('1 week before'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder set to 1 week before')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDoNotDisturbDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Do Not Disturb'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Set quiet hours when you don\'t want to receive notifications.'),
            SizedBox(height: 16),
            Text('Coming soon: Custom time range selection'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
