import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: ReservationRequestsScreen(),
      debugShowCheckedModeBanner: false,
    ));

class ReservationRequestsScreen extends StatelessWidget {
  const ReservationRequestsScreen({super.key});

  final Color primaryRed = const Color(0xFF8B0000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Icon(Icons.menu, color: primaryRed),
        title: Text("The Academic Curator", style: TextStyle(color: primaryRed, fontSize: 16)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF1A2E35),
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryRed,
        child: const Icon(Icons.search, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reservation Requests", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "Review and manage student academic book reservations.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),
            _buildStatusFilters(),
            const SizedBox(height: 25),
            
            // قائمة الطلبات
            _buildRequestCard(
              title: "Advanced Quantum Mechanics",
              author: "Dr. Julian S. Voss",
              student: "Sarah Ahmed (HU-202409)",
              date: "Oct 24, 2023",
              status: "PENDING",
              statusColor: Colors.blue[50]!,
              statusTextColor: Colors.blue[700]!,
            ),
            
            _buildRequestCard(
              title: "Architectural History of Amman",
              author: "Professor Layla Nour",
              student: "Omar Kassab (HU-202315)",
              date: "Oct 22, 2023",
              status: "CONFIRMED",
              statusColor: Colors.blue[50]!,
              statusTextColor: Colors.blue[700]!,
              isConfirmed: true,
            ),

            _buildWeeklySummary(),
            
            _buildRequestCard(
              title: "Principles of Genetic Engineering",
              author: "Dr. Sarah Thompson",
              student: "Zaid Ammari (HU-202412)",
              date: "Oct 26, 2023",
              status: "PENDING",
              statusColor: Colors.blue[50]!,
              statusTextColor: Colors.blue[700]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Row(
      children: [
        _filterBtn("All Requests", true),
        const SizedBox(width: 10),
        _filterBtn("Pending", false),
        const SizedBox(width: 10),
        _filterBtn("Confirmed", false),
      ],
    );
  }

  Widget _filterBtn(String label, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? primaryRed : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: active ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required String title,
    required String author,
    required String student,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    bool isConfirmed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                child: Icon(isConfirmed ? Icons.verified : Icons.book_online, color: primaryRed, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: statusTextColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(author, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 15),
          _buildInfoRow(Icons.person_outline, student),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.calendar_today_outlined, "Reserved on $date"),
          const SizedBox(height: 20),
          Row(
            children: [
              if (!isConfirmed)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text("Approve", style: TextStyle(color: Colors.white)),
                  ),
                ),
              if (!isConfirmed) const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text(isConfirmed ? "Approved" : "Reject", style: const TextStyle(color: Colors.black87)),
                ),
              ),
              if (isConfirmed) const SizedBox(width: 10),
              if (isConfirmed)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }

  Widget _buildWeeklySummary() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x150/8B0000/FFFFFF?text=+'), // خلفية حمراء داكنة
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weekly Summary", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(
                  "You have processed 128 requests this week. 12 requests are still awaiting your review.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.analytics_outlined, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "SUGGESTIONS"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "REQUESTS"),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "DASHBOARD"),
      ],
    );
  }
}