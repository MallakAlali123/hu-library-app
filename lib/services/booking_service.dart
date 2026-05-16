import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String _capitalizeFirst(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

class BookingModel {
  final String id;
  final String roomName;
  final String date;
  final String time;
  final String status;

  BookingModel({
    required this.id,
    required this.roomName,
    required this.date,
    required this.time,
    required this.status,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // معالجة الـ date
    String dateStr = '';
    if (data['date'] is Timestamp) {
      final ts = data['date'] as Timestamp;
      final dt = ts.toDate();
      dateStr =
          '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } else if (data['date'] is String) {
      dateStr = data['date'];
    }

    // معالجة الـ time
    String timeStr = '';
    if (data['time'] is Timestamp) {
      final ts = data['time'] as Timestamp;
      final dt = ts.toDate();
      timeStr =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (data['time'] is String) {
      timeStr = data['time'];
    }

    return BookingModel(
      id: doc.id,
      roomName: data['roomName'] ?? 'Unknown Room',
      date: dateStr,
      time: timeStr,
      status: _capitalizeFirst(data['status']?.toString() ?? 'pending'),
    );
  }
}

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<BookingModel>> getUserBookings() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      final snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error in getUserBookings: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
      });
      return {'success': true, 'message': 'Booking cancelled successfully'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createBooking({
    required String roomName,
    required String date,
    required String time,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return {'success': false, 'message': 'User not authenticated'};
      }

      await _firestore.collection('bookings').add({
        'userId': userId,
        'roomName': roomName,
        'date': date,
        'time': time,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Booking created'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}