import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// تأكد من وجود ملف new_password.dart في نفس المجلد
import 'new_password.dart'; 

class ForgotPasswordVerify_n extends StatefulWidget {
  const ForgotPasswordVerify_n({super.key});

  @override
  State<ForgotPasswordVerify_n> createState() => _ForgotPasswordVerify_nState();
}

class _ForgotPasswordVerify_nState extends State<ForgotPasswordVerify_n> {
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

  void _handleVerifyAndProceed() async {
    String code = _controllers.map((e) => e.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit security code')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;

    // سيقوم هذا الزر بنقلك لصفحة NewPassword الحقيقية
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verify Number',
          style: TextStyle(color: Color(0xFF0D1B3E), fontWeight: FontWeight.bold, fontSize: 18),
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
                child: const Icon(Icons.phonelink_ring_rounded, size: 40, color: themeRed),
              ),
              const SizedBox(height: 32),
              const Text(
                'Enter verification code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E)),
              ),
              const SizedBox(height: 12),
              const Text(
                "We've sent a 6-digit security code to your\nmobile device at ----------",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF757575), fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 60),
              
              // حقول الـ OTP بالخطوط السفلية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpUnderlineField(index, themeRed)),
              ),
              
              const SizedBox(height: 40),
              const Text(
                'Didn\'t receive the code? Resend in 0:59',
                style: TextStyle(color: themeRed, fontWeight: FontWeight.w500, fontSize: 13),
              ),
              
              const SizedBox(height: 100),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Verify & Proceed',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'By verifying, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpUnderlineField(int index, Color activeColor) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD1D1D1), width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: activeColor, width: 2),
          ),
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