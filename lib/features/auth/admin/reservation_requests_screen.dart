import 'package:flutter/material.dart';

class ReservationRequestsScreen extends StatelessWidget {
  const ReservationRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "The Academic Curator",
          style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF001529),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reservation Requests", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text(
              "Review and manage student academic book reservations.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // أزرار الفلترة العلوية
            Row(
              children: [
                _buildFilterButton("All Requests", true),
                const SizedBox(width: 8),
                _buildFilterButton("Pending", false),
                const SizedBox(width: 8),
                _buildFilterButton("Confirmed", false),
              ],
            ),

            const SizedBox(height: 24),

            // قائمة الطلبات
            _buildRequestCard(
              context,
              title: "Advanced Quantum Mechanics",
              author: "Dr. Julian S. Voss",
              studentName: "Sarah Ahmed",
              studentId: "HU-202409",
              date: "Oct 24, 2023",
              status: "PENDING",
              isConfirmed: false,
            ),
            
            _buildRequestCard(
              context,
              title: "Architectural History of Amman",
              author: "Professor Layla Nour",
              studentName: "Omar Kassab",
              studentId: "HU-202315",
              date: "Oct 22, 2023",
              status: "CONFIRMED",
              isConfirmed: true,
            ),

            _buildRequestCard(
              context,
              title: "Modern Digital Economics",
              author: "Dr. Michael Chen",
              studentName: "Elena Rodriguez",
              studentId: "HU-202488",
              date: "Oct 25, 2023",
              status: "PENDING",
              isConfirmed: false,
            ),

            // بطاقة الملخص الأسبوعي (Weekly Summary)
            _buildWeeklySummary(),

            const SizedBox(height: 16),

            _buildRequestCard(
              context,
              title: "Principles of Genetic Engineering",
              author: "Dr. Sarah Thompson",
              studentName: "Zaid Ammari",
              studentId: "HU-202412",
              date: "Oct 26, 2023",
              status: "PENDING",
              isConfirmed: false,
            ),
            const SizedBox(height: 80), // مساحة إضافية للزر العائم
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF8B0000),
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  // مكوّن أزرار الفلترة
  Widget _buildFilterButton(String label, bool isSelected) {
    return Expanded(
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B0000) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // مكوّن بطاقة طلب الحجز
  Widget _buildRequestCard(
    BuildContext context, {
    required String title,
    required String author,
    required String studentName,
    required String studentId,
    required String date,
    required String status,
    required bool isConfirmed,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                  child: Icon(isConfirmed ? Icons.check_circle : Icons.edit_calendar, 
                      color: isConfirmed ? Colors.blue : const Color(0xFF8B0000), size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isConfirmed ? Colors.blue[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: TextStyle(color: isConfirmed ? Colors.blue[900] : Colors.blue[900], fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(author, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Text("$studentName ($studentId)", style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Text("Reserved on $date", style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            if (!isConfirmed)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0000), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Approve", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Reject", style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null, // معطل لأنه مقبول مسبقاً
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Approved", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.delete_outline, color: Colors.grey),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  // مكوّن الملخص الأسبوعي الأحمر
  Widget _buildWeeklySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB01116),
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/dark-matter.png'), // تأثير خلفية بسيط
          opacity: 0.1,
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Weekly Summary", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  "You have processed 128 requests this week. 12 requests are still awaiting your review.",
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.auto_graph, color: Colors.white, size: 30),
          )
        ],
      ),
    );
  }
}