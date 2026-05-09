import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

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

  // ✅ كل الخدمات بقائمة وحدة
  final List<_ServiceItem> _allServices = [
    _ServiceItem(
      title: 'Arabic Book Purchase',
      icon: Icons.menu_book_rounded,
      imageAsset: 'assets/images/arabic_book_purchase.png',
      route: '/arabic-book-purchase',
    ),
    _ServiceItem(
      title: 'Foreign Book Purchase',
      icon: Icons.public_rounded,
      imageAsset: 'assets/images/foreign_book_purchase.png',
      route: '/foreign-book-purchase',
    ),
    _ServiceItem(
      title: 'Book Suggestion',
      icon: Icons.lightbulb_outline_rounded,
      imageAsset: 'assets/images/book_suggestion.png',
      route: '/book-suggestion',
    ),
    _ServiceItem(
      title: 'Donate a Book',
      icon: Icons.card_giftcard_outlined,
      imageAsset: 'assets/images/donate_book.png',
      route: '/donate',
    ),
    _ServiceItem(
      title: 'Reserved Requests',
      icon: Icons.bookmark_border_rounded,
      imageAsset: 'assets/images/reserved.png',
      route: '/my-requests',
    ),
    _ServiceItem(
      title: 'Hall Reservation',
      icon: Icons.meeting_room_outlined,
      imageAsset: 'assets/images/hall.png',
      route: '/hall',
    ),
    _ServiceItem(
      title: 'Book or Thesis Inquiry',
      icon: Icons.find_in_page_outlined,
      imageAsset: 'assets/images/thesis_inquiry.png',
      route: '/thesis-inquiry',
    ),
    _ServiceItem(
      title: 'Newly Added Books',
      icon: Icons.auto_stories_outlined,
      imageAsset: 'assets/images/new_books.png',
      route: '/new-books',
    ),
    _ServiceItem(
      title: 'Announcements',
      icon: Icons.campaign_outlined,
      imageAsset: 'assets/images/announcements.png',
      route: '/announcements',
    ),
    _ServiceItem(
      title: 'Librarian Info',
      icon: Icons.person_outline_rounded,
      imageAsset: 'assets/images/librarian.png',
      route: '/librarian-info',
    ),
    _ServiceItem(
      title: 'Chatbot',
      icon: Icons.smart_toy_outlined,
      imageAsset: 'assets/images/chatbot.png',
      route: '/chatbot',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Library Services'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => context.push('/notifications'),
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
              onTap: () => context.push('/search'),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Search title, author, or ISBN...'.tr(),
                    hintStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ✅ قسم واحد فقط — Services & Requests
            _buildSectionHeader(context, 'Services & Requests'.tr()),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allServices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final service = _allServices[index];
                return _ServiceCard(
                  service: service,
                  onTap: () => context.push(service.route),
                );
              },
            ),

            const SizedBox(height: 20),

            // قسم المساعدة
            GestureDetector(
              onTap: () => context.push('/chatbot'),
              child: Container(
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
                      child: const Icon(Icons.help_outline_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need help?'.tr(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSurface),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Chat with our librarian available 24/7'.tr(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.3),
                    ),
                  ],
                ),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'View All'.tr(),
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFCC3333)),
          ),
        ),
      ],
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
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
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
  final String route;

  const _ServiceItem({
    required this.title,
    required this.icon,
    required this.imageAsset,
    required this.route,
  });
}