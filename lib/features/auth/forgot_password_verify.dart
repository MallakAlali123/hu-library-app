import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'new_password.dart'; 

class ForgotPasswordVerify extends StatefulWidget {
  const ForgotPasswordVerify({super.key});

  @override
  State<ForgotPasswordVerify> createState() => _ForgotPasswordVerifyState();
}

class _ForgotPasswordVerifyState extends State<ForgotPasswordVerify> {
  // استخدام TextEditingController و FocusNode يحتاج إلى تنظيف (dispose) وهو ما قمت به بشكل صحيح
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleVerify() async {
    String code = _controllers.map((e) => e.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;

    // الانتقال لصفحة تعيين كلمة المرور الجديدة (تأكد من وجود const إذا كان الكلاس يدعم ذلك)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewPassword()),
    );
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
          icon: const Icon(Icons.arrow_back, color: themeRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verification',
          style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle, 
                ),
                child: const Icon(Icons.mark_email_read_outlined, size: 40, color: themeRed),
              ),
              const SizedBox(height: 32),
              const Text(
                'Enter verification code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E)),
              ),
              const SizedBox(height: 12),
              const Text(
                "We've sent a 6-digit code to\nyour university email. Please enter it\nbelow to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF757575), fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index, themeRed)),
              ),
              
              const SizedBox(height: 32),
              const Text("Didn't receive the code?", style: TextStyle(color: Color(0xFF757575))),
              TextButton(
                onPressed: () {
                   // هنا يمكنك إضافة دالة إعادة الإرسال
                },
                child: const Text('↻ Resend code', style: TextStyle(color: themeRed, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Verify Code', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Check your spam folder if you can't find the email.\nVerification codes are valid for 10 minutes.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index, Color borderColor) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: "", 
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}