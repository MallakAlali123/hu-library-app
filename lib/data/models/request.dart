class RequestModel {
  final String requestId; // سيتم تعيينه من Firestore
  final String userId;
  final String userName;
  final String bookTitle;
  final String status; // pending, approved, rejected
  final String? librarianNote;
  final String createdAt;

  RequestModel({
    required this.requestId,
    required this.userId,
    required this.userName,
    required this.bookTitle,
    required this.status,
    this.librarianNote,
    required this.createdAt,
  });

  // تحويل البيانات لتخزينها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'bookTitle': bookTitle,
      'status': status,
      'librarianNote': librarianNote,
      'createdAt': createdAt,
    };
  }

  // تحويل البيانات القادمة من Firestore إلى Model
  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      requestId: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      status: map['status'] ?? 'pending',
      librarianNote: map['librarianNote'],
      createdAt: map['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }
}