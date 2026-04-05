import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/VE_Signup.dart';
import 'features/auth/home_page.dart';
import 'features/auth/profile_screen.dart';
import 'features/auth/Hall.dart';
import 'features/auth/BookRoom1.dart';
import 'features/auth/donate.dart';
import 'features/auth/New_Password.dart';
import 'features/auth/forgot_password_email.dart';
import 'features/auth/forgot_password_number.dart';
import 'features/auth/forgot_password_verify_n.dart';
import 'features/auth/forgot_password_verify.dart';

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
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordEmail(),
    ),
    GoRoute(
      path: '/forgot-password-number',
      builder: (context, state) => const ForgotPasswordNumber(),
    ),
    GoRoute(
      path: '/forgot-password-verify',
      builder: (context, state) => const ForgotPasswordVerify(),
    ),
    GoRoute(
      path: '/forgot-password-verify-n',
      builder: (context, state) => ForgotPasswordVerify_n(),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) => const NewPassword(),
    ),
    GoRoute(
      path: '/student',
      builder: (context, state) => const LibraryServicesPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/hall',
      builder: (context, state) => const HallScreen(),
    ),
    GoRoute(
      path: '/book-room',
      builder: (context, state) => const BookRoom1Screen(),
    ),
    GoRoute(
      path: '/donate',
      builder: (context, state) => const DonateScreen(),
    ),
    GoRoute(
      path: '/book-suggestion',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Book Suggestion - قريباً')),
      ),
    ),
    GoRoute(
      path: '/my-requests',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('طلباتي - قريباً')),
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