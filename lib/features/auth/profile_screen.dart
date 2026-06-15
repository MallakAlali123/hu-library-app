import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart'; // استيراد الترجمة
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String _name = 'Loading...';
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final data = await _authService.getUserData();
    if (!mounted) return;
    setState(() {
      _name = data?['name'] ?? 'Student';
      _email = data?['email'] ?? '';
      _isLoading = false;
    });
  }

  void _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // ✅ دينامي
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface, // ✅ دينامي
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/student'),
        ),
        title: Text(
          'profile'.tr(), // ✅ ترجمة
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('More options clicked'.tr())),
               );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                          ],
                        ),
                        child: Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                      ),
                      GestureDetector(
                        onTap: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('Edit Profile feature coming soon'.tr())),
                           );
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(color: const Color(0xFFCC3333), shape: BoxShape.circle),
                          child: const Icon(Icons.edit, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    _name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: TextStyle(fontSize: 13, color: const Color(0xFFCC3333), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hashemite University',
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatItem(value: '12', label: 'Courses'.tr()),
                      Container(
                        width: 1,
                        height: 30,
                        color: Theme.of(context).colorScheme.outlineVariant,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      _StatItem(value: '4th', label: 'Year'.tr()),
                    ],
                  ),

                  const SizedBox(height: 28),

                  _SectionHeader(title: 'LIBRARY & ACTIVITY'),

                  _MenuItem(
                    icon: Icons.menu_book_outlined,
                    title: 'My Borrowed Books'.tr(),
                    subtitle: '3 books currently due'.tr(),
                    onTap: () => context.go('/my-books'), 
                  ),
                  
                  // ✅ تم التعديل هنا: التوجيه لصفحة Saved
                  _MenuItem(
                    icon: Icons.bookmark_border_rounded,
                    title: 'Saved'.tr(),
                    onTap: () => context.go('/saved'),
                  ),

                  const SizedBox(height: 8),

                  _SectionHeader(title: 'PREFERENCES'),

                  _MenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications'.tr(),
                    badge: '2', 
                    onTap: () => context.go('/notifications'),
                  ),
                  
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings'.tr(),
                    onTap: () => context.go('/settings'),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: Text('logout'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFCC3333),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: Color(0xFFFFDDDD)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) context.go('/student');
          if (index == 1) context.go('/hall');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: const Color(0xFFCC3333),
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'home'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Library'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'profile'.tr()),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), letterSpacing: 1.2),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFCC3333)),
        title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFCC3333), borderRadius: BorderRadius.circular(12)),
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}