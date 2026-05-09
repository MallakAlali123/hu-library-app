import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hu_library_app/widgets/common_widgets.dart';

class NewBooksPage extends StatelessWidget {
  const NewBooksPage({super.key});

  final List<Map<String, String>> _books = const [
    {'title': 'Introduction to AI', 'author': 'John Smith', 'category': 'Technology'},
    {'title': 'Modern Literature', 'author': 'Sara Ali', 'category': 'Literature'},
    {'title': 'Data Structures', 'author': 'Ahmed Hassan', 'category': 'Computer Science'},
    {'title': 'Islamic History', 'author': 'Khalid Omar', 'category': 'History'},
    {'title': 'Business Ethics', 'author': 'Maya Johnson', 'category': 'Business'},
    {'title': 'Advanced Mathematics', 'author': 'Dr. Lee', 'category': 'Mathematics'},
  ];

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
        title: Text('Newly Added Books'.tr(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildHeaderCard(context,
              icon: Icons.auto_stories_outlined,
              title: 'Newly Added Books'.tr(),
              subtitle: 'Latest additions to our library collection'.tr()),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _books.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final book = _books[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 0.8),
                ),
                child: Row(children: [
                  Container(
                    width: 48, height: 56,
                    decoration: BoxDecoration(
                        color: const Color(0xFFCC3333).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Color(0xFFCC3333), size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(book['title']!,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 4),
                    Text(book['author']!,
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color(0xFFCC3333).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(book['category']!,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFCC3333),
                              fontWeight: FontWeight.w600)),
                    ),
                  ])),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                ]),
              );
            },
          ),
        ]),
      ),
    );
  }
}