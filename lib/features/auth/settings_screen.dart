import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:easy_localization/easy_localization.dart'; // ✅ استيراد الترجمة
import '../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  
  // متغير للوضع الليلي
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentName();
    _loadThemePreference();
  }

  // تعديل دالة تحميل الاسم
  void _loadCurrentName() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (doc.exists) {
          // إذا وجدت بيانات، اعرضها
          setState(() {
            _nameController.text = doc.data()?['name'] ?? '';
          });
        } else {
          // إذا لم توجد بيانات، قم بإنشائها الآن
          await docRef.set({
            'name': 'Student',
            'email': user.email,
            'createdAt': DateTime.now(),
          });
          setState(() {
            _nameController.text = 'Student';
          });
        }
      } catch (e) {
        print("Error loading user data: $e");
      }
    }
  }

  // تحميل تفضيل الثيم
  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // تحديث الاسم
  void _updateName() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final user = _auth.currentUser;

    try {
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(),
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name updated successfully'), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // العودة للبروفايل
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // تبديل الثيم
  void _toggleTheme(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    // حفظ القيمة، سيتم تطبيقها عند إعادة التشغيل (أو يمكن إضافتها لـ ThemeProvider)
  }

  // مسح البيانات
  void _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared successfully'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ استخدام لون الخلفية من الثيم (يتغير حسب الـ ThemeMode)
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      appBar: AppBar(
        // ✅ استخدام لون الخلفية من الثيم
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'settings'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //1. قسم الحساب
          Text(
            'account'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest, // لون الحاوية يعتمد على الثيم
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'display_name'.tr(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateName,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC3333),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text('save_changes'.tr(), style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          //2. قسم المظهر (Appearance)
          Text(
            'appearance'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 10),

          _SettingsSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'dark_mode'.tr(),
            subtitle: 'enable_dark_theme'.tr(),
            value: _isDarkMode,
            onChanged: _toggleTheme,
          ),

          const SizedBox(height: 24),

          //3. قسم عام (General)
          Text(
            'general'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          ),
          const SizedBox(height: 10),

          _SettingsTile(
            icon: Icons.cleaning_services_outlined,
            title: 'clear_cache'.tr(),
            onTap: _clearCache,
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'language'.tr(),
            trailing: context.locale.languageCode == 'ar' ? 'العربية' : 'English',
            onTap: () async {
              // تبديل اللغة مع إعادة تحميل الصفحة لتفعيل التغيير
              final newLocale = context.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
              await context.setLocale(newLocale);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Language changed to ${newLocale.languageCode == 'ar' ? 'Arabic' : 'English'}'), backgroundColor: Colors.green),
                );
              }
            },
          ),
          _SettingsTile(
            icon: Icons.star_border_outlined,
            title: 'rate_us'.tr(),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Store...')),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
        title: Text(title, style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
        subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))) : null,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFCC3333),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest, // استخدام لون من الثيم
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
        title: Text(title, style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null) Text(trailing!, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}