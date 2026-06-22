import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

// ============================================================
// ⚙️ إعدادات مصادر الطلبات — عدّل هون بس لو تغيّر شي
// ============================================================
class _Source {
  final String collection;
  final String userField;
  final String titleField;
  final String dateField;  // اسم حقل التاريخ (مختلف بين collections)
  final String label;
  final IconData icon;
  const _Source(this.collection, this.userField, this.titleField,
      this.dateField, this.label, this.icon);
}

const _sources = [
  // bookings → status: "Pending", التاريخ: timestamp
  _Source('bookings',       'userId', 'roomName',  'timestamp',  'Hall Booking',    Icons.meeting_room_outlined),
  // loans → status: "PENDING", التاريخ: createdAt  (عدّل لو اختلف)
  _Source('loans',          'userId', 'bookTitle', 'createdAt',  'Book Loan',       Icons.bookmark_border_rounded),
  // suggestions → عدّل الحقول لما تشوف مستند فعلي
  _Source('suggestions',    'userId', 'title',     'createdAt',  'Book Suggestion', Icons.lightbulb_outline_rounded),
  // book_purchases → studentId, title, createdAt (من Firestore)
  _Source('book_purchases', 'studentId', 'title', 'createdAt',  'Book Purchase',   Icons.shopping_bag_outlined),
  // أضف أي collection جديد هون
];
// ============================================================

// حالات "قيد الانتظار" — بيشمل كل الـ casings الممكنة
const _pendingStatuses = {'PENDING', 'Pending', 'pending'};

// حالات "منتهية" — بيشمل كل الـ casings الممكنة
const _doneStatuses = {
  'CONFIRMED', 'Confirmed', 'confirmed',
  'APPROVED',  'Approved',  'approved',
  'REJECTED',  'Rejected',  'rejected',
  'REVIEWED',  'Reviewed',  'reviewed',
  'ADDED',     'Added',     'added',
};

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _user = FirebaseAuth.instance.currentUser;

  final Map<String, List<Map<String, dynamic>>> _data = {};
  final List<StreamSubscription> _subs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _subscribeAll();
  }

  void _subscribeAll() {
    if (_user == null) {
      setState(() => _loading = false);
      return;
    }

    for (final src in _sources) {
      _data[src.collection] = [];

      final sub = FirebaseFirestore.instance
          .collection(src.collection)
          .where(src.userField, isEqualTo: _user!.uid)
          .snapshots()
          .listen(
        (snap) {
          _data[src.collection] = snap.docs.map((doc) {
            final d = doc.data();

            // يحاول يقرأ حقل التاريخ الخاص بهاد الـ collection أولاً
            // لو مش موجود يجرب الحقول الثانية كاحتياط
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
              'status':     d['status'] ?? 'Pending',
              'createdAt':  date,
            };
          }).toList();

          if (mounted) setState(() => _loading = false);
        },
        onError: (e) {
          debugPrint('⚠️ خطأ بـ ${src.collection}: $e');
          if (mounted) setState(() => _loading = false);
        },
      );

      _subs.add(sub);
    }
  }

  List<Map<String, dynamic>> _getFiltered(String filter) {
    final all = _data.values.expand((l) => l).toList()
      ..sort((a, b) {
        final da = a['createdAt'] as DateTime?;
        final db = b['createdAt'] as DateTime?;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });

    if (filter == 'PENDING') {
      return all.where((r) => _pendingStatuses.contains(r['status'])).toList();
    } else if (filter == 'done') {
      return all.where((r) => _doneStatuses.contains(r['status'])).toList();
    }
    return all;
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final s in _subs) s.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/student'),
        ),
        title: Text('My Requests'.tr(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFCC3333),
          labelColor: const Color(0xFFCC3333),
          unselectedLabelColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'All'.tr()),
            Tab(text: 'Pending'.tr()),
            Tab(text: 'Done'.tr()),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFCC3333)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList('all'),
                _buildList('PENDING'),
                _buildList('done'),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) context.go('/student');
          if (i == 1) context.go('/my-requests');
          if (i == 2) context.go('/my-books');
          if (i == 3) context.go('/profile');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: const Color(0xFFCC3333),
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined), label: 'HOME'.tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_outlined),
              label: 'REQUESTS'.tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_rounded),
              label: 'MY BOOKS'.tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded), label: 'PROFILE'.tr()),
        ],
      ),
    );
  }

  Widget _buildList(String filter) {
    if (_user == null) {
      return Center(child: Text('Please login first'.tr()));
    }

    final requests = _getFiltered(filter);
    if (requests.isEmpty) return _buildEmptyState();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildCard(requests[i]),
    );
  }

  Widget _buildCard(Map<String, dynamic> req) {
    final status    = req['status']    as String;
    final icon      = req['icon']      as IconData;
    final label     = req['label']     as String;
    final title     = req['title']     as String;
    final createdAt = req['createdAt'] as DateTime?;

    // يتعامل مع الـ status بغض النظر عن الـ casing
    final statusUpper = status.toUpperCase();

    Color chipBg, chipText;
    IconData chipIcon;

    if (['CONFIRMED', 'APPROVED', 'ADDED'].contains(statusUpper)) {
      chipBg   = Colors.green.withOpacity(0.1);
      chipText = Colors.green;
      chipIcon = Icons.check_circle_outline_rounded;
    } else if (statusUpper == 'REJECTED') {
      chipBg   = Colors.red.withOpacity(0.1);
      chipText = Colors.red;
      chipIcon = Icons.cancel_outlined;
    } else if (statusUpper == 'REVIEWED') {
      chipBg   = Colors.blue.withOpacity(0.1);
      chipText = Colors.blue;
      chipIcon = Icons.visibility_outlined;
    } else {
      // PENDING و أي حالة ثانية
      chipBg   = Colors.orange.withOpacity(0.1);
      chipText = Colors.orange;
      chipIcon = Icons.hourglass_empty_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant, width: 0.8),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
              color: const Color(0xFFCC3333).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFFCC3333), size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFCC3333).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFCC3333),
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 6),
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 4),
            if (createdAt != null)
              Text('${createdAt.day}/${createdAt.month}/${createdAt.year}',
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5))),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: chipBg, borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(chipIcon, size: 12, color: chipText),
            const SizedBox(width: 4),
            Text(status, // نعرض الـ status كما هو من Firestore
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: chipText)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
                color: const Color(0xFFCC3333).withOpacity(0.08),
                shape: BoxShape.circle),
            child: const Icon(Icons.assignment_outlined,
                color: Color(0xFFCC3333), size: 40)),
        const SizedBox(height: 16),
        Text('No Requests Yet'.tr(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        Text('Your submitted requests will appear here'.tr(),
            style: TextStyle(
                fontSize: 13,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => context.go('/student'),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCC3333),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0),
          child: Text('Browse Services'.tr()),
        ),
      ]),
    );
  }
}