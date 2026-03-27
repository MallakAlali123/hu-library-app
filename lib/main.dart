import 'package:flutter/material.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/forgot_password_number.dart';
import 'features/auth/forgot_password_verify_n.dart';
import 'features/auth/new_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HU Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCC3333),
        ),
        useMaterial3: true,
      ),
      // الصفحة التي يبدأ بها التطبيق
      home: const SplashScreen(), 
      
      // تعريف المسارات لكي تعمل أزرار التنقل
      routes: {
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordNumber(),
        '/verify-number': (context) => ForgotPasswordVerify_n(),
        '/new-password': (context) => const NewPassword(),
      },
    );
  }
}