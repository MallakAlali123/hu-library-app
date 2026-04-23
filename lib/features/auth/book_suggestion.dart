import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- 1. نموذج بيانات الاقتراح (Suggestion Model) ---
class BookSuggestion {
  final String id;
  final String title;
  final String author;
  final String category;
  final String studentName;
  final String studentId;
  final String status; // 'PENDING', 'REVIEWED', 'ADDED'
  final DateTime createdAt;

  BookSuggestion({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.studentName,
    required this.studentId,
    required this.status,
    required this.createdAt,
  });

  factory BookSuggestion.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return BookSuggestion(
      id: snapshot.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      studentName: data['studentName'] ?? '',
      studentId: data['studentId'] ?? '',
      status: data['status'] ?? 'PENDING',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}

void main() => runApp(const MaterialApp(
      home: BookSuggestionsScreen(),
      debugShowCheckedModeBanner: false,
    ));

class BookSuggestionsScreen extends StatefulWidget {
  const BookSuggestionsScreen({super.key});

  @override
  State<BookSuggestionsScreen> createState() => _BookSuggestionsScreenState();
}

class _BookSuggestionsScreenState extends State<BookSuggestionsScreen> {
  final Color primaryRed = const Color(0xFF8B0000);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // متغيرات للبحث والفلترة
  String _searchQuery = "";
  String _filterStatus = "All"; // All, Pending, Reviewed

  // دالة تحديث حالة الاقتراح
  Future<void> _updateStatus(String docId, String newStatus) async {
    try {
      await _firestore.collection('suggestions').doc(docId).update({
        'status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated to $newStatus"), backgroundColor: Colors.green),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: primaryRed),
        title: Text("The Academic Curator", style: TextStyle(color: primaryRed, fontSize: 16)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(backgroundColor: Colors.black, child: Icon(Icons.person, size: 20, color: Colors.white)),
          )
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Book Suggestions", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "Review and curate student-recommended literature to enhance the university's academic collection.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),
            _buildSearchAndFilter(),
            const SizedBox(height: 25),
            
            // --- 2. StreamBuilder لربط البيانات ---
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('suggestions')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData) {
                  return _buildAwaitingProposals();
                }

                List<BookSuggestion> suggestions = snapshot.data!.docs
                    .map((doc) => BookSuggestion.fromSnapshot(doc))
                    .toList();

                // تطبيق البحث والفلترة (Client-side filtering)
                if (_filterStatus != "All") {
                  suggestions = suggestions.where((s) => s.status == _filterStatus.toUpperCase()).toList();
                }
                
                if (_searchQuery.isNotEmpty) {
                  suggestions = suggestions.where((s) => 
                    s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    s.author.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();
                }

                if (suggestions.isEmpty) {
                  return _buildAwaitingProposals();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    
                    // تحديد الألوان بناءً على الحالة
                    Color statusColor = Colors.orange[100]!;
                    if (suggestion.status == 'REVIEWED') statusColor = Colors.blue[100]!;
                    if (suggestion.status == 'ADDED') statusColor = Colors.green[100]!;

                    return _buildSuggestionCard(
                      id: suggestion.id,
                      title: suggestion.title,
                      author: suggestion.author,
                      category: suggestion.category,
                      student: suggestion.studentName,
                      studentId: suggestion.studentId,
                      status: suggestion.status,
                      statusColor: statusColor,
                      isReviewed: suggestion.status != 'PENDING',
                    );
                  },
                );
              },
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
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search by title, author, or student name",
              prefixIcon: const Icon(Icons.search),
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
                  onPressed: () {
                    setState(() {
                      // تبديل الفلتر: All -> Pending -> Reviewed -> All
                      if (_filterStatus == "All") _filterStatus = "Pending";
                      else if (_filterStatus == "Pending") _filterStatus = "Reviewed";
                      else _filterStatus = "All";
                    });
                  },
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: Text("Filter: $_filterStatus"),
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // فتح شاشة إضافة اقتراح جديد (يمكنك إضافتها لاحقاً)
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Open Add Suggestion Screen")));
                  },
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

  Widget _buildSuggestionCard({
    required String id,
    required String title,
    required String author,
    required String category,
    required String student,
    required String studentId,
    required String status,
    required Color statusColor,
    bool isReviewed = false,
  }) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey[200]!)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(5)),
                  child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(author, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 10),
            Chip(
              label: Text(category, style: const TextStyle(fontSize: 11)),
              avatar: const Icon(Icons.science_outlined, size: 14),
              backgroundColor: Colors.grey[100],
              side: BorderSide.none,
            ),
            const Divider(height: 30),
            Row(
              children: [
                CircleAvatar(radius: 15, backgroundColor: Colors.red[50], child: Text(student.isNotEmpty ? student[0] : 'A', style: TextStyle(color: primaryRed, fontSize: 12))),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("ID: $studentId", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (status != 'ADDED')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateStatus(id, 'REVIEWED'),
                      style: OutlinedButton.styleFrom(side: BorderSide(color: primaryRed)),
                      child: Text("Mark Reviewed", style: TextStyle(color: primaryRed)),
                    ),
                  ),
                if (status != 'ADDED') const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(id, 'ADDED'),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                    child: const Text("Add to Library", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAwaitingProposals() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_stories_outlined, color: Colors.grey[300], size: 40),
          const SizedBox(height: 10),
          const Text("Awaiting New Proposals", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("Student requests appear here automatically.", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "SUGGESTIONS"),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "REQUESTS"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "DASHBOARD"),
      ],
    );
  }
}