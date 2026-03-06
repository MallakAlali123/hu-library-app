class RequestModel {
  final String requestId;
  final String userId;
  final String bookId;
  final String type;
  final String status;
  final String date;

  RequestModel({
    required this.requestId,
    required this.userId,
    required this.bookId,
    required this.type,
    required this.status,
    required this.date,
  });
}