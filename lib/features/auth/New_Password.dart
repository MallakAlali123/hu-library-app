import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ إضافة الترجمة

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields'.tr())),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match'.tr())),
      );
      return;
    }

    // هنا يجب إضافة منطق إعادة تعيين كلمة المرور الحقيقية في Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset successfully!'.tr()),
        backgroundColor: Colors.green,
      ),
    );
    
    // إعادة توجيه لشاشة تسجيل الدخول
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ استخدام لون من الثيم
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/forgot-password-verify'),
        ),
        title: Text(
          'Security'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest, // ✅ لون دينامي
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history_rounded, size: 50, color: const Color(0xFFCC3333)),
              ),
              const SizedBox(height: 32),
              Text(
                'Create new password'.tr(),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 12),
              Text(
                'Your new password must be different from previously used passwords. Use at least 8 characters.'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.5),
              ),
              const SizedBox(height: 40),
              _buildLabel('New Password'.tr()),
              _buildPasswordField(_passwordController, _isPasswordVisible, () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              }, 'Enter new password'.tr()),
              const SizedBox(height: 20),
              _buildLabel('Confirm Password'.tr()),
              _buildPasswordField(_confirmPasswordController, _isConfirmVisible, () {
                setState(() => _isConfirmVisible = !_isConfirmVisible);
              }, 'Confirm your new password'.tr()),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest, // ✅ لون دينامي
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PASSWORD REQUIREMENTS'.tr(),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFCC3333)),
                    ),
                    const SizedBox(height: 12),
                    _buildRequirementRow('At least 8 characters long'.tr(), true),
                    _buildRequirementRow('One uppercase and one lowercase letter'.tr(), false),
                    _buildRequirementRow('At least one number or symbol'.tr(), false),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC3333),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: Text('Reset Password'.tr(), style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      text: 'Need help? '.tr(),
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Contact Support'.tr(),
                          style: TextStyle(color: const Color(0xFFCC3333), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool isVisible, VoidCallback onToggle, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

    Widget _buildRequirementRow(String text, bool isMet) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Icon(
              isMet ? Icons.check_circle_outline : Icons.circle_outlined,
              size: 16,
              color: isMet ? Colors.green : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface))),
          ],
        ),
      );
    }
  }