import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  String _statusText = 'INITIALIZING DATABASE';

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() async {
    // محاكاة شريط التحميل
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() {
        _progress = i / 100;
        if (i < 40) {
          _statusText = 'INITIALIZING DATABASE';
        } else if (i < 70) {
          _statusText = 'LOADING RESOURCES';
        } else if (i < 90) {
          _statusText = 'PREPARING CONTENT';
        } else {
          _statusText = 'ALMOST READY';
        }
      });
    }

    // التحقق من حالة تسجيل الدخول بعد انتهاء التحميل
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // إذا كان المستخدم مسجل الدخول، انتقل للطالب (أو الرئيسية)
      context.go('/student');
    } else {
      // إذا لم يكن مسجل، انتقل لصفحة الدخول
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFCC3333),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCC3333).withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Academic Library',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'KNOWLEDGE AT YOUR FINGERTIPS',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFCC3333),
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _statusText,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFCC3333),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFF333333),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFCC3333),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'v 2.4.0 — Premium Academic Access',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}