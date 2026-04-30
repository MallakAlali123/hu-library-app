import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  final Color primaryRed = const Color(0xFFB01E1E);
  bool _emailNotifs = true;
  bool _pushNotifs = true;
  bool _smsNotifs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/admin/account'), // ✅ يبقى نفسه
        ),
        title: const Text("Notification Preferences", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionCard(
              Icons.email,
              "Email Notifications",
              "Receive updates about library events via email.",
              primaryRed,
              [
                _buildSwitchTile("Weekly Report", "Get summary of weekly activities.", _emailNotifs, (val) => setState(() => _emailNotifs = val)),
                _buildSwitchTile("New Books Alert", "Notify when new books arrive.", _emailNotifs, (val) => setState(() => _emailNotifs = val)),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              Icons.notifications_active,
              "Push Notifications",
              "Receive alerts on your device instantly.",
              primaryRed,
              [
                _buildSwitchTile("System Alerts", "Important system updates.", _pushNotifs, (val) => setState(() => _pushNotifs = val)),
                _buildSwitchTile("User Requests", "When students request books.", _pushNotifs, (val) => setState(() => _pushNotifs = val)),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              Icons.sms,
              "SMS Notifications",
              "Get text messages for urgent matters.",
              primaryRed,
              [
                _buildSwitchTile("Overdue Books", "Remind users about late returns.", _smsNotifs, (val) => setState(() => _smsNotifs = val)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(IconData icon, String title, String desc, Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Switch(
        activeColor: primaryRed,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}