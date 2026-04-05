import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  // ملاحظة: حذفنا const من هنا لأن الصفحة تحتوي على متغيرات ديناميكية (Controllers)
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  // إضافة dispose لتنظيف الذاكرة
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // العودة لصفحة تسجيل الدخول وتفريغ الذاكرة
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    const Color themeRed = Color(0xFFC62828);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Security',
          style: TextStyle(color: Color(0xFF0D1B3E), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.history_rounded, size: 50, color: themeRed),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Create new password',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E)),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Your new password must be different from\npreviously used passwords. Use at least 8\ncharacters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF757575), fontSize: 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              
              _buildLabel('New Password'),
              _buildPasswordField(_passwordController, _isPasswordVisible, () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              }, 'Enter new password'),
              
              const SizedBox(height: 20),
              
              _buildLabel('Confirm Password'),
              _buildPasswordField(_confirmPasswordController, _isConfirmVisible, () {
                setState(() => _isConfirmVisible = !_isConfirmVisible);
              }, 'Confirm your new password'),

              const SizedBox(height: 30),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PASSWORD REQUIREMENTS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: themeRed),
                    ),
                    const SizedBox(height: 12),
                    _buildRequirementRow('At least 8 characters long', true),
                    _buildRequirementRow('One uppercase and one lowercase letter', false),
                    _buildRequirementRow('At least one number or symbol', false),
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
                    backgroundColor: themeRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    // يمكنك إضافة رابط لفتح الدعم الفني هنا
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Need help? ',
                      style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Contact Support',
                          style: TextStyle(color: themeRed, fontWeight: FontWeight.bold),
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
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E)),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, bool isVisible, VoidCallback onToggle, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
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
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12, color: isMet ? Colors.black87 : Colors.grey[600])),
        ],
      ),
    );
  }
}