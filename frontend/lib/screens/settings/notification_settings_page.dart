import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/theme/app_colors.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _donationUpdates = true;
  bool _ngoUpdates = true;
  bool _eventReminders = true;
  bool _casesUpdates = true;
  bool _promotionalMessages = false;
  bool _newsletterSubscription = true;
  bool _communityUpdates = true;
  String _reminderTiming = '1 day before';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = p.getBool('notif_push') ?? true;
      _emailNotifications = p.getBool('notif_email') ?? true;
      _smsNotifications = p.getBool('notif_sms') ?? false;
      _donationUpdates = p.getBool('notif_donation') ?? true;
      _ngoUpdates = p.getBool('notif_ngo') ?? true;
      _eventReminders = p.getBool('notif_events') ?? true;
      _casesUpdates = p.getBool('notif_cases') ?? true;
      _promotionalMessages = p.getBool('notif_promo') ?? false;
      _newsletterSubscription = p.getBool('notif_newsletter') ?? true;
      _communityUpdates = p.getBool('notif_community') ?? true;
      _reminderTiming = p.getString('notif_reminderTiming') ?? '1 day before';
    });
  }

  Future<void> _save(String key, bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(key, value);
  }

  Future<void> _saveStr(String key, String value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(key, value);
  }

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
                onChanged: (v) {
                  setState(() => _pushNotifications = v);
                  _save('notif_push', v);
                },
              ),
              _buildSwitchTile(
                icon: Icons.email,
                title: "Email Notifications",
                subtitle: "Receive notifications via email",
                value: _emailNotifications,
                onChanged: (v) {
                  setState(() => _emailNotifications = v);
                  _save('notif_email', v);
                },
              ),
              _buildSwitchTile(
                icon: Icons.sms,
                title: "SMS Notifications",
                subtitle: "Receive important alerts via SMS",
                value: _smsNotifications,
                onChanged: (v) {
                  setState(() => _smsNotifications = v);
                  _save('notif_sms', v);
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
                onChanged: (v) {
                  setState(() => _donationUpdates = v);
                  _save('notif_donation', v);
                },
              ),
              _buildSwitchTile(
                icon: Icons.business,
                title: "NGO Updates",
                subtitle: "News from NGOs you follow",
                value: _ngoUpdates,
                onChanged: (v) {
                  setState(() => _ngoUpdates = v);
                  _save('notif_ngo', v);
                },
              ),
              _buildSwitchTile(
                icon: Icons.cases,
                title: "Case Updates",
                subtitle: "Updates on donation cases",
                value: _casesUpdates,
                onChanged: (v) {
                  setState(() => _casesUpdates = v);
                  _save('notif_cases', v);
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
                onChanged: (v) {
                  setState(() => _eventReminders = v);
                  _save('notif_events', v);
                },
              ),
              _buildListTile(
                icon: Icons.schedule,
                title: "Reminder Timing",
                subtitle: _reminderTiming,
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
                onChanged: (v) {
                  setState(() => _communityUpdates = v);
                  _save('notif_community', v);
                },
              ),
              _buildSwitchTile(
                icon: Icons.campaign,
                title: "Promotional Messages",
                subtitle: "Special offers and campaigns",
                value: _promotionalMessages,
                onChanged: (v) {
                  setState(() => _promotionalMessages = v);
                  _save('notif_promo', v);
                },
              ),
              _buildSwitchTile(
                icon: Icons.article,
                title: "Newsletter",
                subtitle: "Weekly/monthly newsletter",
                value: _newsletterSubscription,
                onChanged: (v) {
                  setState(() => _newsletterSubscription = v);
                  _save('notif_newsletter', v);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ADVANCED
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color,
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
    final options = ['1 hour before', '1 day before', '1 week before'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Reminder Timing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((opt) => RadioListTile<String>(
            title: Text(opt),
            value: opt,
            groupValue: _reminderTiming,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _reminderTiming = value!);
              _saveStr('notif_reminderTiming', value!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reminder set to $value')),
              );
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showDoNotDisturbDialog(BuildContext context) {
    TimeOfDay startTime = const TimeOfDay(hour: 22, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 7, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Do Not Disturb'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silence notifications during these hours:'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Start', style: TextStyle(fontSize: 12)),
                      TextButton(
                        child: Text(startTime.format(context),
                            style: const TextStyle(fontSize: 18)),
                        onPressed: () async {
                          final t = await showTimePicker(
                              context: context, initialTime: startTime);
                          if (t != null) setModalState(() => startTime = t);
                        },
                      ),
                    ],
                  ),
                  const Text('to', style: TextStyle(fontSize: 16)),
                  Column(
                    children: [
                      const Text('End', style: TextStyle(fontSize: 12)),
                      TextButton(
                        child: Text(endTime.format(context),
                            style: const TextStyle(fontSize: 18)),
                        onPressed: () async {
                          final t = await showTimePicker(
                              context: context, initialTime: endTime);
                          if (t != null) setModalState(() => endTime = t);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'DND set: ${startTime.format(context)} â€“ ${endTime.format(context)}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
