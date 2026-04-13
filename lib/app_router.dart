import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// استيراد الشاشات
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/VE_Signup.dart'; // Verify Email Signup
import 'features/auth/home_page.dart'; // LibraryServicesPage
import 'features/auth/profile_screen.dart';
import 'features/auth/Hall.dart'; // HallScreen
import 'features/auth/BookRoom1.dart'; // BookRoom1Screen
import 'features/auth/donate.dart'; // DonateScreen
import 'features/auth/New_Password.dart';
import 'features/auth/forgot_password_email.dart';
import 'features/auth/forgot_password_number.dart';
import 'features/auth/forgot_password_verify_n.dart';
import 'features/auth/forgot_password_verify.dart';
import 'features/auth/notifications_screen.dart'; // ✅ شاشة الإشعارات
import 'features/auth/settings_screen.dart'; // ✅ شاشة الإعدادات الجديدة

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Splash ────────────────────────────────────
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Auth ──────────────────────────────────────
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
      builder: (context, state) => const ForgotPasswordVerify_n(),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) => const NewPassword(),
    ),

    // ── Student (Main App) ───────────────────────
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

    // ── Features (Coming Soon / Placeholders) ────
    GoRoute(
      path: '/search',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Search Books'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/student'),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_rounded, size: 64, color: Color(0xFFCC3333)),
              SizedBox(height: 16),
              Text('Search coming soon...', style: TextStyle(fontSize: 16, color: Color(0xFF888888))),
            ],
          ),
        ),
      ),
    ),
    
    GoRoute(
      path: '/my-books', 
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('My Borrowed Books'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/student'),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_rounded, size: 64, color: Color(0xFFCC3333)),
              SizedBox(height: 16),
              Text('My Books coming soon...', style: TextStyle(fontSize: 16, color: Color(0xFF888888))),
            ],
          ),
        ),
      ),
    ),
    
    GoRoute(
      path: '/my-requests',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/student'),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined, size: 64, color: Color(0xFFCC3333)),
              SizedBox(height: 16),
              Text('My Requests coming soon...', style: TextStyle(fontSize: 16, color: Color(0xFF888888))),
            ],
          ),
        ),
      ),
    ),
    
    GoRoute(
      path: '/book-suggestion',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Book Suggestion'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/student'),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 64, color: Color(0xFFCC3333)),
              SizedBox(height: 16),
              Text('Book Suggestion coming soon...', style: TextStyle(fontSize: 16, color: Color(0xFF888888))),
            ],
          ),
        ),
      ),
    ),

    // ── Notifications & Settings ───────────────────
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // ── Librarian & Admin ─────────────────────────
    GoRoute(
      path: '/librarian',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Librarian Dashboard')),
        body: const Center(child: Text('شاشة الأمين - قريباً')),
      ),
    ),

    GoRoute(
      path: '/admin',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: const Center(child: Text('شاشة الأدمن - قريباً')),
      ),
    ),
  ],
);