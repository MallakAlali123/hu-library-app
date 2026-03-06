import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';

// Student
import 'features/student/home/student_home.dart';

// Librarian
import 'features/librarian/librarian_home.dart';

// Admin
import 'features/admin/admin_home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return '/login';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/student', builder: (context, state) => const StudentHome()),
    GoRoute(path: '/librarian', builder: (context, state) => const LibrarianHome()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminHome()),
  ],
);