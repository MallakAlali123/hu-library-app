import 'package:hu_library_app/data/models/book.dart';

class BookRepository {
  // محاكاة قاعدة بيانات
  final List<BookModel> _books = [];

  // إضافة كتاب
  Future<bool> addBook(BookModel book) async {
    try {
      _books.add(book);
      return true;
    } catch (e) {
      return false;
    }
  }

  // البحث عن كتاب
  Future<List<BookModel>> searchBooks(String query) async {
    return _books.where((book) =>
      book.title.toLowerCase().contains(query.toLowerCase()) ||
      book.author.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // جلب كل الكتب
  Future<List<BookModel>> getAllBooks() async {
    return _books;
  }

  // جلب الكتب الجديدة
  Future<List<BookModel>> getNewBooks() async {
    if (_books.length <= 5) return _books;
    return _books.sublist(_books.length - 5);
  }

  // تعديل كتاب (تم تعديل الطريقة لإنشاء كائن جديد بدلاً من تعديل الحقول final)
  Future<bool> updateBook(String bookId, Map<String, dynamic> data) async {
    try {
      int index = _books.indexWhere((book) => book.bookId == bookId);
      if (index != -1) {
        // لا يمكن تعديل الحقول final مباشرة، لذا ننشئ BookModel جديد
        _books[index] = BookModel(
          bookId: _books[index].bookId,
          title: data['title'] ?? _books[index].title,
          author: data['author'] ?? _books[index].author,
          isbn: data['isbn'] ?? _books[index].isbn,
          category: data['category'] ?? _books[index].category,
          location: data['location'] ?? _books[index].location,
          totalCopies: data['totalCopies'] ?? _books[index].totalCopies,
          availableCopies: data['availableCopies'] ?? _books[index].availableCopies,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // حذف كتاب
  Future<bool> deleteBook(String bookId) async {
    try {
      _books.removeWhere((book) => book.bookId == bookId);
      return true;
    } catch (e) {
      return false;
    }
  }
}