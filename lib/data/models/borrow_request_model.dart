class BorrowRequestModel {
  final String requestId;
  final String userId;
  final String userName;
  final String bookId;
  final String bookTitle;
  final String status; // pending, approved, rejected, returned
  final String requestDate;
  final String? approvedDate;
  final String? returnDate;
  final String? librarianNote;

  BorrowRequestModel({
    required this.requestId,
    required this.userId,
    required this.userName,
    required this.bookId,
    required this.bookTitle,
    required this.status,
    required this.requestDate,
    this.approvedDate,
    this.returnDate,
    this.librarianNote,
  });

  factory BorrowRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return BorrowRequestModel(
      requestId: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      bookId: map['bookId'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      status: map['status'] ?? 'pending',
      requestDate: map['requestDate'] ?? '',
      approvedDate: map['approvedDate'],
      returnDate: map['returnDate'],
      librarianNote: map['librarianNote'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'status': status,
      'requestDate': requestDate,
      'approvedDate': approvedDate,
      'returnDate': returnDate,
      'librarianNote': librarianNote,
    };
  }
}