import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminUserGuideScreen extends StatefulWidget {
  const AdminUserGuideScreen({super.key});

  @override
  State<AdminUserGuideScreen> createState() => _AdminUserGuideScreenState();
}

class _AdminUserGuideScreenState extends State<AdminUserGuideScreen> {
  final Color primaryRed = const Color(0xFFB01E1E);
  final Color bgGrey = const Color(0xFFF8F9FA);

  final List<Map<String, dynamic>> _guideItems = [
    {
      "title": "How to manage users?",
      "icon": Icons.people,
      "desc": "Learn how to add, remove, or ban users from the system.",
      "route": '/admin/guide/manage-users', // ✅ المسار الجديد
    },
    {
      "title": "System Settings",
      "icon": Icons.settings,
      "desc": "Configure maintenance mode, notifications, and app preferences.",
      "route": '/admin/guide/settings', // ✅ المسار الجديد
    },
    {
      "title": "Viewing Reports",
      "icon": Icons.bar_chart,
      "desc": "Analyze statistics about loans, visitors, and library usage.",
      "route": '/admin/guide/reports', // ✅ المسار الجديد
    },
    {
      "title": "Password Reset",
      "icon": Icons.lock,
      "desc": "Steps to assist students or librarians in resetting passwords.",
      "route": '/admin/guide/password-reset', // ✅ المسار الجديد
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/admin/account'),
        ),
        title: const Text("System User Guide", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: primaryRed.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.menu_book, color: primaryRed, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Welcome, Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Here is how to use the dashboard efficiently.", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("Topics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _guideItems.length,
              itemBuilder: (context, index) {
                final item = _guideItems[index];
                return _buildGuideItem(item['title'], item['icon'], item['desc'], item['route']);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(String title, IconData icon, String desc, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell( // ✅ تم تغليف العنصر بـ InkWell للضغط
        onTap: () {
          context.go(route);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: primaryRed),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}