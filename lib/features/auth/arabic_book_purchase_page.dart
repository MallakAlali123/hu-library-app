import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class ArabicBookPurchasePage extends StatefulWidget {
  const ArabicBookPurchasePage({super.key});

  @override
  State<ArabicBookPurchasePage> createState() => _ArabicBookPurchasePageState();
}

class _ArabicBookPurchasePageState extends State<ArabicBookPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ✅ الإرسال لـ Firestore
  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('book_purchases').add({
        'type': 'Arabic',
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'publisher': _publisherController.text.trim(),
        'notes': _notesController.text.trim(),
        'studentId': user?.uid ?? '',
        'studentName': user?.displayName ?? user?.email ?? 'Unknown',
        'status': 'PENDING',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
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
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Arabic Book Purchase'.tr(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFCC3333).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCC3333).withOpacity(0.2)),
              ),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                      color: const Color(0xFFCC3333),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Arabic Book Purchase'.tr(),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 3),
                  Text('Submit a request to purchase an Arabic book'.tr(),
                      style: TextStyle(fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                ])),
              ]),
            ),

            const SizedBox(height: 24),
            _buildLabel(context, 'Book Title'.tr()),
            const SizedBox(height: 8),
            _buildTextField(controller: _titleController, hint: 'Enter book title'.tr(),
                icon: Icons.title_rounded, context: context,
                validator: (v) => v == null || v.isEmpty ? 'This field is required'.tr() : null),

            const SizedBox(height: 16),
            _buildLabel(context, 'Author Name'.tr()),
            const SizedBox(height: 8),
            _buildTextField(controller: _authorController, hint: 'Enter author name'.tr(),
                icon: Icons.person_outline_rounded, context: context),

            const SizedBox(height: 16),
            _buildLabel(context, 'Publisher'.tr()),
            const SizedBox(height: 8),
            _buildTextField(controller: _publisherController, hint: 'Enter publisher name'.tr(),
                icon: Icons.business_outlined, context: context),

            const SizedBox(height: 16),
            _buildLabel(context, 'Additional Notes'.tr()),
            const SizedBox(height: 8),
            _buildTextField(controller: _notesController, hint: 'Any additional information...'.tr(),
                icon: Icons.notes_rounded, context: context, maxLines: 4),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest, // ✅ بيرسل لـ Firestore
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC3333),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0),
                child: _isLoading
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Submit Request'.tr(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 64, height: 64,
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 40)),
          const SizedBox(height: 16),
          Text('Request Submitted!'.tr(),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Your request has been sent successfully'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ]),
        actions: [
          TextButton(
              onPressed: () { context.pop(); context.pop(); },
              child: Text('Done'.tr(), style: const TextStyle(color: Color(0xFFCC3333)))),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required BuildContext context,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), size: 20)
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.8)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}