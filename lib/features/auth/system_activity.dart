import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _tempNameController = TextEditingController();

  bool _isLoading = false;
  bool _isDarkMode = false;
  bool _hasUnsavedChanges = false;
  String _originalName = ''; // ✅ الاسم الأصلي للمقارنة

  @override
  void initState() {
    super.initState();
    _loadCurrentName();
    _isDarkMode = themeNotifier.value == ThemeMode.dark;
  }

  void _loadCurrentName() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (doc.exists) {
          final name = doc.data()?['name'] ?? '';
          setState(() {
            _originalName = name; // ✅ احفظ الاسم الأصلي
            _tempNameController.text = name;
          });
        } else {
          await docRef.set({
            'name': 'Student',
            'email': user.email,
            'createdAt': DateTime.now(),
          });
          setState(() {
            _originalName = 'Student';
            _tempNameController.text = 'Student';
          });
        }
      } catch (e) {
        debugPrint("Error loading user data: $e");
      }
    }
  }

  // ✅ مقارنة صحيحة مع الاسم الأصلي
  void _onNameChanged(String value) {
    setState(() {
      _hasUnsavedChanges = value.trim() != _originalName.trim();
    });
  }

  void _updateName() async {
    final newName = _tempNameController.text.trim();
    if (newName.isEmpty) return;

    setState(() => _isLoading = true);
    final user = _auth.currentUser;

    try {
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': newName,
        });
        setState(() {
          _originalName = newName; // ✅ حدّث الاسم الأصلي بعد الحفظ
          _hasUnsavedChanges = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Name updated successfully ✅'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _discardChanges() {
    setState(() {
      _tempNameController.text = _originalName; // ✅ رجّع الاسم الأصلي
      _hasUnsavedChanges = false;
    });
  }

  void _toggleTheme(bool value) async {
    setState(() => _isDarkMode = value);
    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  void _clearCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDarkMode');
      await prefs.clear();
      if (isDark != null) await prefs.setBool('isDarkMode', isDark);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully ✅'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _changeLanguage() async {
    final currentLang = context.locale.languageCode;
    final newLocale =
        currentLang == 'en' ? const Locale('ar') : const Locale('en');
    final langName = newLocale.languageCode == 'ar' ? 'Arabic' : 'English';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Language'),
        content: Text('Switch to $langName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCC3333)),
            child:
                const Text('Switch', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await context.setLocale(newLocale);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $langName ✅'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showUnsavedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Do you want to save before leaving?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _discardChanges();
              context.go('/profile');
            },
            child:
                const Text('Discard', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateName();
              context.go('/profile');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCC3333)),
            child:
                const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tempNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            if (_hasUnsavedChanges) {
              _showUnsavedDialog();
            } else {
              context.go('/profile');
            }
          },
        ),
        title: Text(
          'settings'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── 1. Account ──────────────────────────────────────────
          Text(
            'account'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'display_name'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _tempNameController,
                  onChanged: _onNameChanged, // ✅ يراقب التغييرات
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                ),
                // ✅ Save / Discard يظهران فقط لما في تغيير حقيقي
                if (_hasUnsavedChanges) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _discardChanges,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Discard',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCC3333),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text('save_changes'.tr(),
                                  style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── 2. Appearance ───────────────────────────────────────
          Text(
            'appearance'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
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

          // ── 3. General ──────────────────────────────────────────
          Text(
            'general'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
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
            trailing: context.locale.languageCode == 'ar'
                ? 'العربية'
                : 'English',
            onTap: _changeLanguage,
          ),
          _SettingsTile(
            icon: Icons.star_border_outlined,
            title: 'rate_us'.tr(),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Store... ⭐')),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ── Reusable Widgets ────────────────────────────────────────────────

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
        leading:
            Icon(icon, color: Theme.of(context).colorScheme.onSurface),
        title: Text(title,
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface)),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6)))
            : null,
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap, // ✅ هاد هو اللي بيشغّل الضغطة
        leading:
            Icon(icon, color: Theme.of(context).colorScheme.onSurface),
        title: Text(title,
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(trailing!,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6))),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}