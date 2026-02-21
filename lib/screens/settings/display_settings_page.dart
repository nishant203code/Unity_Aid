import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/theme/app_colors.dart';
import '../../widgets/theme/theme_provider.dart';

class DisplaySettingsPage extends StatefulWidget {
  const DisplaySettingsPage({super.key});

  @override
  State<DisplaySettingsPage> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  String _themeMode = 'System Default';
  String _fontSize = 'Medium';
  String _language = 'English';
  bool _highContrast = false;
  bool _reducedMotion = false;
  bool _screenReader = false;
  double _fontSizeValue = 16.0;

  @override
  void initState() {
    super.initState();
    // Get initial theme mode from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      setState(() {
        _themeMode = themeProvider.themeModeString;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Display & Accessibility",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          /// THEME
          _buildSection(
            title: "Theme",
            children: [
              _buildListTile(
                icon: Icons.dark_mode,
                title: "App Theme",
                subtitle: _themeMode,
                onTap: () => _showThemeDialog(context),
              ),
              _buildSwitchTile(
                icon: Icons.contrast,
                title: "High Contrast",
                subtitle: "Increase color contrast",
                value: _highContrast,
                onChanged: (value) {
                  setState(() => _highContrast = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// TEXT & FONT
          _buildSection(
            title: "Text & Font",
            children: [
              _buildListTile(
                icon: Icons.text_fields,
                title: "Font Size",
                subtitle: _fontSize,
                onTap: () => _showFontSizeDialog(context),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preview Text',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The quick brown fox jumps over the lazy dog',
                      style: TextStyle(fontSize: _fontSizeValue),
                    ),
                    Slider(
                      value: _fontSizeValue,
                      min: 12.0,
                      max: 24.0,
                      divisions: 12,
                      label: _fontSizeValue.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _fontSizeValue = value;
                          if (value < 14) {
                            _fontSize = 'Small';
                          } else if (value < 18) {
                            _fontSize = 'Medium';
                          } else if (value < 21) {
                            _fontSize = 'Large';
                          } else {
                            _fontSize = 'Extra Large';
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// LANGUAGE
          _buildSection(
            title: "Language",
            children: [
              _buildListTile(
                icon: Icons.language,
                title: "App Language",
                subtitle: _language,
                onTap: () => _showLanguageDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ACCESSIBILITY
          _buildSection(
            title: "Accessibility",
            children: [
              _buildSwitchTile(
                icon: Icons.motion_photos_off,
                title: "Reduced Motion",
                subtitle: "Minimize animations",
                value: _reducedMotion,
                onChanged: (value) {
                  setState(() => _reducedMotion = value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.record_voice_over,
                title: "Screen Reader",
                subtitle: "Enable voice assistance",
                value: _screenReader,
                onChanged: (value) {
                  setState(() => _screenReader = value);
                },
              ),
              _buildListTile(
                icon: Icons.accessibility_new,
                title: "Accessibility Features",
                subtitle: "More options",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Advanced accessibility features coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// DISPLAY OPTIONS
          _buildSection(
            title: "Display Options",
            children: [
              _buildListTile(
                icon: Icons.grid_view,
                title: "Layout",
                subtitle: "Customize app layout",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Layout options coming soon!')),
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

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'Light',
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() => _themeMode = value!);
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Theme changed to Light mode'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'Dark',
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() => _themeMode = value!);
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Theme changed to Dark mode'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('System Default'),
              value: 'System Default',
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() => _themeMode = value!);
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Theme set to System Default'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Small',
            'Medium',
            'Large',
            'Extra Large',
          ].map((size) {
            return RadioListTile<String>(
              title: Text(size),
              value: size,
              groupValue: _fontSize,
              onChanged: (value) {
                setState(() {
                  _fontSize = value!;
                  switch (value) {
                    case 'Small':
                      _fontSizeValue = 12.0;
                      break;
                    case 'Medium':
                      _fontSizeValue = 16.0;
                      break;
                    case 'Large':
                      _fontSizeValue = 20.0;
                      break;
                    case 'Extra Large':
                      _fontSizeValue = 24.0;
                      break;
                  }
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'English',
            'हिन्दी (Hindi)',
            'বাংলা (Bengali)',
            'తెలుగు (Telugu)',
            'मराठी (Marathi)',
            'தமிழ் (Tamil)',
          ].map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang.split(' ')[0],
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
