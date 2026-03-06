class HallReservationModel {
  final String reservationId;
  final String userId;
  final String userName;
  final String hallName;
  final String date;
  final String timeFrom;
  final String timeTo;
  final String status; // pending, approved, rejected

  HallReservationModel({
    required this.reservationId,
    required this.userId,
    required this.userName,
    required this.hallName,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.status,
  });

  factory HallReservationModel.fromMap(Map<String, dynamic> map, String id) {
    return HallReservationModel(
      reservationId: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      hallName: map['hallName'] ?? '',
      date: map['date'] ?? '',
      timeFrom: map['timeFrom'] ?? '',
      timeTo: map['timeTo'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'hallName': hallName,
      'date': date,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'status': status,
    };
  }
}