import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final Color primaryRed = const Color(0xFFB01E1E);
  final Color bgGrey = const Color(0xFFF8F9FA);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (mounted) context.go('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$feature page is under construction"), backgroundColor: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
        title: const Text("Admin Settings", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              user == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<DocumentSnapshot>(
                      future: _firestore.collection('users').doc(user.uid).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildProfileCardSkeleton();
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return _buildProfileCardSkeleton();
                        }
                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                        return _buildProfileCard(
                          name: userData['name'] ?? 'Admin User',
                          role: userData['role'] ?? 'admin',
                          studentId: userData['studentId'] ?? 'N/A',
                          photoUrl: user.photoURL ?? '',
                        );
                      },
                    ),
              const SizedBox(height: 20),
              _buildSectionHeader("Account Settings", Icons.manage_accounts_outlined),
              _buildSettingsItem("Change Password", Icons.lock_outline, onTap: () {
                context.push('/admin/change-password');
              }),
              _buildSettingsItem("Notification Preferences", Icons.notifications_none, onTap: () {
                context.push('/admin/notification-preferences'); // ✅ تم التعديل
              }),
              _buildSettingsItem("Language & Location", Icons.language, onTap: () {
                context.push('/admin/language-location');
              }),
              const SizedBox(height: 20),
              _buildSectionHeader("User Management", Icons.group_outlined),
              _buildSettingsItem("Manage Users", Icons.person_add_alt,
                  onTap: () => context.push('/admin/users')),
              _buildSettingsItem("System Settings", Icons.settings,
                  onTap: () => context.push('/admin/system-settings')),
              _buildSettingsItem("Admin Activity Log", Icons.history_edu, onTap: () {
                _showComingSoon("Activity Log");
              }),
              const SizedBox(height: 20),
              _buildAdvancedMetrics(),
              const SizedBox(height: 20),
              _buildSectionHeader("Technical Support", Icons.support_agent),
              _buildSettingsItem("Open Support Ticket", Icons.help_outline, onTap: () {
                context.push('/admin/support-ticket');
              }),
              _buildSettingsItem("System User Guide", Icons.menu_book, onTap: () {
                context.push('/admin/user-guide');
              }),
              const SizedBox(height: 20),
              _buildSystemStatus(),
              const SizedBox(height: 30),
              _buildLogoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String name,
    required String role,
    required String studentId,
    required String photoUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                child: photoUrl.isEmpty
                    ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.verified, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text("$name - $role", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag(studentId, Icons.badge_outlined),
              const SizedBox(width: 10),
              _buildTag("Admin Member", Icons.admin_panel_settings),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push('/admin/edit-profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              minimumSize: const Size(200, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      height: 250,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: primaryRed, size: 20),
          ),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildAdvancedMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Advanced Metrics", style: TextStyle(fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => context.push('/admin/reports'),
                child: Text("View Full Report", style: TextStyle(color: primaryRed, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildMetricItem("Total Loans", "12,450", "+12% this month", Colors.green),
          _buildMetricItem("Active Visitors", "3,892", "+5% this week", Colors.green),
          _buildMetricItem("New Books", "428", "In the last 30 days", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, String trend, Color trendColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(trend, style: TextStyle(color: trendColor, fontSize: 10)),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildStatusRow("System Status", "Stable", Colors.green),
          const Divider(),
          _buildStatusRow("System Version", "v2.4.1-stable", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Row(
          children: [
            if (color == Colors.green) Icon(Icons.circle, color: color, size: 10),
            const SizedBox(width: 5),
            Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text("Log Out of System", style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}