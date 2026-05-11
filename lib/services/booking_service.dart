import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return BookingModel(
      id: doc.id,
      roomName: data['roomName'] ?? 'Unknown Room',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      status: data['status'] ?? 'Pending',
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

      // ✅ التعديل: جلب البيانات أولاً بدون ترتيب معقد للتأكد من وجود البيانات
      final snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get(); // أزلنا .orderBy مؤقتاً لضمان العمل

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error in getUserBookings: $e");
      rethrow; // إعادة رمي الخطأ لعرضه في الشاشة
    }
  }

  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'Cancelled',
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
      if (userId == null) return {'success': false, 'message': 'User not authenticated'};

      await _firestore.collection('bookings').add({
        'userId': userId,
        'roomName': roomName,
        'date': date,
        'time': time,
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(), // نضعه هنا للاستخدام مستقبلاً
      });

      return {'success': true, 'message': 'Booking created'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}