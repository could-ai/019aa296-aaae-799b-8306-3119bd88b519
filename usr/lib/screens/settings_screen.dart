import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoLocation = true;
  bool _notificationsEnabled = true;
  String _calculationMethod = 'أم القرى';
  String _adhanSound = 'مكة المكرمة';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('الموقع والوقت'),
          SwitchListTile(
            title: const Text('تحديد الموقع تلقائياً'),
            subtitle: const Text('استخدام GPS لتحديد أوقات الصلاة بدقة'),
            value: _autoLocation,
            onChanged: (val) {
              setState(() => _autoLocation = val);
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          ListTile(
            title: const Text('طريقة الحساب'),
            subtitle: Text(_calculationMethod),
            leading: const Icon(Icons.calculate),
            onTap: () {
              // Show dialog to select method
            },
          ),
          
          const Divider(),
          _buildSectionHeader('التنبيهات والأصوات'),
          SwitchListTile(
            title: const Text('تفعيل التنبيهات'),
            subtitle: const Text('إشعارات عند دخول وقت الصلاة'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          ListTile(
            title: const Text('صوت الأذان'),
            subtitle: Text(_adhanSound),
            leading: const Icon(Icons.music_note),
            onTap: () {
              // Show dialog to select sound
            },
          ),
          ListTile(
            title: const Text('تعديل التوقيت'),
            subtitle: const Text('تقديم أو تأخير الدقائق يدوياً'),
            leading: const Icon(Icons.tune),
            onTap: () {},
          ),

          const Divider(),
          _buildSectionHeader('عام'),
          ListTile(
            title: const Text('اللغة'),
            subtitle: const Text('العربية'),
            leading: const Icon(Icons.language),
            onTap: () {},
          ),
          ListTile(
            title: const Text('حول التطبيق'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'أوقات الصلاة',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 CouldAI',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
