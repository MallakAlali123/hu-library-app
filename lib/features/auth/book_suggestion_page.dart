import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hu_library_app/widgets/common_widgets.dart';


class BookSuggestionPage extends StatefulWidget {
  const BookSuggestionPage({super.key});

  @override
  State<BookSuggestionPage> createState() => _BookSuggestionPageState();
}

class _BookSuggestionPageState extends State<BookSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  String _selectedCategory = 'Computer Science';
  final List<String> _categories = [
    'Computer Science',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Literature',
    'History',
    'Business',
    'Engineering',
    'Medicine',
    'Law',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitSuggestion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('suggestions').add({
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'category': _selectedCategory,
        'notes': _notesController.text.trim(),
        'studentId': user?.uid ?? '',
        'studentName': user?.displayName ?? user?.email ?? 'Unknown',
        'status': 'PENDING',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded,
                color: Colors.green, size: 40),
          ),
          const SizedBox(height: 16),
          Text('Suggestion Submitted!'.tr(),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Thank you! Your suggestion has been sent to the library team.'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ]),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // يغلق الـ dialog
              context.pop(); // يرجع للهوم بيج
            },
            child: Text('Done'.tr(),
                style: const TextStyle(color: Color(0xFFCC3333))),
          ),
        ],
      ),
    );
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
        title: Text('Book Suggestion'.tr(),
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
            buildHeaderCard(context,
                icon: Icons.lightbulb_outline_rounded,
                title: 'Book Suggestion'.tr(),
                subtitle: 'Suggest a book to be added to the library collection'.tr()),

            const SizedBox(height: 24),

            // Book Title
            buildFieldLabel(context, 'Book Title'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _titleController,
                hint: 'Enter book title'.tr(),
                icon: Icons.title_rounded,
                context: context,
                validator: (v) => v == null || v.isEmpty
                    ? 'This field is required'.tr()
                    : null),

            const SizedBox(height: 16),

            // Author
            buildFieldLabel(context, 'Author Name'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _authorController,
                hint: 'Enter author name'.tr(),
                icon: Icons.person_outline_rounded,
                context: context),

            const SizedBox(height: 16),

            // Category
            buildFieldLabel(context, 'Category'.tr()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.8),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                      size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                dropdownColor: Theme.of(context).colorScheme.surface,
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface),
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Notes
            buildFieldLabel(context, 'Why should we add this book?'.tr()),
            const SizedBox(height: 8),
            buildTextField(
                controller: _notesController,
                hint: 'Tell us why this book would be valuable...'.tr(),
                icon: Icons.notes_rounded,
                context: context,
                maxLines: 4),

            const SizedBox(height: 24),

            // My Previous Suggestions
            buildFieldLabel(context, 'My Previous Suggestions'.tr()),
            const SizedBox(height: 12),
            _buildPreviousSuggestions(),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitSuggestion,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC3333),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0),
                child: _isLoading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text('Submit Suggestion'.tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildPreviousSuggestions() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('suggestions')
          .where('studentId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.8),
            ),
            child: Row(children: [
              Icon(Icons.info_outline_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  size: 20),
              const SizedBox(width: 10),
              Text('No previous suggestions'.tr(),
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5))),
            ]),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final status = data['status'] ?? 'PENDING';

            Color statusColor;
            Color statusTextColor;
            switch (status) {
              case 'ADDED':
                statusColor = Colors.green.withOpacity(0.1);
                statusTextColor = Colors.green;
                break;
              case 'REVIEWED':
                statusColor = Colors.blue.withOpacity(0.1);
                statusTextColor = Colors.blue;
                break;
              default:
                statusColor = Colors.orange.withOpacity(0.1);
                statusTextColor = Colors.orange;
            }

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.8),
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                      color: const Color(0xFFCC3333).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.menu_book_rounded,
                      color: Color(0xFFCC3333), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(data['title'] ?? '',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface)),
                      const SizedBox(height: 2),
                      Text(data['author'] ?? '',
                          style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5))),
                    ])),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(status,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusTextColor)),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}