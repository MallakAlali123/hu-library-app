import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BookModel>> getAllBooks() async {
    try {
      QuerySnapshot result = await _firestore.collection('books').get();
      return result.docs
          .map((doc) =>
          BookModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<BookModel?> getBook(String bookId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('books').doc(bookId).get();
      if (!doc.exists) return null;
      return BookModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addBook(BookModel book) async {
    try {
      await _firestore.collection('books').add(book.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateBook(String bookId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('books').doc(bookId).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<BookModel>> searchBooks(String query) async {
    try {
      QuerySnapshot result = await _firestore
          .collection('books')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
      return result.docs
          .map((doc) =>
          BookModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<BookModel>> getNewBooks() async {
    try {
      QuerySnapshot result = await _firestore
          .collection('books')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
      return result.docs
          .map((doc) =>
          BookModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }
}