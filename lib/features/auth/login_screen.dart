import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/auth_service.dart';

enum UserRole { student, librarian, admin }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.student;
  final AuthService _authService = AuthService();

  static const _red = Color(0xFFCC3333);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole.name, // 'student' | 'librarian' | 'admin'
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success']) {
      switch (_selectedRole) {
        case UserRole.librarian:
          context.go('/librarian');
        case UserRole.admin:
          context.go('/admin');
        case UserRole.student:
          context.go('/student');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // الـ hint يتغير حسب الدور المختار
  String get _emailHint {
    switch (_selectedRole) {
      case UserRole.librarian:
        return 'name@lib.hu.edu.jo';
      case UserRole.admin:
        return 'name@admin.hu.edu.jo';
      case UserRole.student:
        return 'email_hint'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: _red),
                    ),
                    Text(
                      'hu_library'.tr(),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ── Banner ──────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180,
                        color: _red,
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 140,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.account_balance,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 180,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          'welcome_back'.tr(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Role Selector ───────────────────────────────
                Text(
                  'login_as'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _RoleChip(
                      label: 'student'.tr(),
                      icon: Icons.school_rounded,
                      selected: _selectedRole == UserRole.student,
                      onTap: () => setState(() => _selectedRole = UserRole.student),
                    ),
                    const SizedBox(width: 8),
                    _RoleChip(
                      label: 'librarian'.tr(),
                      icon: Icons.local_library_rounded,
                      selected: _selectedRole == UserRole.librarian,
                      onTap: () => setState(() => _selectedRole = UserRole.librarian),
                    ),
                    const SizedBox(width: 8),
                    _RoleChip(
                      label: 'admin'.tr(),
                      icon: Icons.admin_panel_settings_rounded,
                      selected: _selectedRole == UserRole.admin,
                      onTap: () => setState(() => _selectedRole = UserRole.admin),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Email ───────────────────────────────────────
                Text('university_email'.tr()),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: _emailHint,
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'enter_email'.tr();
                    if (!v.contains('@')) return 'valid_email'.tr();
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Password ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('password'.tr()),
                    GestureDetector(
                      onTap: () => context.go('/forgot-password'),
                      child: Text(
                        'forgot_password'.tr(),
                        style: const TextStyle(color: _red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '********',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'enter_password'.tr();
                    if (v.length < 6) return 'password_short'.tr();
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ── Login Button ────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('secure_login'.tr()),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Register (طلاب فقط) ─────────────────────────
                if (_selectedRole == UserRole.student)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('new_student'.tr()),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text(
                          'register_account'.tr(),
                          style: const TextStyle(color: _red),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 40),

                // ── Footer ──────────────────────────────────────
                Center(child: Text('secure_portal'.tr())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Widget مساعد: زر اختيار الدور ───────────────────────────────
class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  static const _red = Color(0xFFCC3333);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _red.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: selected ? _red : Theme.of(context).colorScheme.outline,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? _red : Theme.of(context).colorScheme.outline,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? _red : Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}