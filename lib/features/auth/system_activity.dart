import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

// --- Model ---
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

  // ✅ رجوع آمن
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
        const SnackBar(
          content: Text("Setting updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating setting: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,

      // ---------------- AppBar ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack,
        ),

        title: const Text(
          "System Settings",
          style: TextStyle(color: Colors.black),
        ),
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

            // ---------------- Firebase Settings ----------------
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

  // ---------------- Database Section ----------------
  Widget _buildDatabaseManagement() {
    return _buildCard(
      child: Column(
        children: const [
          Text("Database Management", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Manage system data and backups"),
        ],
      ),
    );
  }

  // ---------------- Localization ----------------
  Widget _buildLocalizationSection() {
    return _buildCard(
      child: Column(
        children: const [
          Text("Localization & Language", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Language & timezone settings"),
        ],
      ),
    );
  }

  // ---------------- System Health ----------------
  Widget _buildSystemHealth() {
    return _buildCard(
      child: Column(
        children: const [
          Text("System Health", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("All systems operational"),
        ],
      ),
    );
  }

  // ---------------- Quick Actions ----------------
  Widget _buildQuickActions() {
    return _buildCard(
      child: Column(
        children: const [
          Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("System maintenance tools"),
        ],
      ),
    );
  }

  // ---------------- General Config ----------------
  Widget _buildGeneralConfiguration(
      bool maintenanceMode, bool errorReporting, bool termSync) {
    return Column(
      children: [
        const Text("General Configuration",
            style: TextStyle(fontWeight: FontWeight.bold)),

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
    );
  }

  // ---------------- Footer ----------------
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
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }

  // ---------------- Card ----------------
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  // ---------------- Bottom Nav ----------------
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/admin/system-settings');
            break;
          case 1:
            context.go('/admin/logs');
            break;
          case 2:
            context.go('/admin/roles');
            break;
          case 3:
            context.go('/admin/users');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "SETTINGS"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "LOGS"),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: "ROLES"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "USERS"),
      ],
    );
  }
}