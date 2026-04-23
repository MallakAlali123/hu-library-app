import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey = const Color(0xFFFBFBFB);
  String _selectedFilter = "All";

  final List<Map<String, dynamic>> _logs = [
    {"user": "Ahmad", "action": "Logged In", "time": "Today, 9:00 AM", "icon": Icons.login, "color": const Color.fromARGB(255, 228, 62, 21)},
    {"user": "Dr. Sara", "action": "Added Book", "time": "Today, 9:15 AM", "icon": Icons.book, "color": const Color.fromARGB(255, 228, 66, 26)},
    {"user": "Ahmad", "action": "Edited User", "time": "Today, 10:30 AM", "icon": Icons.edit, "color": const Color.fromARGB(255, 226, 64, 36)},
    {"user": "Dr. Sara", "action": "Deactivated User", "time": "Yesterday, 2:00 PM", "icon": Icons.block, "color": Colors.red},
    {"user": "Ahmad", "action": "Generated Report", "time": "Yesterday, 4:00 PM", "icon": Icons.description, "color": const Color.fromARGB(255, 228, 68, 29)},
    {"user": "Ahmad", "action": "Changed Settings", "time": "2 days ago", "icon": Icons.settings, "color": const Color.fromARGB(255, 226, 65, 44)},
  ];

  List<String> get _filters => ["All", "Login", "Books", "Users", "Reports"];

  List<Map<String, dynamic>> get _filteredLogs {
    if (_selectedFilter == "All") return _logs;
    return _logs.where((log) {
      if (_selectedFilter == "Login") return log["action"].toString().contains("Logged");
      if (_selectedFilter == "Books") return log["action"].toString().contains("Book");
      if (_selectedFilter == "Users") return log["action"].toString().contains("User");
      if (_selectedFilter == "Reports") return log["action"].toString().contains("Report");
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryRed),
          onPressed: () => context.go('/admin/users'),
        ),
        title: Text("Activity Logs",
            style: TextStyle(color: primaryRed, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: _buildBottomNav(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text("سجل العمليات",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
            const Text(
              "Track all admin and librarian actions performed in the system.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = _selectedFilter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryRed : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? primaryRed : Colors.grey[300]!),
                      ),
                      child: Text(f,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          )),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Summary cards
            Row(
              children: [
                _buildSummaryCard("Total Logs", "${_logs.length}", Icons.list_alt, Colors.blue),
                const SizedBox(width: 15),
                _buildSummaryCard("Today", "3", Icons.today, Colors.green),
                const SizedBox(width: 15),
                _buildSummaryCard("Alerts", "1", Icons.warning, Colors.orange),
              ],
            ),
            const SizedBox(height: 25),
            // Logs list
            ..._filteredLogs.map((log) => _buildLogItem(log)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (log["color"] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(log["icon"] as IconData, color: log["color"] as Color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log["action"],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 3),
                Text("By: ${log["user"]}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(log["time"], style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      currentIndex: 1, // LOGS
      onTap: (index) {
        switch (index) {
          case 0: context.go('/admin/system-settings'); break;
          case 1: break;
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