import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordEmail extends StatefulWidget {
  const ForgotPasswordEmail({super.key});

  @override
  State<ForgotPasswordEmail> createState() => _ForgotPasswordEmailState();
}

class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.push('/forgot-password-verify'); // ✅ push بدل go عشان يحفظ الصفحة السابقة
    }
  }

  void _handleFindByNumber() {
    context.push('/forgot-password-verify-n'); // ✅ push كمان هنا
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/login'),
        ),
        title: Text(
          'Forgot Password'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.lock_reset_rounded, color: Color(0xFFCC3333), size: 28),
              ),

              const SizedBox(height: 20),

              Text(
                'Reset\nPassword'.tr(),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface, height: 1.2),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter the university email address associated with your account. We will send you a 6-digit verification code to reset your password.'.tr(),
                style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.5),
              ),

              const SizedBox(height: 28),

              Text(
                'EMAIL'.tr(),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), letterSpacing: 1.2),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'ID@std.hu.edu.jo',
                  prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter your email'.tr();
                  if (!value.contains('@')) return 'Please enter a valid email'.tr();
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC3333),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Send Reset Code'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleFindByNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFCC3333),
                    side: const BorderSide(color: Color(0xFFCC3333)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Find by mobile number'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Remember your password? '.tr(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Log in'.tr(),
                        style: const TextStyle(color: Color(0xFFCC3333), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}