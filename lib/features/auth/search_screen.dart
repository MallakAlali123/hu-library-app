import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ إضافة استيراد شاشة التفاصيل
import 'book_details_screen.dart';

class SearchBooksScreen extends StatefulWidget {
  const SearchBooksScreen({super.key});

  @override
  State<SearchBooksScreen> createState() => _SearchBooksScreenState();
}

class _SearchBooksScreenState extends State<SearchBooksScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? selectedCategory = 'All';
  String? selectedAuthor = 'All';
  String? selectedYear = 'All';

  final List<String> categories = [
    'All',
    'Novels',
    'Science',
    'History',
    'Technology',
  ];

  final List<String> authors = [
    'All',
    'Ahmed Khaled',
    'Naguib Mahfouz',
    'Ibrahim Al-Feki',
    'Thomas H. Cormen',
  ];

  final List<String> years = [
    'All',
    '2023',
    '2022',
    '2021',
    '2020',
    '2009',
  ];

  @override
  void dispose() {
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
        centerTitle: true,
        title: const Text(
          'Search Books',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search for a book name...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFD32F2F),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildDropdown(
                  label: 'Category',
                  value: selectedCategory,
                  items: categories,
                  icon: Icons.category,
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                ),

                const SizedBox(height: 10),

                _buildDropdown(
                  label: 'Author',
                  value: selectedAuthor,
                  items: authors,
                  icon: Icons.person,
                  onChanged: (val) {
                    setState(() {
                      selectedAuthor = val;
                    });
                  },
                ),

                const SizedBox(height: 10),

                _buildDropdown(
                  label: 'Year',
                  value: selectedYear,
                  items: years,
                  icon: Icons.calendar_today,
                  onChanged: (val) {
                    setState(() {
                      selectedYear = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('search_books')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No books available"));
                }

                final allBooks = snapshot.data!.docs;
                final searchQuery = _searchController.text.trim().toLowerCase();

                final filteredBooks = allBooks.where((doc) {
                  final book = doc.data() as Map<String, dynamic>;

                  final title = (book['Title'] ?? '').toString().toLowerCase();
                  final matchesSearch = title.contains(searchQuery);

                  bool matchesCategory = true;
                  if (selectedCategory != null && selectedCategory != 'All') {
                    matchesCategory = (book['Category'] ?? '').toString() == selectedCategory;
                  }

                  bool matchesAuthor = true;
                  if (selectedAuthor != null && selectedAuthor != 'All') {
                    matchesAuthor = (book['Author'] ?? '').toString() == selectedAuthor;
                  }

                  bool matchesYear = true;
                  if (selectedYear != null && selectedYear != 'All') {
                    matchesYear = (book['Year'] ?? '').toString() == selectedYear;
                  }

                  return matchesSearch && matchesCategory && matchesAuthor && matchesYear;
                }).toList();

                if (filteredBooks.isEmpty) {
                  return const Center(child: Text("No matching books found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: const Icon(Icons.book, color: Color(0xFFD32F2F)),
                        title: Text(
                          book['Title'] ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${book['Author'] ?? 'Unknown'} • ${book['Year'] ?? ''}",
                        ),
                        // ✅ التعديل هنا: إضافة خاصية الضغط للانتقال لشاشة التفاصيل
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailsScreen(bookData: book),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value ?? 'All',
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
