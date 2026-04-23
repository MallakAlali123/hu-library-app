import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Domains المسموحة لكل دور ─────────────────────────────────
  // غيّر هذي القيم إذا تغير الـ domain لاحقاً
  static const String _librarianDomain = '@lib.hu.edu.jo';
  static const String _adminDomain     = '@admin.hu.edu.jo';

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ================= DOMAIN VALIDATION =================
  /// يتحقق إن الإيميل يناسب الدور المختار
  /// يرجع null إذا كل شي صح، أو رسالة خطأ إذا في مشكلة
  String? validateEmailForRole(String email, String role) {
    final lower = email.trim().toLowerCase();

    switch (role) {
      case 'librarian':
        if (!lower.endsWith(_librarianDomain)) {
          return 'librarian_email_invalid'.tr(); // إيميل أمين المكتبة غير صحيح
        }
        break;
      case 'admin':
        if (!lower.endsWith(_adminDomain)) {
          return 'admin_email_invalid'.tr(); // إيميل المدير غير صحيح
        }
        break;
      case 'student':
        // الطالب لا يسجل بإيميل خاص بالـ librarian أو admin
        if (lower.endsWith(_librarianDomain) || lower.endsWith(_adminDomain)) {
          return 'student_email_invalid'.tr(); // لا يمكن تسجيل الدخول بهذا الإيميل كطالب
        }
        break;
    }
    return null;
  }

  // ================= REGISTER =================
  Future<Map<String, dynamic>> register({
    required String name,
    required String studentId,
    required String email,
    required String password,
    required String role,
  }) async {
    // تحقق من الـ domain قبل Firebase
    final domainError = validateEmailForRole(email, role);
    if (domainError != null) {
      return {'success': false, 'message': domainError};
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await userCredential.user!.updateDisplayName(name);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'studentId': studentId,
        'email': email.trim(),
        'role': role,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'imageUrl': '',
      });

      notifyListeners();
      return {'success': true, 'message': 'Account created successfully'.tr()};
    } on FirebaseAuthException catch (e) {
      debugPrint("🔥 REGISTER ERROR: ${e.code} | ${e.message}");

      String message = e.message ?? 'An unknown error occurred';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use'.tr();
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak'.tr();
      }

      return {'success': false, 'message': message};
    } catch (e) {
      debugPrint("🔥 REGISTER ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role, // ← أُضيف هنا
  }) async {
    // تحقق من الـ domain قبل Firebase
    final domainError = validateEmailForRole(email, role);
    if (domainError != null) {
      return {'success': false, 'message': domainError};
    }

    try {
      debugPrint("📧 EMAIL: ${email.trim()} | ROLE: $role");

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // تحقق ثانٍ: الدور الفعلي في Firestore يطابق المختار
      final actualRole = await getUserRole();
      if (actualRole != role) {
        await _auth.signOut(); // أخرجه فوراً
        return {'success': false, 'message': 'role_mismatch'.tr()};
      }

      notifyListeners();
      return {'success': true, 'message': 'Login successful'.tr()};
    } on FirebaseAuthException catch (e) {
      debugPrint("🔥 LOGIN ERROR CODE: ${e.code}");

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'User not found'.tr();
          break;
        case 'wrong-password':
          message = 'Wrong password'.tr();
          break;
        case 'invalid-email':
          message = 'Invalid email format'.tr();
          break;
        case 'user-disabled':
          message = 'User account disabled'.tr();
          break;
        default:
          message = e.message ?? 'Login failed'.tr();
      }

      return {'success': false, 'message': message};
    } catch (e) {
      debugPrint("🔥 LOGIN ERROR: $e");
      return {'success': false, 'message': 'Something went wrong'};
    }
  }

  // ================= RESET PASSWORD =================
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  // ================= GET ROLE =================
  Future<String> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return 'student';

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data()?['role'] ?? 'student';
      }
      return 'student';
    } catch (e) {
      debugPrint("🔥 ROLE ERROR: $e");
      return 'student';
    }
  }

  // ================= GET USER DATA =================
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }
}