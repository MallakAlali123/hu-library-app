import 'package:hu_library_app/data/models/book.dart';

import '../data/repositories/book_repository.dart';

class BookService {
  final BookRepository _bookRepo = BookRepository();

  // إضافة كتاب جديد (للأمين)
  Future<Map<String, dynamic>> addBook({
    required String title,
    required String author,
    required String isbn,
    required String category,
    required String location,
    required int totalCopies,
  }) async {
    try {
      // التأكد من تمرير bookId (نمرره فارغاً لأن Repository سيولده)
      BookModel book = BookModel(
        bookId: '', // سيتم تعيينه من قبل Repository أو Firebase
        title: title,
        author: author,
        isbn: isbn,
        category: category,
        location: location,
        totalCopies: totalCopies,
        availableCopies: totalCopies,
      );
      bool result = await _bookRepo.addBook(book);
      if (result) return {'success': true, 'message': 'تم إضافة الكتاب بنجاح'};
      return {'success': false, 'message': 'فشل إضافة الكتاب'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // البحث عن كتاب
  Future<List<BookModel>> searchBooks(String query) async {
    return await _bookRepo.searchBooks(query);
  }

  // جلب كل الكتب
  Future<List<BookModel>> getAllBooks() async {
    return await _bookRepo.getAllBooks();
  }

  // جلب الكتب الجديدة
  Future<List<BookModel>> getNewBooks() async {
    return await _bookRepo.getNewBooks();
  }

  // تعديل كتاب
  Future<Map<String, dynamic>> updateBook({
    required String bookId,
    required Map<String, dynamic> data,
  }) async {
    try {
      bool result = await _bookRepo.updateBook(bookId, data);
      if (result) return {'success': true, 'message': 'تم تعديل الكتاب بنجاح'};
      return {'success': false, 'message': 'فشل تعديل الكتاب'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // حذف كتاب
  Future<Map<String, dynamic>> deleteBook(String bookId) async {
    try {
      bool result = await _bookRepo.deleteBook(bookId);
      if (result) return {'success': true, 'message': 'تم حذف الكتاب بنجاح'};
      return {'success': false, 'message': 'فشل حذف الكتاب'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}