class RequestModel {
  final String requestId;
  final String userId;
  final String userName;
  final String requestType;
  // arabic_book_purchase
  // foreign_book_purchase
  // book_suggestion
  // book_gift
  // borrow_request
  // hall_reservation
  // book_inquiry
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final String? librarianNote;

  RequestModel({
    required this.requestId,
    required this.userId,
    required this.userName,
    required this.requestType,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.librarianNote,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      requestId: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      requestType: map['requestType'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] ?? '',
      librarianNote: map['librarianNote'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'requestType': requestType,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'librarianNote': librarianNote,
    };
  }
}