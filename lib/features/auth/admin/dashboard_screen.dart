import 'package:flutter/material.dart';
import 'addbook_screen.dart';
import 'user_management_screen.dart';
import 'admin_settings_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // --- تم حذف الـ AppBar من هنا لأنه موجود في الـ MainWrapper ---
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("OVERVIEW", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
            const Text("Library Metrics", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // بطاقات الإحصائيات
            _buildMetricCard("Total Books", "25,430", "+2.4%", Icons.book_online),
            _buildMetricCard("Active Loans", "1,204", "-1.2%", Icons.sync_alt),
            _buildMetricCard("Pending Suggestions", "42", "Urgent", Icons.assignment_late, isUrgent: true),
            
            const SizedBox(height: 24),
            
            // قسم الأفعال السريعة (Quick Actions)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B0000), // تم توحيد اللون الأحمر
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Actions", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActionButton(context, "Add New Book", Icons.add_circle_outline, const AddBookScreen()),
                  _buildActionButton(context, "User Management", Icons.people_outline, const UserManagementScreen()),
                  _buildActionButton(context, "System Settings", Icons.settings_outlined, const AdminSettingsScreen()),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text("Recent Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildAlertItem("12 Overdue Books", "Faculty of Engineering requires notification.", Icons.error_outline, Colors.red[100]!),
            _buildAlertItem("New Purchase Request", "Advanced Quantum Mechanics requested.", Icons.shopping_cart_outlined, Colors.blue[100]!),
            const SizedBox(height: 40), // مساحة إضافية لتجنب تداخل الـ Bottom Nav
          ],
        ),
      ),
      // --- تم حذف الـ BottomNavigationBar المكرر من هنا ---
    );
  }

  // دالة بناء أزرار الـ Quick Actions
  Widget _buildActionButton(BuildContext context, String title, IconData icon, Widget targetScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: Icon(icon, color: Colors.white, size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String badge, IconData icon, {bool isUrgent = false}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF8B0000)),
        ),
        title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        subtitle: Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isUrgent ? Colors.red[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(badge, style: TextStyle(color: isUrgent ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildAlertItem(String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.black54, size: 20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }
}