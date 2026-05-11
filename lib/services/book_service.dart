import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addBook({
    required String title,
    required String author,
    required String isbn,
    required String summary,
    required String category,
    required String location,
    required int totalCopies,
  }) async {
    try {
      await _firestore.collection('books').add({
        'title': title,
        'author': author,
        'isbn': isbn,
        'summary': summary,
        'category': category,
        'location': location,
        'totalCopies': totalCopies,
        'availableCopies': totalCopies,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Book added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}