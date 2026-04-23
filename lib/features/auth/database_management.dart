import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: SystemSettingsScreen(),
      debugShowCheckedModeBanner: false,
    ));

class SystemSettingsScreen extends StatelessWidget {
  const SystemSettingsScreen({super.key});

  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey = const Color(0xFFFBFBFB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            const CircleAvatar(radius: 15, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hashemite University Admin", style: TextStyle(color: Colors.black, fontSize: 12)),
                Text("إعدادات النظام العامة", style: TextStyle(color: primaryRed, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.black))],
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
            _buildGeneralConfiguration(),
            const SizedBox(height: 30),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  // قسم إدارة قواعد البيانات
  Widget _buildDatabaseManagement() {
    return _buildSectionCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                child: const Text("OPERATIONAL", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Row(children: [Text("Database Management  ", style: TextStyle(fontWeight: FontWeight.bold)), Icon(Icons.storage, size: 18)]),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Manage the core repository of the Academic Curator. Ensure data integrity through scheduled backups and controlled restoration processes.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          _buildDbButton("Initialize", "Wipe & Reset", Icons.refresh, Colors.black),
          const SizedBox(height: 10),
          _buildDbButton("Backup Now", "Full Snapshot", Icons.cloud_upload, Colors.white, isPrimary: true),
          const SizedBox(height: 10),
          _buildDbButton("Restore", "Point in Time", Icons.history, Colors.black),
          const SizedBox(height: 15),
          _buildLastBackupInfo(),
        ],
      ),
    );
  }

  Widget _buildDbButton(String title, String sub, IconData icon, Color textColor, {bool isPrimary = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isPrimary ? primaryRed : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: isPrimary ? null : Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: isPrimary ? Colors.white : primaryRed, size: 20),
          Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          Text(sub, style: TextStyle(color: isPrimary ? Colors.white70 : Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  // قسم اللغة والموقع
  Widget _buildLocalizationSection() {
    return _buildSectionCard(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text("Localization & Language  ", style: TextStyle(fontWeight: FontWeight.bold)), Icon(Icons.public, size: 18)],
          ),
          const SizedBox(height: 15),
          _buildDropdownLabel("Default Interface Language"),
          _buildDropdownField("(Arabic) العربية"),
          const SizedBox(height: 15),
          _buildDropdownLabel("Primary Timezone"),
          _buildDropdownField("Amman (GMT+03:00)"),
        ],
      ),
    );
  }

  // قسم صحة النظام
  Widget _buildSystemHealth() {
    return _buildSectionCard(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text("System Health  ", style: TextStyle(fontWeight: FontWeight.bold))],
          ),
          const SizedBox(height: 15),
          _buildHealthRow("Server Status", "Operational", Icons.check_circle, Colors.green),
          _buildHealthRow("Memory Usage", "GB 1.6 / 4.2", Icons.check_circle, Colors.green),
          _buildHealthRow("Storage Space", "Full 82%", Icons.warning, Colors.orange),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: 0.82, backgroundColor: Colors.grey[200], color: primaryRed, minHeight: 8),
          const SizedBox(height: 5),
          const Text("Storage capacity approaching limit. Consider archiving old logs.", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  // أدوات مساعدة للكود
  Widget _buildSectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[100]!)),
      child: child,
    );
  }

  Widget _buildHealthRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          Row(children: [Text(label), const SizedBox(width: 10), Icon(icon, color: color, size: 18)]),
        ],
      ),
    );
  }

  Widget _buildDropdownLabel(String text) => Align(alignment: Alignment.centerRight, child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)));

  Widget _buildDropdownField(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Icon(Icons.keyboard_arrow_down, color: Colors.grey), Text(text)]),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.red[50]!.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerRight, child: Text("Quick Actions", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          _buildActionItem("Clear System Cache", Icons.bolt),
          _buildActionItem("Run Indexing Service", Icons.search),
          _buildActionItem("Download System Log", Icons.download),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Icon(icon, size: 18, color: Colors.grey)],
      ),
    );
  }

  Widget _buildGeneralConfiguration() {
    return Column(
      children: [
        const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("General Configuration  ", style: TextStyle(fontWeight: FontWeight.bold)), Icon(Icons.tune)]),
        _buildSwitchTile("Maintenance Mode", "Temporarily disable user access while performing updates.", false),
        _buildSwitchTile("Automatic Error Reporting", "Send anonymous diagnostic data to the development team.", true),
        _buildSwitchTile("Academic Term Sync", "Sync repository collections with the university's central academic calendar.", true),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String sub, bool val) {
    return ListTile(
      title: Text(title, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(sub, textAlign: TextAlign.right, style: const TextStyle(fontSize: 11)),
      leading: Switch(value: val, onChanged: (v) {}, activeColor: primaryRed),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      children: [
        Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Discard Changes", style: TextStyle(color: Colors.black)))),
        const SizedBox(width: 15),
        Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: primaryRed), child: const Text("Save Configuration", style: TextStyle(color: Colors.white)))),
      ],
    );
  }

  Widget _buildLastBackupInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.grey, size: 18),
          SizedBox(width: 10),
          Expanded(child: Text("Last automated backup: Today, 04:00 AM", style: TextStyle(fontSize: 10))),
          Text("View History", style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "SETTINGS"),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "LOGS"),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: "ROLES"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "USERS"),
      ],
    );
  }
}