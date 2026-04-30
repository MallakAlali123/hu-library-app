import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hu_library_app/features/auth/LibraryServicesPage.dart';
import 'package:hu_library_app/features/auth/book_suggestion.dart';
import 'package:hu_library_app/features/auth/logs_screen.dart';
import 'package:hu_library_app/features/auth/roles_screen.dart';

import 'package:hu_library_app/features/auth/splash_screen.dart';
import 'package:hu_library_app/features/auth/login_screen.dart';
import 'package:hu_library_app/features/auth/signUp_screen.dart';
import 'package:hu_library_app/features/auth/VE_Signup.dart';
import 'package:hu_library_app/features/auth/profile_screen.dart';
import 'package:hu_library_app/features/auth/Hall.dart';
import 'package:hu_library_app/features/auth/BookRoom1.dart';
import 'package:hu_library_app/features/auth/donate_screen.dart';
import 'package:hu_library_app/features/auth/New_Password.dart';
import 'package:hu_library_app/features/auth/forgot_password_email.dart';
import 'package:hu_library_app/features/auth/forgot_password_verify_n.dart';
import 'package:hu_library_app/features/auth/notifications_screen.dart';
import 'package:hu_library_app/features/auth/settings_screen.dart';

import 'package:hu_library_app/features/auth/home_page.dart' as student;
import 'package:hu_library_app/features/auth/LibraryServicesPage.dart' as librarian;

import 'package:hu_library_app/features/auth/AdminDashboard.dart';
import 'package:hu_library_app/features/auth/user_management.dart';
import 'package:hu_library_app/features/auth/database_management.dart';
import 'package:hu_library_app/features/auth/AdminSettingsScreen.dart';
import 'package:hu_library_app/features/auth/admin_user_guide_screen.dart';

import 'package:hu_library_app/features/auth/Full%20Report.dart' show FullReportScreen;
import 'package:hu_library_app/features/auth/Support%20Ticket.dart' show AdminSupportTicketScreen;
import 'package:hu_library_app/features/auth/edit_%20profile.dart' show AdminEditProfileScreen;

import 'package:hu_library_app/features/auth/AddNewBookScreen.dart' show AddNewBookScreen;
import 'package:hu_library_app/features/auth/GenerateReportScreen.dart' show GenerateReportScreen;
import 'package:hu_library_app/features/auth/ChangePasswordScreen.dart' show ChangePasswordScreen;
import 'package:hu_library_app/features/auth/NotificationPreferencesScreen.dart' show NotificationPreferencesScreen;
import 'package:hu_library_app/features/auth/LanguageLocationScreen.dart' show LanguageLocationScreen;

import 'package:hu_library_app/features/auth/guide_manage_users.dart';
import 'package:hu_library_app/features/auth/guide_system_settings.dart';
import 'package:hu_library_app/features/auth/guide_reports.dart';
import 'package:hu_library_app/features/auth/guide_password_reset.dart';
import 'package:hu_library_app/features/auth/notificationsadmin_screen.dart' hide NotificationsScreen;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    final isAuthRoute = state.matchedLocation == '/' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/verify-email' ||
        state.matchedLocation == '/forgot-password' ||
        state.matchedLocation == '/forgot-password-verify-n' ||
        state.matchedLocation == '/new-password';

    if (user == null && !isAuthRoute) return '/login';
    if (user != null && state.matchedLocation == '/') return '/login';
    return null;
  },

  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return VerifyEmailScreen(email: email);
      },
    ),
    GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordEmail()),
    GoRoute(path: '/forgot-password-verify-n', builder: (context, state) => const ForgotPasswordVerify_n()),
    GoRoute(path: '/new-password', builder: (context, state) => const NewPassword()),

    // Student
    GoRoute(path: '/student', builder: (context, state) => const student.LibraryServicesPage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/hall', builder: (context, state) => const HallScreen()),
    GoRoute(path: '/book-room', builder: (context, state) => const BookRoom1Screen()),
    GoRoute(path: '/donate', builder: (context, state) => const DonateScreen()),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/search', builder: (context, state) => _placeholderScreen(context, 'Search Books', Icons.search_rounded, '/student')),
    GoRoute(path: '/my-books', builder: (context, state) => _placeholderScreen(context, 'My Borrowed Books', Icons.menu_book_rounded, '/student')),
    GoRoute(path: '/my-requests', builder: (context, state) => _placeholderScreen(context, 'My Requests', Icons.assignment_outlined, '/student')),
    GoRoute(path: '/book-suggestion', builder: (context, state) => _placeholderScreen(context, 'Book Suggestion', Icons.lightbulb_outline_rounded, '/student')),

    // Librarian
    GoRoute(path: '/librarian', builder: (context, state) => const librarian.LibraryServicesPage()),

    // Admin
    GoRoute(path: '/admin', builder: (context, state) => const AdminDashboard()),
    GoRoute(path: '/admin/users', builder: (context, state) => const UserManagementScreen()),
    GoRoute(path: '/admin/system-settings', builder: (context, state) => const SystemSettingsScreen()),
    GoRoute(path: '/admin/account', builder: (context, state) => const AdminSettingsScreen()),
    GoRoute(path: '/admin/reports', builder: (context, state) => const FullReportScreen()),
    GoRoute(path: '/admin/edit-profile', builder: (context, state) => const AdminEditProfileScreen()),
    GoRoute(path: '/admin/support-ticket', builder: (context, state) => const AdminSupportTicketScreen()),
    GoRoute(path: '/admin/change-password', builder: (context, state) => const ChangePasswordScreen()),
    GoRoute(path: '/admin/language-location', builder: (context, state) => const LanguageLocationScreen()),
    GoRoute(path: '/admin/user-guide', builder: (context, state) => const AdminUserGuideScreen()),
    GoRoute(path: '/admin/guide/manage-users', builder: (context, state) => const GuideManageUsers()),
    GoRoute(path: '/admin/guide/settings', builder: (context, state) => const GuideSystemSettings()),
    GoRoute(path: '/admin/guide/reports', builder: (context, state) => const GuideReports()),
    GoRoute(path: '/admin/guide/password-reset', builder: (context, state) => const GuidePasswordReset()),
    GoRoute(path: '/admin/add-book', builder: (context, state) => const AddNewBookScreen()),
    GoRoute(path: '/admin/generate-report', builder: (context, state) => const GenerateReportScreen()),
    GoRoute(path: '/admin/logs', builder: (context, state) => const LogsScreen()),
    GoRoute(path: '/admin/roles', builder: (context, state) => const RolesScreen()),
    GoRoute(path: '/admin/suggestions', builder: (context, state) => const BookSuggestionsScreen()),

    // ✅ notifications - شاشة عرض الإشعارات من Firestore
    GoRoute(
      path: '/admin/notifications',
      builder: (context, state) => const NotificationsAdminScreen(),
    ),

    // ✅ notification-preferences - شاشة إعدادات الإشعارات (مسار جديد)
    GoRoute(
      path: '/admin/notification-preferences',
      builder: (context, state) => const NotificationPreferencesScreen(),
    ),
  ],
);

Widget _placeholderScreen(BuildContext context, String title, IconData icon, String backRoute) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.go(backRoute),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(0xFFCC3333)),
          const SizedBox(height: 16),
          Text('$title coming soon...', style: const TextStyle(fontSize: 16, color: Color(0xFF888888))),
        ],
      ),
    ),
  );
}