import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuidePasswordReset extends StatelessWidget {
  const GuidePasswordReset({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildGuideDesign(
      context: context,
      title: "Password Reset",
      icon: Icons.lock,
      color: Colors.red,
      tips: [
        _buildTip(Icons.person_search, "Find User", "Go to User Management and search for the student or librarian."),
        _buildTip(Icons.email, "Email Link", "Click 'Send Reset Link' to email them a secure recovery link."),
        _buildTip(Icons.edit, "Manual Reset", "You can manually set a temporary password if they cannot access email."),
        _buildTip(Icons.timer, "Valid Link", "The reset link is only valid for 1 hour for security reasons."),
      ],
      backRoute: '/admin/user-guide',
    );
  }

  Widget _buildTip(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, spreadRadius: 1),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.red[700], size: 24),
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
        ],
      ),
    );
  }
}  Widget _buildGuideDesign({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> tips,
    required String backRoute,
  }) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go(backRoute),
        ),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Design
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 35),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("Step by step guide", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // List of Tips
            ...tips,
          ],
        ),
      ),
    );
  }