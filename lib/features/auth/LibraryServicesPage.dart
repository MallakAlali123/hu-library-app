import 'package:flutter/material.dart';


class LibraryServicesPage extends StatefulWidget {
  const LibraryServicesPage({super.key});

  @override
  State<LibraryServicesPage> createState() => _LibraryServicesPageState();
}

class _LibraryServicesPageState extends State<LibraryServicesPage> {
  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: primaryRed),
        title: Row(
          children: [
            Image.network('https://via.placeholder.com/40', height: 30), // استبدل بصورة الشعار
            const SizedBox(width: 10),
            Text("The Academic Curator", style: TextStyle(color: primaryRed, fontSize: 16)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.person, size: 20, color: Colors.white)
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
            _buildSearchAndFilter(),
            const SizedBox(height: 25),
            
            // عرض قائمة الطلبات (محاكاة للآن حتى يتم الربط بالـ Firebase)
            _buildRequestCard(
              title: "Advanced Quantum Mechanics",
              author: "Dr. Julian S. Voss",
              student: "Sarah Ahmed (HU-202409)",
              date: "Oct 24, 2023",
              status: "PENDING",
              statusColor: Colors.blue[50]!,
            ),
            
            _buildRequestCard(
              title: "Architectural History of Amman",
              author: "Professor Layla Nour",
              student: "Omar Kassab (HU-202315)",
              date: "Oct 22, 2023",
              status: "CONFIRMED",
              statusColor: Colors.green[50]!,
              isConfirmed: true,
            ),
            
            _buildRequestCard(
              title: "Principles of Genetic Engineering",
              author: "Dr. Sarah Thompson",
              student: "Zaid Ammari (HU-202412)",
              date: "Oct 26, 2023",
              status: "PENDING",
              statusColor: Colors.blue[50]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search by title, author, or student name",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text("Filter"),
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text("New Entry", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                ),
              ),
            ],
          )
        ],
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
    bool isConfirmed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
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
                child: Text(status, style: TextStyle(color: primaryRed, fontSize: 10, fontWeight: FontWeight.bold)),
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
                  child: const Text("Reject", style: TextStyle(color: Colors.black87)),
                ),
              ),
              if (isConfirmed) const SizedBox(width: 10),
              if (isConfirmed)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text("Undo", style: TextStyle(color: Colors.white)),
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
          image: NetworkImage('https://via.placeholder.com/400x150/8B0000/FFFFFF?text=+'),
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
                const SizedBox(height: 5),
                Text(
                  "You have processed 128 requests this week. 12 requests are still awaiting your review.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
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
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "DASHBOARD"),
      ],
    );
  }}