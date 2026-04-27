import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SystemSettings {
  final bool maintenanceMode;
  final bool errorReporting;
  final bool termSync;
  final String defaultLanguage;
  final String timezone;
  final String lastBackup;

  SystemSettings({
    required this.maintenanceMode,
    required this.errorReporting,
    required this.termSync,
    required this.defaultLanguage,
    required this.timezone,
    required this.lastBackup,
  });

  factory SystemSettings.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SystemSettings(
      maintenanceMode: data['maintenanceMode'] ?? false,
      errorReporting: data['errorReporting'] ?? true,
      termSync: data['termSync'] ?? true,
      defaultLanguage: data['defaultLanguage'] ?? 'ar',
      timezone: data['timezone'] ?? 'GMT+03:00',
      lastBackup: data['lastBackup'] ?? 'No backups yet',
    );
  }
}

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey = const Color(0xFFFBFBFB);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ زر الرجوع للـ Admin Dashboard
  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/admin');
    }
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    try {
      await _firestore
          .collection('system_config')
          .doc('general_settings')
          .update({key: value});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Setting updated successfully"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating setting: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack, // ✅ يرجع للـ Dashboard
        ),
        title: const Text("System Settings", style: TextStyle(color: Colors.black)),
      ),
      bottomNavigationBar: _buildBottomNav(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDatabaseManagement(),
            const SizedBox(height: 25),
            _buildLocalizationSection(),
            const SizedBox(height: 25),
            _buildSystemHealth(),
            const SizedBox(height: 25),
            _buildQuickActions(),
            const SizedBox(height: 25),
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('system_config')
                  .doc('general_settings')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return _buildGeneralConfiguration(false, true, true);
                }
                final data = snapshot.data!.data() as Map<String, dynamic>;
                return _buildGeneralConfiguration(
                  data['maintenanceMode'] ?? false,
                  data['errorReporting'] ?? true,
                  data['termSync'] ?? true,
                );
              },
            ),
            const SizedBox(height: 30),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseManagement() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Database Management",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Icon(Icons.storage, color: primaryRed),
            ],
          ),
          const SizedBox(height: 5),
          const Text("Manage the core repository of the Academic Curator. Ensure data integrity through scheduled backups and controlled restoration processes.",
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 15),
          _buildActionTile(Icons.refresh, "Initialize", "Wipe & Reset", Colors.grey),
          const SizedBox(height: 10),
          _buildActionTile(Icons.cloud_upload, "Backup Now", "Full Snapshot", primaryRed, filled: true),
          const SizedBox(height: 10),
          _buildActionTile(Icons.history, "Restore", "Point in Time", Colors.grey),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[400], size: 16),
              const SizedBox(width: 8),
              const Text("Last automated backup: Today, 04:00 AM",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              const Spacer(),
              Text("View History", style: TextStyle(color: primaryRed, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, Color color,
      {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: filled ? primaryRed : Colors.white,
        border: filled ? null : Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: filled ? Colors.white : color, size: 22),
          const SizedBox(height: 5),
          Text(title,
              style: TextStyle(
                  color: filled ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          Text(subtitle,
              style: TextStyle(
                  color: filled ? Colors.white70 : Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildLocalizationSection() {
    return _buildCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Localization & Language",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Icon(Icons.language, color: primaryRed),
        ],
      ),
    );
  }

  Widget _buildSystemHealth() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("System Health", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.circle, color: Colors.green, size: 10),
              const SizedBox(width: 8),
              const Text("All systems operational", style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          const Text("System maintenance tools", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildGeneralConfiguration(bool maintenanceMode, bool errorReporting, bool termSync) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("General Configuration",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SwitchListTile(
            title: const Text("Maintenance Mode"),
            value: maintenanceMode,
            onChanged: (val) => _updateSetting('maintenanceMode', val),
            activeColor: primaryRed,
          ),
          SwitchListTile(
            title: const Text("Error Reporting"),
            value: errorReporting,
            onChanged: (val) => _updateSetting('errorReporting', val),
            activeColor: primaryRed,
          ),
          SwitchListTile(
            title: const Text("Term Sync"),
            value: termSync,
            onChanged: (val) => _updateSetting('termSync', val),
            activeColor: primaryRed,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text("Discard"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Saved Successfully")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0: break; // نفس الصفحة
          case 1: context.go('/admin/logs'); break;
          case 2: context.go('/admin/roles'); break;
          case 3: context.go('/admin/users'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "SETTINGS"),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "LOGS"),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: "ROLES"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "USERS"),
      ],
    );
  }
}