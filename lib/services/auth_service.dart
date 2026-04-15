import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ دعم اللغة
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../services/auth_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<String> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return 'student';

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return doc.data()?['role'] ?? 'student';
      } else {
        return 'student';
      }
    } catch (e) {
      print("Error getting user role: $e");
      return 'student';
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      notifyListeners();

      return {'success': true, 'message': 'Login successful'};
    } catch (e) {
      return {'success': false, 'message': 'Incorrect email or password'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String studentId,
    required String email,
    required String password,
    required String role,
  }) async {
   final userCredential = await _auth.createUserWithEmailAndPassword(
  email: email,
  password: password,
);
    await userCredential.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'name': name,
      'studentId': studentId,
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });

    notifyListeners();

    return {'success': true, 'message': 'Account created successfully'};
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
  Future<Map<String, dynamic>?> getUserData() async {
  final user = _auth.currentUser;
  if (user == null) return null;

  final doc = await _firestore.collection('users').doc(user.uid).get();
  return doc.data();
}
}
