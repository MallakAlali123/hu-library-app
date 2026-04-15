import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ إضافة الترجمة

class LibraryServicesPage extends StatefulWidget {
  const LibraryServicesPage({super.key});

  @override
  State<LibraryServicesPage> createState() => _LibraryServicesPageState();
}

class _LibraryServicesPageState extends State<LibraryServicesPage> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<_ServiceItem> _services = [
    _ServiceItem(
      title: 'Book Suggestion'.tr(),
      icon: Icons.lightbulb_outline_rounded,
      imageAsset: 'assets/images/book_suggestion.png',
    ),
    _ServiceItem(
      title: 'Donate a book'.tr(),
      icon: Icons.card_giftcard_outlined,
      imageAsset: 'assets/images/donate_book.png',
    ),
    _ServiceItem(
      title: 'Reserved Requests'.tr(),
      icon: Icons.bookmark_border_rounded,
      imageAsset: 'assets/images/reserved.png',
    ),
    _ServiceItem(
      title: 'Hall Reservation'.tr(),
      icon: Icons.meeting_room_outlined,
      imageAsset: 'assets/images/hall.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ استخدام لون من الثيم
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Library Services'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط البحث
            GestureDetector(
              onTap: () => context.go('/search'),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Search title, author, or ISBN...'.tr(),
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // رأس قسم الخدمات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Services & Requests'.tr(),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View All'.tr(),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFCC3333)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final service = _services[index];
                return _ServiceCard(
                  service: service,
                  onTap: () {
                    if (service.title.contains('Donate')) {
                      context.go('/donate');
                    } else if (service.title.contains('Hall')) {
                      context.go('/hall');
                    } else if (service.title.contains('Book Suggestion')) {
                      context.go('/book-suggestion');
                    } else {
                      // Reserved Requests
                      context.go('/my-requests');
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            // قسم المساعدة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCC3333),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.help_outline_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need help?'.tr(),
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Chat with our librarian available 24/7'.tr(),
                          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) context.go('/search');
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'REQUESTS'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'MY BOOKS'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'PROFILE'.tr()),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final _ServiceItem service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              service.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF8B2222),
                child: Icon(service.icon, size: 50, color: Colors.white),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  Icon(service.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      service.title,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final String title;
  final IconData icon;
  final String imageAsset;

  const _ServiceItem({required this.title, required this.icon, required this.imageAsset});
}