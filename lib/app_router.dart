import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return '/login';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('شاشة تسجيل الدخول - قريباً')),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('شاشة التسجيل - قريباً')),
      ),
    ),
    GoRoute(
      path: '/student',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('شاشة الطالب - قريباً')),
      ),
    ),
    GoRoute(
      path: '/librarian',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('شاشة الأمين - قريباً')),
      ),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('شاشة الأدمن - قريباً')),
      ),
    ),
  ],
);