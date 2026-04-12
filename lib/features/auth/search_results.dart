import 'package:flutter/material.dart';
import 'saved_screen.dart';
import 'home_page.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _selectedFilter = 'ALL';
  int _currentIndex = 0;
  final _manager = SavedBooksManager();

  final List<String> _filters = ['ALL', 'AVAILABLE', 'RESERVED', 'ENG'];

  final List<_BookItem> _allBooks = const [
    _BookItem(title: 'Clean Architecture', author: 'Robert C. Martin', category: 'ENGINEERING', status: 'AVAILABLE', color: Color(0xFF8B2222)),
    _BookItem(title: 'Algorithms', author: 'Thomas H. Cormen', category: 'MATHEMATICS', status: 'RESERVED', color: Color(0xFF5F5E5A)),
    _BookItem(title: 'Data Structures', author: 'Michael T. Goodrich', category: 'ENGINEERING', status: 'AVAILABLE', color: Color(0xFFCC3333)),
  ];

  List<_BookItem> get _filteredBooks {
    if (_selectedFilter == 'ALL') return _allBooks;
    if (_selectedFilter == 'AVAILABLE') return _allBooks.where((b) => b.status == 'AVAILABLE').toList();
    if (_selectedFilter == 'RESERVED') return _allBooks.where((b) => b.status == 'RESERVED').toList();
    if (_selectedFilter == 'ENG') return _allBooks.where((b) => b.category == 'ENGINEERING').toList();
    return _allBooks;
  }

  @override
  Widget build(BuildContext context) {
    final books = _filteredBooks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [

            // ── Filters ───────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = filter == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFCC3333) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? const Color(0xFFCC3333) : const Color(0xFFE0E0E0)),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Body ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Header ────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Search Results', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                        Text('${books.length} ITEMS FOUND', style: const TextStyle(fontSize: 11, color: Color(0xFF888888), fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Book List ─────────────────────────────
                    ...books.map((book) => _BookCard(
                      book: book,
                      isSaved: _manager.isSaved(book.title),
                      onBookmarkTap: () {
                        setState(() {
                          _manager.toggleBook(SavedBook(
                            title: book.title,
                            author: book.author,
                            category: book.category,
                            status: book.status,
                            color: book.color,
                          ));
                        });
                        final isSaved = _manager.isSaved(book.title);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isSaved ? '${book.title} saved!' : '${book.title} removed from saved'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    )),

                    const SizedBox(height: 24),

                    // ── No Results Section ────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEEEEEE)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.inbox_outlined, size: 52, color: Color(0xFFCCCCCC)),
                          const SizedBox(height: 12),
                          const Text('No results found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                          const SizedBox(height: 6),
                          const Text(
                            'Try searching for a different\nkeyword or checking your filters.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Color(0xFF888888), height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedFilter = 'ALL'),
                              child: const Text('CLEAR ALL FILTERS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFCC3333), letterSpacing: 0.5)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LibraryServicesPage()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedScreen()));
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFCC3333),
        unselectedItemColor: const Color(0xFFAAAAAA),
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded), label: 'Bookmarks'),
        ],
      ),
    );
  }
}

// ── Book Card ─────────────────────────────────────────────────────────────────

class _BookCard extends StatelessWidget {
  final _BookItem book;
  final bool isSaved;
  final VoidCallback onBookmarkTap;

  const _BookCard({required this.book, required this.isSaved, required this.onBookmarkTap});

  @override
  Widget build(BuildContext context) {
    final isAvailable = book.status == 'AVAILABLE';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60, height: 80,
            decoration: BoxDecoration(color: book.color, borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(book.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onBookmarkTap,
                        child: Icon(
                          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isSaved ? const Color(0xFFCC3333) : const Color(0xFFAAAAAA),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(book.author, style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(4)),
                  child: Text(book.category, style: const TextStyle(fontSize: 10, color: Color(0xFF666666), fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isAvailable ? 'AVAILABLE' : 'RESERVED',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAvailable ? const Color(0xFF2E7D32) : const Color(0xFFCC3333)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isAvailable)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCC3333), foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), elevation: 0,
                        ),
                        child: const Text('View Details', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      )
                    else
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF888888),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Notify Me', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookItem {
  final String title;
  final String author;
  final String category;
  final String status;
  final Color color;

  const _BookItem({required this.title, required this.author, required this.category, required this.status, required this.color});
}