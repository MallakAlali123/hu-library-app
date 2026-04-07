import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hall_reservation_model.dart';

class HallRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addReservation(HallReservationModel reservation) async {
    try {
      await _firestore
          .collection('hall_reservations')
          .add(reservation.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<HallReservationModel>> getUserReservations(
      String userId) async {
    try {
      QuerySnapshot result = await _firestore
          .collection('hall_reservations')
          .where('userId', isEqualTo: userId)
          .get();
      return result.docs
          .map((doc) => HallReservationModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<HallReservationModel>> getAllReservations() async {
    try {
      QuerySnapshot result = await _firestore
          .collection('hall_reservations')
          .orderBy('date', descending: true)
          .get();
      return result.docs
          .map((doc) => HallReservationModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateReservationStatus(
      String reservationId, String status) async {
    try {
      await _firestore
          .collection('hall_reservations')
          .doc(reservationId)
          .update({'status': status});
      return true;
    } catch (e) {
      return false;
    }
  }
}