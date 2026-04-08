import 'package:hu_library_app/data/models/hall_reservation_model.dart';

import '../data/repositories/hall_repository.dart';

class HallService {
  final HallRepository _hallRepository = HallRepository();

  // جلب حجوزات المستخدم
  Future<List<HallReservationModel>> getMyReservations(String userId) async {
    try {
      return await _hallRepository.getUserReservations(userId);
    } catch (e) {
      print('Error getting reservations: $e');
      return [];
    }
  }

  // إنشاء حجز جديد
  Future<bool> bookHall(HallReservationModel reservation) async {
    try {
      return await _hallRepository.addReservation(reservation);
    } catch (e) {
      print('Error booking hall: $e');
      return false;
    }
  }

  // إلغاء الحجز (نغير الحالة بدل الحذف)
  Future<bool> cancelBooking(String reservationId) async {
    try {
      return await _hallRepository.updateReservationStatus(
        reservationId,
        'cancelled',
      );
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }

  // جلب كل الحجوزات (للأدمن مثلاً)
  Future<List<HallReservationModel>> getAllReservations() async {
    try {
      return await _hallRepository.getAllReservations();
    } catch (e) {
      print('Error getting all reservations: $e');
      return [];
    }
  }
}