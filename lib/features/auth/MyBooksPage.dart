import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
        title: Text('My Books'.tr(),
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
            Tab(text: 'All Books'.tr()),
            Tab(text: 'My Borrowed'.tr()),
          ],
        ),
      ),
      body: Column(children: [
        // شريط البحث
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search books...'.tr(),
                hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4)),
                prefixIcon: Icon(Icons.search_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllBooksTab(),
              _buildMyBorrowedTab(),
            ],
          ),
        ),
      ]),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go('/student');
          if (index == 1) context.go('/my-requests');
          if (index == 2) context.go('/my-books');
          if (index == 3) context.go('/profile');
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

  // ── تاب كل الكتب من كولكشن books ──────────────────────────────
  Widget _buildAllBooksTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFCC3333)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('No books available'.tr(),
              Icons.menu_book_rounded);
        }

        var books = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final title = (data['title'] ?? '').toLowerCase();
          final author = (data['author'] ?? '').toLowerCase();
          return title.contains(_searchQuery.toLowerCase()) ||
              author.contains(_searchQuery.toLowerCase());
        }).toList();

        if (books.isEmpty) {
          return _buildEmptyState('No results found'.tr(), Icons.search_off_rounded);
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final data = books[index].data() as Map<String, dynamic>;
            return _buildBookCard(
              title: data['title'] ?? 'No Title',
              author: data['author'] ?? 'Unknown',
              category: data['category'] ?? 'General',
              status: 'AVAILABLE',
            );
          },
        );
      },
    );
  }

  // ── تاب الكتب المستعارة من كولكشن loans ───────────────────────
  Widget _buildMyBorrowedTab() {
    if (user == null) {
      return _buildEmptyState('Please login first'.tr(), Icons.lock_outline_rounded);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('loans')
          .where('borrowerId', isEqualTo: user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFCC3333)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
              'You have no borrowed books'.tr(), Icons.bookmark_border_rounded);
        }

        final loans = snapshot.data!.docs;

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: loans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = loans[index].data() as Map<String, dynamic>;
            final status = data['status'] ?? 'PENDING';
            final borrowDate = (data['borrowDate'] as Timestamp?)?.toDate();
            final dueDate = (data['dueDate'] as Timestamp?)?.toDate();

            return _buildLoanCard(
              title: data['bookTitle'] ?? 'Unknown Book',
              author: data['bookAuthor'] ?? '',
              category: data['bookCategory'] ?? 'General',
              status: status,
              borrowDate: borrowDate,
              dueDate: dueDate,
            );
          },
        );
      },
    );
  }

  // ── Book Card (Grid) ───────────────────────────────────────────
  Widget _buildBookCard({
    required String title,
    required String author,
    required String category,
    required String status,
  }) {
    final colors = _getCategoryColor(category);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant, width: 0.8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // غلاف الكتاب
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          child: Container(
            height: 130,
            width: double.infinity,
            color: colors['bg'],
            child: Stack(children: [
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_rounded,
                          size: 52, color: colors['icon']),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: colors['text']),
                        ),
                      ),
                    ]),
              ),
            ]),
          ),
        ),

        // معلومات الكتاب
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 2),
            Text(author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: const Color(0xFFCC3333).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(category,
                  style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFFCC3333),
                      fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      ]),
    );
  }

  // ── Loan Card (List) ───────────────────────────────────────────
  Widget _buildLoanCard({
    required String title,
    required String author,
    required String category,
    required String status,
    DateTime? borrowDate,
    DateTime? dueDate,
  }) {
    Color statusColor;
    Color statusTextColor;
    IconData statusIcon;

    switch (status) {
      case 'CONFIRMED':
        statusColor = Colors.green.withOpacity(0.1);
        statusTextColor = Colors.green;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case 'RETURNED':
        statusColor = Colors.blue.withOpacity(0.1);
        statusTextColor = Colors.blue;
        statusIcon = Icons.assignment_return_outlined;
        break;
      case 'OVERDUE':
        statusColor = Colors.red.withOpacity(0.1);
        statusTextColor = Colors.red;
        statusIcon = Icons.warning_amber_rounded;
        break;
      default:
        statusColor = Colors.orange.withOpacity(0.1);
        statusTextColor = Colors.orange;
        statusIcon = Icons.hourglass_empty_rounded;
    }

    final colors = _getCategoryColor(category);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant, width: 0.8),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // أيقونة الكتاب
        Container(
          width: 52, height: 64,
          decoration: BoxDecoration(
              color: colors['bg'],
              borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.menu_book_rounded,
              color: colors['icon'], size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 2),
            Text(author,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            const SizedBox(height: 6),
            if (borrowDate != null)
              _infoRow(Icons.calendar_today_outlined,
                  'Borrowed: ${borrowDate.day}/${borrowDate.month}/${borrowDate.year}'),
            if (dueDate != null)
              _infoRow(Icons.event_outlined,
                  'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: statusColor, borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(statusIcon, size: 12, color: statusTextColor),
            const SizedBox(width: 4),
            Text(status,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusTextColor)),
          ]),
        ),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(children: [
        Icon(icon,
            size: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
        const SizedBox(width: 4),
        Text(text,
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.5))),
      ]),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
              color: const Color(0xFFCC3333).withOpacity(0.08),
              shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFFCC3333), size: 40),
        ),
        const SizedBox(height: 16),
        Text(message,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        Text('Browse the library collection'.tr(),
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.5))),
      ]),
    );
  }

  // ── ألوان الكتاب حسب الـ category ─────────────────────────────
  Map<String, dynamic> _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'literature':
        return {'bg': const Color.fromARGB(255, 224, 14, 14).withOpacity(0.15),
                'icon': const Color.fromARGB(255, 224, 14, 14), 'text': const Color.fromARGB(255, 224, 14, 14)};
      case 'technology':
      case 'computer science':
        return {'bg': const Color.fromARGB(255, 224, 14, 14).withOpacity(0.15),
                'icon': const Color.fromARGB(255, 224, 14, 14), 'text': const Color.fromARGB(255, 224, 14, 14)};
      case 'history':
        return {'bg': const Color.fromARGB(255, 224, 14, 14).withOpacity(0.15),
                'icon': const Color.fromARGB(255, 224, 14, 14), 'text': const Color.fromARGB(255, 224, 14, 14)};
      case 'mathematics':
        return {'bg': const Color.fromARGB(255, 224, 14, 14).withOpacity(0.15),
                'icon': const Color.fromARGB(255, 224, 14, 14), 'text': const Color.fromARGB(255, 224, 14, 14)};
      case 'business':
        return {'bg': const Color.fromARGB(255, 224, 14, 14).withOpacity(0.15),
                'icon': const Color.fromARGB(255, 224, 14, 14), 'text': const Color.fromARGB(255, 224, 14, 14)};
      default:
        return {'bg': const Color(0xFFCC3333).withOpacity(0.12),
                'icon': const Color(0xFFCC3333),
                'text': const Color(0xFFCC3333)};
    }
  }
}