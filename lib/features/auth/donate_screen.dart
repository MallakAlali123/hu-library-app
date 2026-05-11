import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/book_service.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _summaryController = TextEditingController();

  String? _selectedCategory;
  bool _isLoading = false;

  final List<String> _categories = [
    'Engineering & Sciences',
    'Medical Sciences',
    'Business & Humanities',
    'General Categories',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _handleAddToLibrary() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final bookService = BookService();

      final result = await bookService.addBook(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        isbn: _isbnController.text.trim(),
        summary: _summaryController.text.trim(),
        category: _selectedCategory ?? 'General Categories',
        location: 'Library Shelf A1',
        totalCopies: 1,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor:
              result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        _titleController.clear();
        _authorController.clear();
        _isbnController.clear();
        _summaryController.clear();

        setState(() {
          _selectedCategory = null;
        });
      }
    }
  }

  void _handleSaveAsDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved as draft!'.tr()),
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String hint,
  ) {
    return InputDecoration(
      hintText: hint.tr(),
      hintStyle: TextStyle(
        color:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
      filled: true,
      fillColor:
          Theme.of(context).colorScheme.surfaceContainerHighest,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFCC3333),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/student'),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Librarian: Add New Book'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),

                const SizedBox(height: 30),

                Text(
                  'Book Title'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration(
                    context,
                    'Enter full title of the book',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter the book title'
                          .tr();
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Text(
                  'Author'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _authorController,
                  decoration:
                      _inputDecoration(context, 'Author name'),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Required'.tr();
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Text(
                  'ISBN'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _isbnController,
                  decoration: _inputDecoration(
                    context,
                    'e.g. 978-3-16...',
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Summary / Description'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _summaryController,
                  maxLines: 4,
                  decoration: _inputDecoration(
                    context,
                    'Provide a detailed summary...',
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Category'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration:
                      _inputDecoration(context, ''),
                  hint: Text('Select a category'.tr()),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category'
                          .tr();
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed:
                        _isLoading ? null : _handleAddToLibrary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFCC3333),
                      foregroundColor: Colors.white,
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.library_add_rounded,
                          ),
                    label: Text(
                      _isLoading
                          ? ''
                          : 'Add to Library Collection'
                              .tr(),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _handleSaveAsDraft,
                    child: Text(
                      'Save as Draft'.tr(),
                      style: const TextStyle(
                        color: Color(0xFFCC3333),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}