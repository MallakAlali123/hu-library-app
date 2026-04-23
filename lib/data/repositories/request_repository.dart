import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request.dart';

class RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addRequest(RequestModel request) async {
    try {
      await _firestore.collection('requests').add(request.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<RequestModel>> getUserRequests(String userId) async {
    try {
      QuerySnapshot result = await _firestore
          .collection('requests')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return result.docs.map((doc) {
        return RequestModel.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<RequestModel>> getAllRequests() async {
    try {
      QuerySnapshot result = await _firestore
          .collection('requests')
          .orderBy('createdAt', descending: true)
          .get();
      
      return result.docs.map((doc) {
        return RequestModel.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateRequestStatus(
      String requestId, String status, String? note) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({
        'status': status,
        'librarianNote': note,
        'approvedDate': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRequest(String requestId) async {
    try {
      await _firestore.collection('requests').doc(requestId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}