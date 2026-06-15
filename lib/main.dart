import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'firebase_options.dart';
import 'app_router.dart';

// تمت إزالة themeNotifier العام من هنا لتجنب الأخطاء الدائرية
// سنقوم بإدارة الثيم داخل MyApp

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // متغير لتخزين وضع الثيم
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // دالة لقراءة الثيم المحفوظ وتحديث التطبيق فوراً
  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    
    if (mounted) {
      setState(() {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'HU Library',

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // ✅ تعريف الثيم الفاتح يدوياً (بدون seedColor)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFCC3333),     // اللون الأحمر الأساسي
          surface: Color(0xFFF4F6F8),     // خلفية فاتحة
          onSurface: Colors.black87,      // نص أسود
          surfaceContainerHighest: Colors.white, // بطاقات بيضاء
        ),
      ),

      // ✅ تعريف الثيم الداكن يدوياً
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFCC3333),     // اللون الأحمر الأساسي
          surface: Color(0xFF121212),     // خلفية داكنة جداً
          onSurface: Colors.white,        // نص أبيض
          surfaceContainerHighest: Color(0xFF1E1E1E), // بطاقات داكنة
        ),
      ),

      // ✅ ربط الثيم بالمتغير الذي يتحدث تلقائياً
      themeMode: _themeMode, 
      
      routerConfig: appRouter,
    );
  }
}