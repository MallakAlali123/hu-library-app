import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'add_resource_screen.dart'; // تأكد من وجود الملف

class BookSuggestionsScreen extends StatelessWidget {
  const BookSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5, // ظل خفيف جداً للفصل
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "The Academic Curator",
          style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => context.push('/admin/settings'),
          ),
          GestureDetector(
            onTap: () => context.push('/admin/settings'),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Color(0xFF001529),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Book Suggestions",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            // الزر العريض كما في صورتك
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddResourceScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("New Entry", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            // إضافة البطاقات هنا لكي لا تظل الشاشة فارغة
            _buildSuggestionCard(
              title: "Advanced Quantum Mechanics",
              author: "J. J. Sakurai",
              student: "Ahmed Al-Fayez",
              status: "PENDING",
            ),
            _buildSuggestionCard(
              title: "Digital Signal Processing",
              author: "Alan V. Oppenheim",
              student: "Sara Khalil",
              status: "REVIEWED",
              isReviewed: true,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // دالة بناء بطاقة الكتاب
  Widget _buildSuggestionCard({
    required String title,
    required String author,
    required String student,
    required String status,
    bool isReviewed = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isReviewed ? Colors.blue[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(status, style: TextStyle(color: isReviewed ? Colors.blue : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("by $author", style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const Divider(height: 25),
          Row(
            children: [
              const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 12)),
              const SizedBox(width: 8),
              Text(student, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              if (!isReviewed) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                    child: const Text("Mark Reviewed", style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0000)),
                  child: const Text("Add to Library", style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}