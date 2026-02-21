import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _loginAlerts = true;
  bool _suspiciousActivityAlerts = true;
  bool _appLock = false;
  bool _biometricAuth = false;
  String _appLockType = 'None';

  final List<Map<String, String>> _activeSessions = [
    {
      'device': 'Current Device',
      'location': 'Mumbai, India',
      'lastActive': 'Active now',
      'isCurrent': 'true',
    },
    {
      'device': 'Chrome on Windows',
      'location': 'Delhi, India',
      'lastActive': '2 days ago',
      'isCurrent': 'false',
    },
    {
      'device': 'Mobile App (Android)',
      'location': 'Bangalore, India',
      'lastActive': '1 week ago',
      'isCurrent': 'false',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Security Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          /// LOGIN ALERTS
          _buildSection(
            title: "Login Alerts",
            children: [
              _buildSwitchTile(
                icon: Icons.notification_important,
                title: "Login Alerts",
                subtitle: "Get notified of new sign-ins",
                value: _loginAlerts,
                onChanged: (value) {
                  setState(() => _loginAlerts = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.warning,
                title: "Suspicious Activity Alerts",
                subtitle: "Alert for unusual account activity",
                value: _suspiciousActivityAlerts,
                onChanged: (value) {
                  setState(() => _suspiciousActivityAlerts = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// APP LOCK
          _buildSection(
            title: "App Lock",
            children: [
              _buildSwitchTile(
                icon: Icons.lock,
                title: "App Lock",
                subtitle: "Require authentication to open app",
                value: _appLock,
                onChanged: (value) {
                  setState(() {
                    _appLock = value;
                    if (!value) {
                      _appLockType = 'None';
                      _biometricAuth = false;
                    }
                  });
                },
              ),
              if (_appLock)
                _buildListTile(
                  icon: Icons.pin,
                  title: "Lock Type",
                  subtitle: _appLockType,
                  onTap: () => _showLockTypeDialog(context),
                ),
              if (_appLock)
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: "Biometric Authentication",
                  subtitle: "Use fingerprint or face ID",
                  value: _biometricAuth,
                  onChanged: (value) {
                    setState(() => _biometricAuth = value);
                  },
                ),
            ],
          ),

          const SizedBox(height: 20),

          /// ACTIVE SESSIONS
          _buildSection(
            title: "Device & Session Management",
            children: [
              ..._activeSessions.map((session) {
                return _buildSessionTile(
                  device: session['device']!,
                  location: session['location']!,
                  lastActive: session['lastActive']!,
                  isCurrent: session['isCurrent'] == 'true',
                  onRemove: session['isCurrent'] != 'true'
                      ? () => _removeSession(session['device']!)
                      : null,
                );
              }),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  child: const Icon(Icons.exit_to_app, color: Colors.red, size: 22),
                ),
                title: const Text(
                  'Sign Out All Other Devices',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                onTap: () => _signOutAllDevices(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// SECURITY HISTORY
          _buildSection(
            title: "Security History",
            children: [
              _buildListTile(
                icon: Icons.history,
                title: "Login History",
                subtitle: "View your login history",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Loading login history...')),
                  );
                },
              ),
              _buildListTile(
                icon: Icons.security,
                title: "Security Checkup",
                subtitle: "Review your security settings",
                onTap: () => _showSecurityCheckup(context),
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

  Widget _buildSessionTile({
    required String device,
    required String location,
    required String lastActive,
    required bool isCurrent,
    VoidCallback? onRemove,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCurrent
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        child: Icon(
          isCurrent ? Icons.phone_android : Icons.devices,
          color: isCurrent ? Colors.green : Colors.grey,
          size: 22,
        ),
      ),
      title: Text(
        device,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '$location • $lastActive',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: isCurrent
          ? const Chip(
              label: Text('Current', style: TextStyle(fontSize: 10)),
              backgroundColor: Colors.green,
              labelStyle: TextStyle(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 8),
            )
          : IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onRemove,
            ),
    );
  }

  void _showLockTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Lock Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('4-Digit PIN'),
              value: '4-Digit PIN',
              groupValue: _appLockType,
              onChanged: (value) {
                setState(() => _appLockType = value!);
                Navigator.pop(context);
                _showSetPINDialog(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('6-Digit PIN'),
              value: '6-Digit PIN',
              groupValue: _appLockType,
              onChanged: (value) {
                setState(() => _appLockType = value!);
                Navigator.pop(context);
                _showSetPINDialog(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Pattern'),
              value: 'Pattern',
              groupValue: _appLockType,
              onChanged: (value) {
                setState(() => _appLockType = value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pattern lock coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSetPINDialog(BuildContext context) {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set $_appLockType'),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          maxLength: _appLockType == '4-Digit PIN' ? 4 : 6,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Enter PIN',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$_appLockType set successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _removeSession(String device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Session'),
        content: Text('Are you sure you want to sign out from $device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _activeSessions.removeWhere((s) => s['device'] == device);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed out from $device'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _signOutAllDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out All Devices'),
        content: const Text(
          'This will sign you out from all devices except this one. You\'ll need to sign in again on those devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _activeSessions.removeWhere((s) => s['isCurrent'] != 'true');
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out from all other devices'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSecurityCheckup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Checkup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckupItem('Two-Factor Authentication', false),
            _buildCheckupItem('Strong Password', true),
            _buildCheckupItem('Login Alerts', _loginAlerts),
            _buildCheckupItem('App Lock', _appLock),
            const SizedBox(height: 16),
            const Text(
              'Security Score: 60%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
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

  Widget _buildCheckupItem(String title, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            color: isEnabled ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}
