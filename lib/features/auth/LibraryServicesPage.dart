import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LibraryServicesPage extends StatefulWidget {
  const LibraryServicesPage({super.key});

  @override
  State<LibraryServicesPage> createState() => _LibraryServicesPageState();
}

class _LibraryServicesPageState extends State<LibraryServicesPage> {
  int _currentIndex = 0;

  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey = const Color(0xFFF8F9FA);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Color(0xFF8B0000)),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _auth.signOut();
    if (mounted) context.go('/login');
  }

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("Logo",
                  style: TextStyle(
                      color: primaryRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
            const SizedBox(width: 10),
            Text("The Academic Curator",
                style: TextStyle(color: primaryRed, fontSize: 16)),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildRequestsTab(),
          _buildBooksTab(),
          _buildAnnouncementsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: primaryRed,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _searchQuery = "";
            _searchController.clear();
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Books"),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: "Announce"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ==========================================
  // 1. Requests Tab
  // ==========================================
  Widget _buildRequestsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Reservation Requests", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Review and manage student requests.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),
          _buildSearchBar(onChanged: (val) => setState(() => _searchQuery = val)),
          const SizedBox(height: 25),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('loans').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No requests found"));

              final loans = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final title = (data['bookTitle'] ?? '').toLowerCase();
                final id = (data['borrowerId'] ?? '').toLowerCase();
                return title.contains(_searchQuery.toLowerCase()) || id.contains(_searchQuery.toLowerCase());
              }).toList();

              return Column(
                children: loans.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status = data['status'] ?? 'PENDING';
                  return _buildLoanCard(doc.id, data, status);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. Books Tab
  // ==========================================
  Widget _buildBooksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Manage Books", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showBookDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Add Book"),
                style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchBar(onChanged: (val) => setState(() => _searchQuery = val)),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('books').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData) return const Center(child: Text("No books found"));

              final books = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['title'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index].data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(book['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${book['author'] ?? 'Unknown'} • ${book['category'] ?? 'General'}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDocument('books', books[index].id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. Announcements Tab
  // ==========================================
  Widget _buildAnnouncementsTab() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Announcements", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: "Announcement Title", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: "Message", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                        _firestore.collection('announcements').add({
                          'title': titleCtrl.text,
                          'content': contentCtrl.text,
                          // ✅ التعديل: استخدام timestamp لضمان الترتيب الصحيح
                          'timestamp': FieldValue.serverTimestamp(), 
                        });
                        titleCtrl.clear();
                        contentCtrl.clear();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Announcement Posted')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                    child: const Text("Post Announcement", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("Recent Announcements", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('announcements')
                // ✅ التعديل: الترتيب بناءً على الـ timestamp
                .orderBy('timestamp', descending: true) 
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) return const SizedBox();
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final announce = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  // استخراج التاريخ بشكل آمن
                  String dateStr = 'Just now';
                  if (announce['timestamp'] != null) {
                    final date = (announce['timestamp'] as Timestamp).toDate();
                    dateStr = '${date.day}/${date.month}/${date.year}';
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(announce['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(announce['content'] ?? ''),
                          const SizedBox(height: 5),
                          Text(dateStr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteDocument('announcements', snapshot.data!.docs[index].id),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  // ==========================================
  // 4. Profile Tab
  // ==========================================
  Widget _buildProfileTab() {
    TextEditingController nameCtrl = TextEditingController(text: "Admin Librarian");
    TextEditingController emailCtrl = TextEditingController(text: "librarian@hu.edu.jo");
    TextEditingController branchCtrl = TextEditingController(text: "Main Library");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 50, backgroundColor: Colors.black, child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 20),
          const Text("Librarian Profile", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
                  const SizedBox(height: 15),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
                  const SizedBox(height: 15),
                  TextField(controller: branchCtrl, decoration: const InputDecoration(labelText: "Library Branch", border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on))),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated'), backgroundColor: Colors.green)),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                      child: const Text("Update Info", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout, color: Color(0xFF8B0000)),
              label: const Text('Sign Out', style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.bold, fontSize: 16)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFF8B0000), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================
  // Helpers
  // ==========================================
  Widget _buildSearchBar({required Function(String) onChanged}) {
    return TextField(
      controller: _searchController,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Search...",
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildLoanCard(String docId, Map<String, dynamic> data, String status) {
    final title = data['bookTitle'] ?? 'Unknown';
    final id = data['borrowerId'] ?? '---';
    
    // ✅ تعديل استخراج التاريخ ليتعامل مع الحقول المختلفة بأمان
    String dateStr = '---';
    if (data['createdAt'] != null) {
      dateStr = (data['createdAt'] as Timestamp).toDate().toString().substring(0, 10);
    } else if (data['borrowDate'] != null) {
      dateStr = (data['borrowDate'] as Timestamp).toDate().toString().substring(0, 10);
    }

    Color chipColor;
    if (status == 'CONFIRMED') {
      chipColor = primaryRed.withOpacity(0.1);
    } else if (status == 'REJECTED') {
      chipColor = Colors.grey.shade300;
    } else {
      chipColor = Colors.orange.shade100;
    }

    Color textColor = status == 'CONFIRMED' ? primaryRed : Colors.black54;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                Chip(
                  label: Text(status, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                  backgroundColor: chipColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Student ID: $id", style: const TextStyle(color: Colors.grey)),
            Text("Borrowed on: $dateStr", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            if (status == 'PENDING')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateStatus(docId, 'CONFIRMED'),
                      style: OutlinedButton.styleFrom(side: BorderSide(color: primaryRed), backgroundColor: primaryRed.withOpacity(0.05)),
                      child: Text("Approve", style: TextStyle(color: primaryRed)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateStatus(docId, 'REJECTED'),
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade400)),
                      child: const Text("Reject", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(String docId, String newStatus) async {
    await _firestore.collection('loans').doc(docId).update({'status': newStatus});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request $newStatus')));
  }

  Future<void> _deleteDocument(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted')));
  }

  void _showBookDialog() {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Book"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: "Title"), controller: titleCtrl),
            TextField(decoration: const InputDecoration(labelText: "Author"), controller: authorCtrl),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                _firestore.collection('books').add({
                  'title': titleCtrl.text,
                  'author': authorCtrl.text,
                  'category': 'General'
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}