import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/VE_Signup.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return VerifyEmailScreen(email: email);
      },
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