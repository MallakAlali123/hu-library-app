class BookModel {
  final String bookId;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final String location;
  final int totalCopies;
  final int availableCopies;

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

  factory BookModel.fromMap(Map<String, dynamic> map, String id) {
    return BookModel(
      bookId: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      isbn: map['isbn'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      totalCopies: map['totalCopies'] ?? 0,
      availableCopies: map['availableCopies'] ?? 0,
    );
  }

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
}