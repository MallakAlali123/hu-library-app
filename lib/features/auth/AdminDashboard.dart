import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Color primaryRed = const Color(0xFFB01E1E);
  final Color bgGrey = const Color(0xFFF8F9FA);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getTotalBooks() async {
    try {
      AggregateQuerySnapshot snapshot = await _firestore.collection('books').count().get();
      return snapshot.count ?? 0;
    } catch (e) { return 0; }
  }

  Future<int> _getActiveLoans() async {
    try {
      AggregateQuerySnapshot snapshot = await _firestore
          .collection('loans').where('status', isEqualTo: 'borrowed').count().get();
      return snapshot.count ?? 0;
    } catch (e) { return 0; }
  }

  Future<int> _getPendingSuggestions() async {
    try {
      AggregateQuerySnapshot snapshot = await _firestore
          .collection('suggestions').where('status', isEqualTo: 'PENDING').count().get();
      return snapshot.count ?? 0;
    } catch (e) { return 0; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      bottomNavigationBar: _buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 25),
              const Text("OVERVIEW", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
              const Text("Library Metrics", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Align(alignment: Alignment.centerRight, child: Text("Live Data", style: TextStyle(color: Colors.grey, fontSize: 12))),
              const SizedBox(height: 20),

              FutureBuilder(
                future: Future.wait([_getTotalBooks(), _getActiveLoans(), _getPendingSuggestions()]),
                builder: (context, AsyncSnapshot<List<int>> snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return Column(
                    children: [
                      _buildMetricCard("Total Books", "${snapshot.data![0]}", "+2.4%", Icons.book, Colors.green),
                      _buildMetricCard("Active Loans", "${snapshot.data![1]}", "-1.2%", Icons.swap_horiz, Colors.red),
                      _buildMetricCard("Pending Suggestions", "${snapshot.data![2]}", "Urgent", Icons.edit_note, Colors.orange),
                    ],
                  );
                },
              ),

              const SizedBox(height: 25),
              _buildChartSection(),
              const SizedBox(height: 25),
              _buildQuickActions(context), // ✅ هنا التعديل
              const SizedBox(height: 25),
              _buildRecentAlerts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("The Digital\nCurator", style: TextStyle(color: Color(0xFF800000), fontWeight: FontWeight.bold, fontSize: 20)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF444444)),
              onPressed: () {},
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () => context.go('/admin/account'),
              child: CircleAvatar(
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null ? const Icon(Icons.person) : null,
                backgroundColor: Colors.blueGrey[100],
                radius: 18,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: primaryRed, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // ✅ FIXED
          _actionButton("Add New Book", Icons.add_circle_outline, onTap: () {
            context.push('/admin/add-book');
          }),

          _actionButton("Generate Report", Icons.description_outlined, onTap: () {
            context.push('/admin/generate-report');
          }),

          _actionButton("System Settings", Icons.settings_outlined, onTap: () {
            context.go('/admin/system-settings');
          }),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          case 0: context.go('/admin/users'); break;
          case 1: context.go('/admin/users'); break;
          case 2: break;
          case 3: context.go('/admin/account'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "SUGGESTIONS"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "REQUESTS"),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "DASHBOARD"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "ACCOUNT"),
      ],
    );
  }

  // باقي الدوال (ما تغيرت)
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
              child: Icon(icon, color: primaryRed),
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
      child: const Text("Chart Placeholder"),
    );
  }

  Widget _buildRecentAlerts() {
    return const Text("Alerts Placeholder");
  }
}