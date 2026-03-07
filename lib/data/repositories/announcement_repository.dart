import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement_model.dart';

class AnnouncementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore.collection('announcements').add(announcement.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    try {
      QuerySnapshot result = await _firestore
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .get();
      return result.docs
          .map((doc) => AnnouncementModel.fromMap(
          doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteAnnouncement(String announcementId) async {
    try {
      await _firestore
          .collection('announcements')
          .doc(announcementId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}