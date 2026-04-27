import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// --- 1. نموذج البيانات (Data Model) ---
// هذا الكلاس يمثل المستند الواحد في قاعدة البيانات
class ReservationRequest {
  final String id;
  final String title;
  final String author;
  final String studentName;
  final String date;
  final String status; // 'PENDING', 'CONFIRMED'
  
  ReservationRequest({
    required this.id,
    required this.title,
    required this.author,
    required this.studentName,
    required this.date,
    required this.status,
  });

  // دالة لتحويل المستند من Firebase إلى كائن
  factory ReservationRequest.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ReservationRequest(
      id: snapshot.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      studentName: data['studentName'] ?? '',
      date: data['date'] ?? '',
      status: data['status'] ?? 'PENDING',
    );
  }
}

void main() async {
  // تهيئة Firebase قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReservationRequestsScreen(),
    );
  }
}

class ReservationRequestsScreen extends StatefulWidget {
  const ReservationRequestsScreen({super.key});

  @override
  State<ReservationRequestsScreen> createState() => _ReservationRequestsScreenState();
}

class _ReservationRequestsScreenState extends State<ReservationRequestsScreen> {
  final Color primaryRed = const Color(0xFF8B0000);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // متغير للتحكم بالفلترة (All, Pending, Confirmed)
  String _selectedFilter = 'All';

  // دالة لجلب البيانات بناءً على الفلتر
  Stream<QuerySnapshot> _getRequestsStream() {
    CollectionReference requestsRef = _firestore.collection('reservations');
    
    if (_selectedFilter == 'All') {
      return requestsRef.orderBy('date', descending: true).snapshots();
    } else if (_selectedFilter == 'Pending') {
      return requestsRef.where('status', isEqualTo: 'PENDING').orderBy('date', descending: true).snapshots();
    } else { // Confirmed
      return requestsRef.where('status', isEqualTo: 'CONFIRMED').orderBy('date', descending: true).snapshots();
    }
  }

  // دالة لتحديث الحالة (قبول أو رفض)
  Future<void> _updateStatus(String docId, String newStatus) async {
    try {
      await _firestore.collection('reservations').doc(docId).update({
        'status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request marked as $newStatus"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating status: $e"), backgroundColor: Colors.red),
      );
    }
  }

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
            
            // --- 2. StreamBuilder لربط البيانات ---
            StreamBuilder<QuerySnapshot>(
              stream: _getRequestsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No requests found."));
                }

                // تحويل البيانات وعرضها
                var requests = snapshot.data!.docs.map((doc) => ReservationRequest.fromSnapshot(doc)).toList();
                
                return Column(
                  children: [
                    // نقوم بإدراج الملخص الأسبوعي هنا بين البيانات أو في البداية
                    _buildWeeklySummary(),
                    const SizedBox(height: 20),

                    ...requests.map((request) {
                      bool isConfirmed = request.status == 'CONFIRMED';
                      return _buildRequestCard(
                        id: request.id,
                        title: request.title,
                        author: request.author,
                        student: request.studentName,
                        date: request.date,
                        status: request.status,
                        statusColor: isConfirmed ? Colors.green[50]! : Colors.blue[50]!,
                        statusTextColor: isConfirmed ? Colors.green[700]! : Colors.blue[700]!,
                        isConfirmed: isConfirmed,
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Row(
      children: [
        _filterBtn("All Requests", _selectedFilter == 'All'),
        const SizedBox(width: 10),
        _filterBtn("Pending", _selectedFilter == 'Pending'),
        const SizedBox(width: 10),
        _filterBtn("Confirmed", _selectedFilter == 'Confirmed'),
      ],
    );
  }

  Widget _filterBtn(String label, bool active) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (label.contains("All")) _selectedFilter = 'All';
            else if (label.contains("Pending")) _selectedFilter = 'Pending';
            else _selectedFilter = 'Confirmed';
          });
        },
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
      ),
    );
  }

  // تم إضافة معرف الـ id لاستخدامه عند التعديل
  Widget _buildRequestCard({
    required String id,
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
                    onPressed: () => _updateStatus(id, 'CONFIRMED'),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text("Approve", style: TextStyle(color: Colors.white)),
                  ),
                ),
              if (!isConfirmed) const SizedBox(width: 10),
              
              // زر الرفض أو الحذف
              if (!isConfirmed)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(id, 'REJECTED'), // يمكن إضافة حالة Rejected
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text("Reject", style: TextStyle(color: Colors.black87)),
                  ),
                ),
              
              if (isConfirmed) const SizedBox(width: 10),
              if (isConfirmed)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(id, 'PENDING'), // إعادة للحالة المعلقة كمثال
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text("Undo", style: TextStyle(color: Colors.black87)),
                  ),
                ),
              if (isConfirmed)
                const SizedBox(width: 10),
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
        color: primaryRed, // استخدام اللون الأساسي مباشرة بدل الصورة لضمان الظهور
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
            // ignore: deprecated_member_use
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