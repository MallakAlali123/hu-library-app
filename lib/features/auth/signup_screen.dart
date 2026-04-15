import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await _authService.register(
        name: _nameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: 'student',
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success']) {
        // ✅ إضافة دالة مساعدة للترجمة لاستخدامها في النصوص
        String translate(String key) {
          // استبدل هذا بدلاً من ملف الترجمة أو أضيف النص مباشرة في الكود
          return key;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translate('Success')),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/verify-email', extra: _emailController.text.trim());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ استخدام لون من الثيم
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Header ─────────────────────────────────────
                Image.asset(
                  'assets/images/library.jpg',
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 160,
                      color: const Color(0xFFCC3333),
                      child: const Icon(Icons.library_books, size: 80, color: Colors.white),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── Join Library ─────────────────────────────
                Text(
                  'Join Library'.tr(),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter your academic details to access thousands of resources',
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.5),
                ),

                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Field
                      Text('Full Name'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFFCCCCCC)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter your name';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Student ID Field
                      Text('Student ID'.tr(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _studentIdController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Std1234567',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFFCCCCCC)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter your Student ID';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // University Email Field
                      Text('University Email'.tr(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'ID@std.hu.edu.jo',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFCCCCCC)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Please enter your university email';
                          if (!value.contains('@')) return 'Please enter a valid email';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Password'.tr(),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/forgot-password'),
                            child: Text(
                              'Forgot Password?'.tr(),
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFCC3333)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSignUp(),
                        decoration: InputDecoration(
                          hintText: '••••••••••••••••••••••••••••••••••••••••',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFFCCCCCC)),
                          suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              color: const Color(0xFF888888),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Password must be at least 6 characters';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                    ],
                  ),
              const SizedBox(height: 24),

              // ── Join Button ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC3333),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Join Library'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Sign In Link ─────────────────────────────────
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? '.tr(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Log in'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFCC3333), fontSize: 13),
                      ),
                    ),
                    ],
                  ),
                ),
  
                const SizedBox(height: 40),
  
                // ── Footer ─────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                    const SizedBox(width: 6),
                    Text(
                      'ENCRYPTED SECURE PORTAL'.tr(),
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), letterSpacing: 1.2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}