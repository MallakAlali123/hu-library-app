import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey = const Color(0xFFFBFBFB);

  final List<Map<String, dynamic>> _roles = [
    {
      "role": "admin",
      "label": "Administrator",
      "color": const Color.fromARGB(255, 207, 14, 14),
      "icon": Icons.admin_panel_settings,
      "permissions": [
        "Manage all users",
        "Add / Delete books",
        "View all reports",
        "Change system settings",
        "Manage roles",
        "View activity logs",
      ]
    },
    {
      "role": "librarian",
      "label": "Librarian",
      "color": const Color.fromARGB(255, 207, 14, 14),
      "icon": Icons.local_library,
      "permissions": [
        "Add / Edit books",
        "Manage loans",
        "View student info",
        "Generate reports",
      ]
    },
    {
      "role": "student",
      "label": "Student",
      "color": const Color.fromARGB(255, 207, 14, 14),
      "icon": Icons.school,
      "permissions": [
        "Browse books",
        "Borrow books",
        "Submit suggestions",
        "View own loans",
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        // ✅ الإصلاح: زر الرجوع يرجع للـ Dashboard
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryRed),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
        title: Text("Roles & Permissions",
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
              child: Text("الأدوار والصلاحيات",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 5),
            const Text(
              "View and manage system roles and their associated permissions.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 25),
            ..._roles.map((role) => _buildRoleCard(role)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(Map<String, dynamic> role) {
    final Color color = role["color"] as Color;
    final List<String> permissions = role["permissions"] as List<String>;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(role["icon"] as IconData, color: color, size: 22),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(role["label"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                    Text("${permissions.length} permissions",
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(role["role"],
                      style: TextStyle(
                          color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: permissions
                  .map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: color, size: 16),
                            const SizedBox(width: 10),
                            Text(p, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      currentIndex: 2,
      onTap: (index) {
        switch (index) {
          // ✅ التنقل بين صفحات المجموعة بـ go عادي
          case 0: context.go('/admin/system-settings'); break;
          case 1: context.go('/admin/logs'); break;
          case 2: break;
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