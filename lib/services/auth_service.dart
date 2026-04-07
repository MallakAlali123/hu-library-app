import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  // تسجيل مستخدم جديد
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role, // student, librarian, admin
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // حفظ بيانات المستخدم في Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': DateTime.now().toIso8601String(),
      });

      return {'success': true, 'message': 'تم التسجيل بنجاح'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // تسجيل الدخول
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true, 'message': 'تم تسجيل الدخول بنجاح'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await _auth.signOut();
  }

  // الحصول على دور المستخدم
  Future<String?> getUserRole() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      return doc['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  // الحصول على بيانات المستخدم كاملة
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
}