class BookModel {
  final String bookId;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final String location;
  final int totalCopies;
  int availableCopies;

  BookModel({
    required this.bookId,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.location,
    required this.totalCopies,
    required this.availableCopies,
  });

  // تحويل من Map (جاهز للاستخدام مع Firestore إذا احتجت مستقبلاً)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'isbn': isbn,
      'category': category,
      'location': location,
      'totalCopies': totalCopies,
      'availableCopies': availableCopies,
    };
  }

  // تحويل من Firestore
  factory BookModel.fromSnapshot(Map<String, dynamic> data, String id) {
    return BookModel(
      bookId: id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      isbn: data['isbn'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      totalCopies: data['totalCopies'] ?? 0,
      availableCopies: data['availableCopies'] ?? 0,
    );
  }
}