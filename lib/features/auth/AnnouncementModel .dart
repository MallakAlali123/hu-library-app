import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String announcementId;
  final String title;
  final String content;
  final String createdAt;
  final String createdBy;

  AnnouncementModel({
    required this.announcementId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.createdBy,
  });

  // 1. دالة التحويل من Firebase (DocumentSnapshot) إلى Model
  factory AnnouncementModel.fromSnapshot(DocumentSnapshot snapshot) {
    // نحصل على البيانات كخريطة (Map)
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    
    // التعامل مع التاريخ: نستقبله كـ Timestamp ثم نحوله إلى String
    String dateStr = '';
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        dateStr = (map['createdAt'] as Timestamp).toDate().toString(); 
      } else {
        dateStr = map['createdAt'].toString();
      }
    }

    return AnnouncementModel(
      announcementId: snapshot.id, // أخذ المعرف الخاص بالمستند
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: dateStr,
      createdBy: map['createdBy'] ?? '',
    );
  }

  // 2. دالة التحويل من Model إلى Map (للحفظ في Firebase)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt, // أو FieldValue.serverTimestamp() إذا أردت حفظ التلقائي
      'createdBy': createdBy,
    };
  }

  // --- دوال التعامل مع قاعدة البيانات (CRUD Operations) ---

  // إنشاء مرجع للمجموعة (Collection Reference)
  static final CollectionReference _announcementsCollection = 
      FirebaseFirestore.instance.collection('announcements');

  // 3. دالة لإضافة إعلان جديد
  static Future<void> addAnnouncement({
    required String title,
    required String content,
    required String createdBy,
  }) async {
    try {
      await _announcementsCollection.add({
        'title': title,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(), // حفظ وقت السيرفر تلقائياً
        'createdBy': createdBy,
      });
      print("Announcement added successfully");
    } catch (e) {
      print("Error adding announcement: $e");
      rethrow; // إعادة الخطأ للتعامل معه في الواجهة
    }
  }

  // 4. دالة لجلب جميع الإعلانات كـ Stream (للتحديث الفوري)
  static Stream<List<AnnouncementModel>> getAnnouncementsStream() {
    return _announcementsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AnnouncementModel.fromSnapshot(doc))
            .toList());
  }

  // 5. دالة لجلب جميع الإعلانات مرة واحدة (Future)
  static Future<List<AnnouncementModel>> getAnnouncementsOnce() async {
    try {
      QuerySnapshot snapshot = await _announcementsCollection.get();
      return snapshot.docs
          .map((doc) => AnnouncementModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Error fetching announcements: $e");
      return [];
    }
  }

  // 6. دالة لتحديث إعلان موجود
  static Future<void> updateAnnouncement({
    required String docId,
    required String title,
    required String content,
  }) async {
    try {
      await _announcementsCollection.doc(docId).update({
        'title': title,
        'content': content,
        // لا نحدث التاريخ عادة عند التعديل، إلا إذا أردت
      });
      print("Announcement updated successfully");
    } catch (e) {
      print("Error updating announcement: $e");
    }
  }

  // 7. دالة لحذف إعلان
  static Future<void> deleteAnnouncement(String docId) async {
    try {
      await _announcementsCollection.doc(docId).delete();
      print("Announcement deleted successfully");
    } catch (e) {
      print("Error deleting announcement: $e");
    }
  }
}