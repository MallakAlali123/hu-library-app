import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordVerify_n extends StatefulWidget {
  const ForgotPasswordVerify_n({super.key});

  @override
  State<ForgotPasswordVerify_n> createState() => _ForgotPasswordVerify_nState();
}

class _ForgotPasswordVerify_nState extends State<ForgotPasswordVerify_n> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the 6-digit code'.tr())),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    context.go('/new-password');
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
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
          onPressed: () {
            // ✅ يرجع لصفحة الإيميل السابقة عن طريق الـ stack
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/forgot-password');
            }
          },
        ),
        title: Text(
          'Verify Number'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Phone Icon ────────────────────────────────────
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.phone_android,
                      size: 80,
                      color: Color(0xFFCC3333),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Title ─────────────────────────────────────────
                Center(
                  child: Text(
                    'Verify Phone Number'.tr(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Subtitle ──────────────────────────────────────
                Center(
                  child: Text(
                    "We've sent a 6-digit verification code to\n0791234567\nPlease enter it below\nto confirm your account.".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), height: 1.6),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Code Input (6 خانات) ──────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 50,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5)),
                        ),
                        onChanged: (value) => _onCodeChanged(value, index),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 40),

                // ── Verify Button ─────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleVerify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC3333),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFCC3333).withValues(alpha: 0.7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Verify'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle, size: 20),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Resend Code ───────────────────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: "Didn't receive code? ".tr(),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Code resent!'.tr())),
                              );
                            },
                            child: Text(
                              'Resend Code'.tr(),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFCC3333)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Footer ───────────────────────────────────────
                const Center(
                  child: Text(
                    'Secure verification powered by AuthGuard',
                    style: TextStyle(fontSize: 11, color: Color(0xFFAAAAAA), letterSpacing: 0.3),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}