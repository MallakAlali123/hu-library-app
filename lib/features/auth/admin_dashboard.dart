import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AdminDashboard()));

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // الألوان المستخدمة في التصميم
  final Color primaryRed = const Color(0xFFB01E1E);
  final Color bgGrey = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              const Text("OVERVIEW", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
              const Text("Library Metrics", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Align(alignment: Alignment.centerRight, child: Text("Last Sync: Oct 24, 2023", style: TextStyle(color: Colors.grey, fontSize: 12))),
              
              const SizedBox(height: 20),
              // بطاقات الإحصائيات
              _buildMetricCard("Total Books", "25,430", "+2.4%", Icons.book, Colors.green),
              _buildMetricCard("Active Loans", "1,204", "-1.2%", Icons.swap_horiz, Colors.red),
              _buildMetricCard("Pending Suggestions", "42", "Urgent", Icons.edit_note, Colors.orange),
              
              const SizedBox(height: 25),
              _buildChartSection(),
              
              const SizedBox(height: 25),
              _buildQuickActions(),
              
              const SizedBox(height: 25),
              _buildRecentAlerts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("The Digital\nCurator", style: TextStyle(color: Color(0xFF800000), fontWeight: FontWeight.bold, fontSize: 20)),
        Row(
          children: [
            const Icon(Icons.notifications, color: Color(0xFF444444)),
            const SizedBox(width: 15),
            CircleAvatar(backgroundColor: Colors.blueGrey[100], radius: 18),
          ],
        )
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String badge, IconData icon, Color badgeColor) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: const Color(0xFFB01E1E)),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.blueGrey)),
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: badgeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Circulation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(40, "JAN"), _buildBar(60, "FEB"), _buildBar(80, "MAR"),
              _buildBar(55, "APR", isCurrent: true), _buildBar(45, "MAY"), 
              _buildBar(70, "JUN"), _buildBar(90, "JUL"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBar(double height, String label, {bool isCurrent = false}) {
    return Column(
      children: [
        if (isCurrent) Container(padding: const EdgeInsets.all(4), color: Colors.black, child: const Text("Current", style: TextStyle(color: Colors.white, fontSize: 8))),
        Container(
          height: height,
          width: 25,
          decoration: BoxDecoration(
            color: isCurrent ? const Color(0xFFB01E1E) : Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFB01E1E), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _actionButton("Add New Book", Icons.add_circle_outline),
          _actionButton("Generate Report", Icons.description_outlined),
          _actionButton("System Settings", Icons.settings_outlined),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          Icon(icon, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildRecentAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _alertItem("12 Overdue Books", "Faculty of Engineering requires immediate notification.", Icons.priority_high, Colors.red[50]!),
        _alertItem("New Purchase Request", "'Advanced Quantum Mechanics' requested by Dr. Ahmed.", Icons.shopping_cart_outlined, Colors.blue[50]!),
      ],
    );
  }

  Widget _alertItem(String title, String subtitle, IconData icon, Color bg) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, size: 20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFB01E1E),
      unselectedItemColor: Colors.grey,
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "SUGGESTIONS"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "REQUESTS"),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "DASHBOARD"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "ACCOUNT"),
      ],
    );
  }
}