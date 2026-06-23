import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// ============================================================
// ⚙️ إعدادات مصادر الطلبات — نفس الـ sources بـ MyRequestsPage
// ============================================================
class _Source {
  final String collection;
  final String userField;
  final String titleField;
  final String dateField;
  final String label;
  final IconData icon;
  const _Source(this.collection, this.userField, this.titleField,
      this.dateField, this.label, this.icon);
}

const _sources = [
  _Source('loans',          'userId',    'bookTitle', 'createdAt', 'Book Loan',       Icons.bookmark_border_rounded),
  _Source('bookings',       'userId',    'roomName',  'timestamp', 'Hall Booking',    Icons.meeting_room_outlined),
  _Source('book_purchases', 'studentId', 'title',     'createdAt', 'Book Purchase',   Icons.shopping_bag_outlined),
  _Source('suggestions',    'userId',    'title',     'createdAt', 'Book Suggestion', Icons.lightbulb_outline_rounded),
];

class LibraryServicesPage extends StatefulWidget {
  const LibraryServicesPage({super.key});

  @override
  State<LibraryServicesPage> createState() => _LibraryServicesPageState();
}

class _LibraryServicesPageState extends State<LibraryServicesPage> {
  int _currentIndex = 0;

  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey     = const Color(0xFFF8F9FA);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth      _auth      = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  String _statusFilter = 'ALL';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out', style: TextStyle(color: Color(0xFF8B0000))),
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
                  style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 14)),
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
            _searchQuery  = "";
            _searchController.clear();
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book),            label: "Books"),
          BottomNavigationBarItem(icon: Icon(Icons.campaign),             label: "Announce"),
          BottomNavigationBarItem(icon: Icon(Icons.person),               label: "Profile"),
        ],
      ),
    );
  }

  // ==========================================
  // 1. Requests Tab
  // ==========================================
  Widget _buildRequestsTab() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("All Requests",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("Review and manage student requests.",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 16),
              _buildSearchBar(onChanged: (v) => setState(() => _searchQuery = v)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _filterChip('ALL',     'All'),
                  const SizedBox(width: 8),
                  _filterChip('PENDING', 'Pending'),
                  const SizedBox(width: 8),
                  _filterChip('DONE',    'Done'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _AllRequestsList(
            sources:      _sources,
            searchQuery:  _searchQuery,
            statusFilter: _statusFilter,
            primaryRed:   primaryRed,
            firestore:    _firestore,
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String value, String label) {
    final active = _statusFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _statusFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? primaryRed : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 12)),
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
              const Text("Manage Books",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _showBookDialog,
                icon: const Icon(Icons.add),
                label: const Text("Add Book"),
                style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchBar(onChanged: (v) => setState(() => _searchQuery = v)),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('books').snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData)
                return const Center(child: Text("No books found"));

              final books = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return (data['title'] ?? '')
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (ctx, i) {
                  final book = books[i].data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(book['title'] ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "${book['author'] ?? 'Unknown'} • ${book['category'] ?? 'General'}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDocument('books', books[i].id),
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
    final titleCtrl   = TextEditingController();
    final contentCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Announcements",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                      labelText: "Announcement Title",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: "Message", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty &&
                          contentCtrl.text.isNotEmpty) {
                        _firestore.collection('announcements').add({
                          'title':     titleCtrl.text,
                          'content':   contentCtrl.text,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        titleCtrl.clear();
                        contentCtrl.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Announcement Posted')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                    child: const Text("Post Announcement",
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("Recent Announcements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('announcements')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData) return const SizedBox();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, i) {
                  final a = snapshot.data!.docs[i].data() as Map<String, dynamic>;
                  String dateStr = 'Just now';
                  if (a['timestamp'] != null) {
                    final d = (a['timestamp'] as Timestamp).toDate();
                    dateStr = '${d.day}/${d.month}/${d.year}';
                  }
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(a['title'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['content'] ?? ''),
                          const SizedBox(height: 5),
                          Text(dateStr,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteDocument(
                            'announcements', snapshot.data!.docs[i].id),
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
  // 4. Profile Tab
  // ==========================================
  Widget _buildProfileTab() {
    final nameCtrl   = TextEditingController(text: "Admin Librarian");
    final emailCtrl  = TextEditingController(text: "librarian@hu.edu.jo");
    final branchCtrl = TextEditingController(text: "Main Library");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 20),
          const Text("Librarian Profile",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person))),
                  const SizedBox(height: 15),
                  TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email))),
                  const SizedBox(height: 15),
                  TextField(
                      controller: branchCtrl,
                      decoration: const InputDecoration(
                          labelText: "Library Branch",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on))),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                              content: Text('Profile Updated'),
                              backgroundColor: Colors.green)),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                      child: const Text("Update Info",
                          style: TextStyle(color: Colors.white)),
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
              label: const Text('Sign Out',
                  style: TextStyle(
                      color: Color(0xFF8B0000),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFF8B0000), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Future<void> _deleteDocument(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
    if (mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
  }

  void _showBookDialog() {
    final titleCtrl  = TextEditingController();
    final authorCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Book"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title")),
            TextField(
                controller: authorCtrl,
                decoration: const InputDecoration(labelText: "Author")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                _firestore.collection('books').add({
                  'title':    titleCtrl.text,
                  'author':   authorCtrl.text,
                  'category': 'General',
                });
                Navigator.pop(ctx);
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

// ============================================================
// Widget مستقل يجمع كل الطلبات من كل الـ Collections
// ============================================================
class _AllRequestsList extends StatefulWidget {
  final List<_Source> sources;
  final String        searchQuery;
  final String        statusFilter;
  final Color         primaryRed;
  final FirebaseFirestore firestore;

  const _AllRequestsList({
    required this.sources,
    required this.searchQuery,
    required this.statusFilter,
    required this.primaryRed,
    required this.firestore,
  });

  @override
  State<_AllRequestsList> createState() => _AllRequestsListState();
}

class _AllRequestsListState extends State<_AllRequestsList> {
  final Map<String, List<Map<String, dynamic>>> _data = {};
  final List<StreamSubscription> _subs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _subscribeAll();
  }

  void _subscribeAll() {
    for (final src in widget.sources) {
      _data[src.collection] = [];

      final sub = widget.firestore
          .collection(src.collection)
          .snapshots()
          .listen(
        (snap) {
          _data[src.collection] = snap.docs.map((doc) {
            final d = doc.data();

            DateTime? date;
            if (d[src.dateField] is Timestamp) {
              date = (d[src.dateField] as Timestamp).toDate();
            } else if (d['createdAt'] is Timestamp) {
              date = (d['createdAt'] as Timestamp).toDate();
            } else if (d['timestamp'] is Timestamp) {
              date = (d['timestamp'] as Timestamp).toDate();
            }

            return {
              'id':         doc.id,
              'collection': src.collection,
              'label':      src.label,
              'icon':       src.icon,
              'title':      d[src.titleField] ?? d['title'] ?? d['bookTitle'] ?? d['roomName'] ?? 'Request',
              'studentId':  d[src.userField]  ?? d['userId'] ?? d['studentId'] ?? '---',
              'status':     d['status'] ?? 'PENDING',
              'createdAt':  date,
            };
          }).toList();

          if (mounted) setState(() => _loading = false);
        },
        onError: (e) {
          debugPrint('⚠️ ${src.collection}: $e');
          if (mounted) setState(() => _loading = false);
        },
      );
      _subs.add(sub);
    }
  }

  @override
  void dispose() {
    for (final s in _subs) s.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    final all = _data.values.expand((l) => l).toList();

    return all.where((r) {
      final title  = (r['title']     as String).toLowerCase();
      final sid    = (r['studentId'] as String).toLowerCase();
      final q      = widget.searchQuery.toLowerCase();
      if (q.isNotEmpty && !title.contains(q) && !sid.contains(q)) return false;

      final statusUp = (r['status'] as String).toUpperCase();
      if (widget.statusFilter == 'PENDING') return statusUp == 'PENDING';
      if (widget.statusFilter == 'DONE')    return statusUp != 'PENDING';
      return true;
    }).toList()
      ..sort((a, b) {
        final da = a['createdAt'] as DateTime?;
        final db = b['createdAt'] as DateTime?;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
  }

  Future<void> _updateStatus(
      String collection, String docId, String newStatus) async {
    await widget.firestore
        .collection(collection)
        .doc(docId)
        .update({'status': newStatus});
    if (mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Request $newStatus')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF8B0000)));
    }

    final items = _filtered;

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text("No requests found",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _buildCard(items[i]),
    );
  }

  Widget _buildCard(Map<String, dynamic> req) {
    final status     = req['status']     as String;
    final icon       = req['icon']       as IconData;
    final label      = req['label']      as String;
    final title      = req['title']      as String;
    final studentId  = req['studentId']  as String;
    final collection = req['collection'] as String;
    final docId      = req['id']         as String;
    final createdAt  = req['createdAt']  as DateTime?;
    final statusUp   = status.toUpperCase();

    Color chipBg, chipText;
    IconData chipIcon;

    if (['CONFIRMED', 'APPROVED', 'ADDED'].contains(statusUp)) {
      chipBg   = Colors.green.shade50;
      chipText = Colors.green.shade700;
      chipIcon = Icons.check_circle_outline;
    } else if (statusUp == 'REJECTED') {
      chipBg   = Colors.grey.shade200;
      chipText = Colors.grey.shade700;
      chipIcon = Icons.cancel_outlined;
    } else {
      chipBg   = Colors.orange.shade50;
      chipText = Colors.orange.shade700;
      chipIcon = Icons.hourglass_empty_rounded;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Row: أيقونة + عنوان + شارة الحالة ───
            Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                      color: widget.primaryRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: widget.primaryRed, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 10,
                              color: widget.primaryRed,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis, // ✅ إصلاح overflow
                          maxLines: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // شارة الحالة
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(chipIcon, size: 12, color: chipText),
                      const SizedBox(width: 4),
                      Text(status,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: chipText)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // ─── معلومات الطالب والتاريخ ───  ✅ الإصلاح الرئيسي هنا
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(                                    // ✅ Expanded بدل Spacer
                  child: Text(
                    "Student: $studentId",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,         // ✅ قطع النص الطويل
                    maxLines: 1,
                  ),
                ),
                if (createdAt != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_today_outlined,
                      size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                      '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black54)),
                ],
              ],
            ),

            // ─── أزرار القبول/الرفض (بس لو PENDING) ───
            if (statusUp == 'PENDING') ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _updateStatus(collection, docId, 'CONFIRMED'),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _updateStatus(collection, docId, 'REJECTED'),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text("Reject"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}