import 'package:flutter/material.dart';

class SearchBooksScreen extends StatefulWidget {
  const SearchBooksScreen({super.key});

  @override
  State<SearchBooksScreen> createState() => _SearchBooksScreenState();
}

class _SearchBooksScreenState extends State<SearchBooksScreen> {
  // Variables to control filter states
  String? selectedCategory;
  String? selectedAuthor;
  String? selectedYear;

  // Dummy data for filters (Changed labels to English)
  final List<String> categories = ['All', 'Novels', 'Science', 'History', 'Technology'];
  final List<String> authors = ['All', 'Ahmed Khaled', 'Naguib Mahfouz', 'Ibrahim Al-Feki'];
  final List<String> years = ['All', '2023', '2022', '2021', '2020'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Search Books', // English Title
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Search Bar Section ---
            Container(
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
                decoration: InputDecoration(
                  hintText: 'Search for a book name...', // English Hint
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFD32F2F)), // Red Icon
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      // Clear search logic
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            // --- Filters Section ---
            const Text(
              'Search Filters', // English Section Title
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: [
                  // Category Filter
                  _buildFilterDropdown(
                    label: 'Category',
                    value: selectedCategory,
                    items: categories,
                    icon: Icons.category,
                    onChanged: (val) => setState(() => selectedCategory = val),
                  ),
                  const SizedBox(height: 15),

                  // Author Filter
                  _buildFilterDropdown(
                    label: 'Author',
                    value: selectedAuthor,
                    items: authors,
                    icon: Icons.person,
                    onChanged: (val) => setState(() => selectedAuthor = val),
                  ),
                  const SizedBox(height: 15),

                  // Year Filter
                  _buildFilterDropdown(
                    label: 'Publish Year',
                    value: selectedYear,
                    items: years,
                    icon: Icons.calendar_today,
                    onChanged: (val) => setState(() => selectedYear = val),
                  ),
                ],
              ),
            ),

            // --- Search Button ---
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Execute search logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Searching...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F), // Red Color (Same as before)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Search', // English Button Text
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build Dropdowns (English labels)
  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          items: items.map((String item) {
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