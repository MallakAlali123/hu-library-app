import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/announcement_model.dart';
import '../data/repositories/announcement_repository.dart';

class AnnouncementService {
  final AnnouncementRepository _announcementRepo = AnnouncementRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إضافة إعلان (للأمين)
  Future<Map<String, dynamic>> addAnnouncement({
    required String title,
    required String content,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return {'success': false, 'message': 'يجب تسجيل الدخول'};

      AnnouncementModel announcement = AnnouncementModel(
        announcementId: '',
        title: title,
        content: content,
        createdAt: DateTime.now().toIso8601String(),
        createdBy: user.uid,
      );

      bool result = await _announcementRepo.addAnnouncement(announcement);
      if (result) {
        return {'success': true, 'message': 'تم نشر الإعلان بنجاح'};
      }
      return {'success': false, 'message': 'فشل نشر الإعلان'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // جلب كل الإعلانات
  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    return await _announcementRepo.getAllAnnouncements();
  }

  // حذف إعلان
  Future<Map<String, dynamic>> deleteAnnouncement(String announcementId) async {
    try {
      bool result = await _announcementRepo.deleteAnnouncement(announcementId);
      if (result) {
        return {'success': true, 'message': 'تم حذف الإعلان بنجاح'};
      }
      return {'success': false, 'message': 'فشل حذف الإعلان'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}