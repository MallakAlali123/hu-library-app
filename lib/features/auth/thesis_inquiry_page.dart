import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hu_library_app/widgets/common_widgets.dart';

class ThesisInquiryPage extends StatefulWidget {
  const ThesisInquiryPage({super.key});

  @override
  State<ThesisInquiryPage> createState() => _ThesisInquiryPageState();
}

class _ThesisInquiryPageState extends State<ThesisInquiryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = 'Book';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
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
        title: Text('Book or Thesis Inquiry'.tr(),
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
                icon: Icons.find_in_page_outlined,
                title: 'Book or Thesis Inquiry'.tr(),
                subtitle: 'Search for a specific book or thesis'.tr()),
            const SizedBox(height: 24),
            buildFieldLabel(context, 'Inquiry Type'.tr()),
            const SizedBox(height: 8),
            Row(children: [
              _buildTypeChip(context, 'Book', Icons.menu_book_rounded),
              const SizedBox(width: 10),
              _buildTypeChip(context, 'Thesis', Icons.description_outlined),
            ]),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'Title'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _titleController,
                hint: 'Enter title'.tr(),
                icon: Icons.title_rounded,
                context: context,
                validator: (v) => v == null || v.isEmpty ? 'This field is required'.tr() : null),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'Author / Researcher'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _authorController,
                hint: 'Enter name'.tr(),
                icon: Icons.person_outline_rounded,
                context: context),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'Year (optional)'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _yearController,
                hint: 'e.g. 2020'.tr(),
                icon: Icons.calendar_today_outlined,
                context: context),
            const SizedBox(height: 16),
            buildFieldLabel(context, 'Additional Notes'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _notesController,
                hint: 'Any additional details...'.tr(),
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
                    : Text('Submit Inquiry'.tr(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context, String type, IconData icon) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFCC3333)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFFCC3333)
                  : Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(children: [
          Icon(icon, size: 18,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 6),
          Text(type.tr(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface)),
        ]),
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
          Text('Inquiry Submitted!'.tr(),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('We will get back to you soon'.tr(),
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