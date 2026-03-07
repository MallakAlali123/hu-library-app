class AppConstants {
  // أدوار المستخدمين
  static const String roleStudent = 'student';
  static const String roleLibrarian = 'librarian';
  static const String roleAdmin = 'admin';

  // حالات الطلبات
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusReturned = 'returned';

  // أنواع الطلبات
  static const String requestArabicBook = 'arabic_book_purchase';
  static const String requestForeignBook = 'foreign_book_purchase';
  static const String requestBookSuggestion = 'book_suggestion';
  static const String requestBookGift = 'book_gift';
  static const String requestBorrow = 'borrow_request';
  static const String requestHall = 'hall_reservation';
  static const String requestInquiry = 'book_inquiry';

  // أسماء الـ Collections في Firestore
  static const String usersCollection = 'users';
  static const String booksCollection = 'books';
  static const String requestsCollection = 'requests';
  static const String announcementsCollection = 'announcements';
  static const String hallReservationsCollection = 'hall_reservations';
}