import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
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
  
  // المتغيرات المحلية
  bool _isDarkMode = false; // سنقوم بتحديثها في build أو من التفضيلات

  @override
  void initState() {
    super.initState();
    _loadCurrentName();
    _loadThemePreference();
  }

  void _loadCurrentName() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (doc.exists) {
          if (mounted) {
            setState(() {
              _nameController.text = doc.data()?['name'] ?? '';
            });
          }
        } else {
          await docRef.set({
            'name': 'Student',
            'email': user.email,
            'createdAt': DateTime.now(),
          });
          if (mounted) {
            setState(() {
              _nameController.text = 'Student';
            });
          }
        }
      } catch (e) {
        print("Error loading user data: $e");
      }
    }
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');
    // نقوم بالتحديث فقط إذا كانت القيمة موجودة في الذاكرة
    if (isDark != null && mounted) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

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
          Navigator.pop(context);
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

  void _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    
    setState(() {
      _isDarkMode = value;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Dark Mode Enabled' : 'Light Mode Enabled'), 
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _clearCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      final bool isDark = prefs.getBool('isDarkMode') ?? false; 
      await prefs.clear();
      await prefs.setBool('isDarkMode', isDark);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache cleared successfully'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ الحل الصحيح: نقوم بتحديث القيمة هنا داخل build
    // هذا يعطينا القيمة الحالية الصحيحة في كل مرة يعيد فيها التطبيق الرسم
    if (_isDarkMode != (Theme.of(context).brightness == Brightness.dark)) {
       // تحديث المتغير المحلي ليطابق الثيم العام إذا تغير من خارج الشاشة
       _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
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

                //2. قسم المظهر
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

                //3. قسم عام
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
                  icon: Icons.star_border_outlined,
                  title: 'rate_us'.tr(),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you for rating us! ⭐⭐⭐⭐⭐'), backgroundColor: Colors.orangeAccent),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // قسم معلومات التطبيق
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© ${DateTime.now().year} HU Library App',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
  final ValueChanged<bool>? onChanged; 

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged, 
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
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
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