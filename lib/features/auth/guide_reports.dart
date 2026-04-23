import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuideReports extends StatelessWidget {
  const GuideReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/admin/user-guide'),
        ),
        title: const Text("Viewing Reports", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 14, 14).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bar_chart, size: 35, color: Color.fromARGB(255, 231, 14, 14)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Viewing Reports", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("Step by step guide", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Cards
            _buildTip(Icons.pie_chart, "Metrics Overview", "View total loans, active visitors, and new books on the dashboard.", const Color.fromARGB(255, 231, 14, 14)),
            _buildTip(Icons.date_range, "Monthly Activity", "Tap 'View Full Report' to see detailed bar charts per day.", const Color.fromARGB(255, 231, 14, 14)),
            _buildTip(Icons.filter_alt, "Filter Data", "Use filters to display data for specific weeks or months.", const Color.fromARGB(255, 231, 14, 14)),
            _buildTip(Icons.download, "Export", "You can download reports as PDF or Excel from the settings menu.", const Color.fromARGB(255, 231, 14, 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(IconData icon, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5, spreadRadius: 1)],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
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
}