import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/student'),
        ),
        title: Text('My Requests'.tr(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFCC3333),
          labelColor: const Color(0xFFCC3333),
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'All'.tr()),
            Tab(text: 'Pending'.tr()),
            Tab(text: 'Done'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestsList(filter: 'all'),
          _buildRequestsList(filter: 'PENDING'),
          _buildRequestsList(filter: 'done'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/student');
          if (index == 1) context.go('/my-requests');
          if (index == 2) context.go('/my-books');
          if (index == 3) context.go('/profile');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: const Color(0xFFCC3333),
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: 'HOME'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.assignment_outlined), label: 'REQUESTS'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book_rounded), label: 'MY BOOKS'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.person_rounded), label: 'PROFILE'.tr()),
        ],
      ),
    );
  }

  Widget _buildRequestsList({required String filter}) {
    if (user == null) {
      return Center(child: Text('Please login first'.tr()));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('requests_group')
          .where('userId', isEqualTo: user!.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFCC3333)));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        List<Map<String, dynamic>> allRequests = [];

        for (final doc in snapshot.data!.docs) {
          // ✅ التعديل: تحويل صريح (cast) للنوع Map<String, dynamic>
          // لأن doc.data() يرجّع Object? من QuerySnapshot غير المحدد generic
          final data = doc.data() as Map<String, dynamic>?;
          final collectionName = doc.reference.parent.id;

          allRequests.add({
            'id': doc.id,
            'collection': collectionName,
            'label': _getLabelForCollection(collectionName),
            'icon': _getIconForCollection(collectionName),
            'title': data?['title'] ?? data?['bookTitle'] ?? 'Request',
            'status': data?['status'] ?? 'PENDING',
            'createdAt': (data?['createdAt'] as Timestamp?)?.toDate(),
          });
        }

        var requests = allRequests;
        if (filter == 'PENDING') {
          requests = requests.where((r) => r['status'] == 'PENDING').toList();
        } else if (filter == 'done') {
          requests = requests.where((r) => r['status'] != 'PENDING').toList();
        }

        if (requests.isEmpty) return _buildEmptyState();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildRequestCard(requests[index]);
          },
        );
      },
    );
  }

  String _getLabelForCollection(String name) {
    switch (name) {
      case 'suggestions': return 'Book Suggestion';
      case 'donations': return 'Book Donation';
      case 'hall_reservations': return 'Hall Reservation';
      case 'book_purchases': return 'Book Purchase';
      case 'thesis_inquiries': return 'Thesis Inquiry';
      case 'loans': return 'Book Loan';
      default: return name;
    }
  }

  IconData _getIconForCollection(String name) {
    switch (name) {
      case 'suggestions': return Icons.lightbulb_outline_rounded;
      case 'donations': return Icons.card_giftcard_outlined;
      case 'hall_reservations': return Icons.meeting_room_outlined;
      case 'book_purchases': return Icons.shopping_bag_outlined;
      case 'thesis_inquiries': return Icons.find_in_page_outlined;
      case 'loans': return Icons.bookmark_border_rounded;
      default: return Icons.description_outlined;
    }
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final status = request['status'] as String;
    final icon = request['icon'] as IconData;
    final label = request['label'] as String;
    final title = request['title'] as String;
    final createdAt = request['createdAt'] as DateTime?;

    Color statusColor;
    Color statusTextColor;
    IconData statusIcon;

    switch (status) {
      case 'CONFIRMED':
      case 'ADDED':
      case 'APPROVED':
        statusColor = Colors.green.withOpacity(0.1);
        statusTextColor = Colors.green;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case 'REJECTED':
        statusColor = Colors.red.withOpacity(0.1);
        statusTextColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      case 'REVIEWED':
        statusColor = Colors.blue.withOpacity(0.1);
        statusTextColor = Colors.blue;
        statusIcon = Icons.visibility_outlined;
        break;
      default:
        statusColor = Colors.orange.withOpacity(0.1);
        statusTextColor = Colors.orange;
        statusIcon = Icons.hourglass_empty_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 0.8),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: const Color(0xFFCC3333).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFFCC3333), size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFCC3333).withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
              child: Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFFCC3333), fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 4),
            if (createdAt != null)
              Text('${createdAt.day}/${createdAt.month}/${createdAt.year}', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(statusIcon, size: 12, color: statusTextColor),
            const SizedBox(width: 4),
            Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusTextColor)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color(0xFFCC3333).withOpacity(0.08), shape: BoxShape.circle), child: const Icon(Icons.assignment_outlined, color: Color(0xFFCC3333), size: 40)),
        const SizedBox(height: 16),
        Text('No Requests Yet'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        Text('Your submitted requests will appear here'.tr(), style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => context.go('/student'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC3333), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
          child: Text('Browse Services'.tr()),
        ),
      ]),
    );
  }
}