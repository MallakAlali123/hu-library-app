import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hu_library_app/widgets/common_widgets.dart';


class ForeignBookPurchasePage extends StatefulWidget {
  const ForeignBookPurchasePage({super.key});

  @override
  State<ForeignBookPurchasePage> createState() => _ForeignBookPurchasePageState();
}

class _ForeignBookPurchasePageState extends State<ForeignBookPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _languageController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _languageController.dispose();
    _notesController.dispose();
    super.dispose();
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
        title: Text('Foreign Book Purchase'.tr(),
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
            buildHeaderCard(context,
                icon: Icons.public_rounded,
                title: 'Foreign Book Purchase'.tr(),
                subtitle: 'Submit a request to purchase a foreign book'.tr()),
            const SizedBox(height: 24),
            buildFieldLabel(context, 'Book Title'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _titleController,
                hint: 'Enter book title'.tr(),
                icon: Icons.title_rounded,
                context: context,
                validator: (v) => v == null || v.isEmpty ? 'This field is required'.tr() : null),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'Author Name'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _authorController,
                hint: 'Enter author name'.tr(),
                icon: Icons.person_outline_rounded,
                context: context),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'ISBN'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _isbnController,
                hint: 'Enter ISBN if available'.tr(),
                icon: Icons.tag_rounded,
                context: context),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'Language'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _languageController,
                hint: 'e.g. English, French...'.tr(),
                icon: Icons.language_rounded,
                context: context),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'Additional Notes'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _notesController,
                hint: 'Any additional information...'.tr(),
                icon: Icons.notes_rounded,
                context: context,
                maxLines: 4),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) {
                              setState(() => _isLoading = false);
                              _showSuccessDialog(context);
                            }
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC3333),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0),
                child: _isLoading
                    ? const SizedBox(
                        width: 22, height: 22,
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
          Container(
              width: 64, height: 64,
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
              child: Text('Done'.tr(),
                  style: const TextStyle(color: Color(0xFFCC3333)))),
        ],
      ),
    );
  }
}