import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  final List<_ServiceItem> _services = const [
    _ServiceItem(
      title: 'Book Suggestion',
      icon: Icons.lightbulb_outline_rounded,
      imageAsset: 'assets/images/book_suggestion.png',
    ),
    _ServiceItem(
      title: 'Donate a book',
      icon: Icons.card_giftcard_rounded,
      imageAsset: 'assets/images/donate_book.png',
    ),
    _ServiceItem(
      title: 'Reserved Requests',
      icon: Icons.bookmark_border_rounded,
      imageAsset: 'assets/images/reserved.png',
    ),
    _ServiceItem(
      title: 'Hall Reservation',
      icon: Icons.meeting_room_outlined,
      imageAsset: 'assets/images/hall.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Library Services',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: Color(0xFF1A1A1A)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8E8E8)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search title, author, or ISBN...',
                  hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: Color(0xFFAAAAAA)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Services & Requests',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCC3333),
                    ),
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
                    if (service.title == 'Donate a book') {
                      context.go('/donate');
                    } else if (service.title == 'Hall Reservation') {
                      context.go('/hall');
                    } else if (service.title == 'Book Suggestion') {
                      context.go('/book-suggestion');
                    } else if (service.title == 'Reserved Requests') {
                      context.go('/my-requests');
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
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
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need help?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Chat with our librarian available 24/7',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      // ✅ التعديل هنا
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);

          if (index == 0) {
            context.go('/search');
          } else if (index == 1) {
            context.go('/my-requests');
          } else if (index == 2) {
            context.go('/my-books');
          } else if (index == 3) {
            context.go('/profile');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFCC3333),
        unselectedItemColor: const Color(0xFFAAAAAA),
        selectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'SEARCH'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: 'REQUESTS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'MY BOOKS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: 'PROFILE'),
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
                        fontWeight: FontWeight.w600,
                      ),
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

  const _ServiceItem({
    required this.title,
    required this.icon,
    required this.imageAsset,
  });
}