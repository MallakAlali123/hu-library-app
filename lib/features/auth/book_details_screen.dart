import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookDetailsScreen({super.key, required this.bookData});

  // دالة حفظ الكتاب في قاعدة البيانات
  void _saveBook(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('saved_books') // الحفظ في Collection الرئيسية
          .add({
        'title': bookData['Title'] ?? '',
        'author': bookData['Author'] ?? '',
        'userId': user.uid, // ربط الكتاب بالمستخدم
        'savedAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Details',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة أو أيقونة الكتاب
              Center(
                child: Container(
                  height: 250,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.book, size: 100, color: Color(0xFFD32F2F)),
                ),
              ),
              const SizedBox(height: 30),

              // عنوان الكتاب
              Text(
                bookData['Title'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // المؤلف
              Center(
                child: Text(
                  'By: ${bookData['Author'] ?? 'Unknown Author'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Divider(height: 40, thickness: 1),

              // تفاصيل الكتاب
              _buildDetailRow(Icons.category, 'Category', bookData['Category'] ?? 'N/A'),
              const SizedBox(height: 15),
              _buildDetailRow(Icons.calendar_today, 'Year', bookData['Year']?.toString() ?? 'N/A'),
              const SizedBox(height: 30),

              // وصف وهمي (لأنه غير موجود في Firebase حالياً)
              const Text(
                'About this book:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'This is a comprehensive guide that provides in-depth knowledge on the subject. It covers various fundamental concepts and is highly recommended for students and professionals alike.',
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),

              const SizedBox(height: 40),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _saveBook(context),
                  icon: const Icon(Icons.bookmark_add_outlined, size: 24),
                  label: const Text(
                    'Save to My Library',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لعرض صفوف التفاصيل
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 15),
        Text(
          '$title: ',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}