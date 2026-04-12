import 'package:flutter/material.dart';

// ── Saved Books Manager (Singleton) ──────────────────────────────────────────
class SavedBooksManager {
  static final SavedBooksManager _instance = SavedBooksManager._internal();
  factory SavedBooksManager() => _instance;
  SavedBooksManager._internal();

  final List<SavedBook> savedBooks = [];

  void toggleBook(SavedBook book) {
    final exists = savedBooks.any((b) => b.title == book.title);
    if (exists) {
      savedBooks.removeWhere((b) => b.title == book.title);
    } else {
      savedBooks.add(book);
    }
  }

  bool isSaved(String title) {
    return savedBooks.any((b) => b.title == title);
  }
}

class SavedBook {
  final String title;
  final String author;
  final String category;
  final String status;
  final Color color;

  SavedBook({
    required this.title,
    required this.author,
    required this.category,
    required this.status,
    required this.color,
  });
}

// ── Saved Screen ──────────────────────────────────────────────────────────────
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final _manager = SavedBooksManager();

  @override
  Widget build(BuildContext context) {
    final books = _manager.savedBooks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1A1A)),
          ),
        ),
        title: const Text(
          'Saved Books',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: books.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded, size: 64, color: Color(0xFFCCCCCC)),
                  SizedBox(height: 12),
                  Text(
                    'No saved books yet',
                    style: TextStyle(fontSize: 16, color: Color(0xFF888888)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tap the bookmark icon on any book to save it',
                    style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
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
                        width: 60,
                        height: 80,
                        decoration: BoxDecoration(
                          color: book.color,
                          borderRadius: BorderRadius.circular(6),
                        ),
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
                                  child: Text(
                                    book.title,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _manager.savedBooks.removeAt(index));
                                    },
                                    child: const Icon(Icons.bookmark_rounded, color: Color(0xFFCC3333), size: 20),
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFEEEE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isAvailable ? 'AVAILABLE' : 'RESERVED',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable ? const Color(0xFF2E7D32) : const Color(0xFFCC3333),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}