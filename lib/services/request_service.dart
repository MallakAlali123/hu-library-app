import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/request.dart';
import '../data/repositories/request_repository.dart';

class RequestService {
  final RequestRepository _requestRepo = RequestRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إرسال طلب جديد
  Future<Map<String, dynamic>> submitRequest({
    required String requestType,
    required String title,
    required String description,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return {'success': false, 'message': 'يجب تسجيل الدخول'};

      // جلب اسم المستخدم
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String userName = doc['name'] ?? '';

      // ✅ تم التصحيح: استخدام RequestModel بدلاً من Request
      RequestModel request = RequestModel(
        requestId: '',
        userId: user.uid,
        userName: userName,
        bookTitle: title, // ملاحظة: في الـ Model الحقل bookTitle، هنا نمرر title
        status: 'pending',
        createdAt: DateTime.now().toIso8601String(),
      );

      bool result = await _requestRepo.addRequest(request);
      if (result) {
        return {'success': true, 'message': 'تم إرسال الطلب بنجاح'};
      }
      return {'success': false, 'message': 'فشل إرسال الطلب'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // جلب طلبات المستخدم الحالي
  Future<List<RequestModel>> getMyRequests() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return [];
      return await _requestRepo.getUserRequests(user.uid);
    } catch (e) {
      return [];
    }
  }

  // جلب كل الطلبات (للأمين)
  Future<List<RequestModel>> getAllRequests() async {
    return await _requestRepo.getAllRequests();
  }

  // قبول أو رفض طلب (للأمين)
  Future<Map<String, dynamic>> updateRequestStatus({
    required String requestId,
    required String status,
    String? note,
  }) async {
    try {
      bool result = await _requestRepo.updateRequestStatus(requestId, status, note);
      if (result) {
        return {'success': true, 'message': 'تم تحديث الطلب بنجاح'};
      }
      return {'success': false, 'message': 'فشل تحديث الطلب'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}