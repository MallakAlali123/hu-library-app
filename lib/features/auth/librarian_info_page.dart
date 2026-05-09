import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class LibrarianInfoPage extends StatelessWidget {
  const LibrarianInfoPage({super.key});

  final List<Map<String, String>> _librarians = const [
    {'name': 'Dr. Fatima Al-Ahmad', 'role': 'Head Librarian', 'email': 'f.ahmad@hu.edu.jo', 'phone': '+962 5 3903333'},
    {'name': 'Mr. Khalid Mansour', 'role': 'Reference Librarian', 'email': 'k.mansour@hu.edu.jo', 'phone': '+962 5 3903334'},
    {'name': 'Ms. Rania Haddad', 'role': 'Digital Resources', 'email': 'r.haddad@hu.edu.jo', 'phone': '+962 5 3903335'},
  ];

  Widget _buildHeaderCard(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
    return Container(
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
          decoration: BoxDecoration(color: const Color(0xFFCC3333), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 3),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ])),
      ]),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
      const SizedBox(width: 6),
      Text(text, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Librarian Info'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeaderCard(context,
            icon: Icons.person_outline_rounded,
            title: 'Meet Our Librarians'.tr(),
            subtitle: 'Our team is here to help you'.tr()),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _librarians.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lib = _librarians[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 0.8),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 52, height: 52,
                    decoration: const BoxDecoration(color: Color(0xFFCC3333), shape: BoxShape.circle),
                    child: Center(child: Text(
                      lib['name']!.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(lib['name']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 2),
                    Text(lib['role']!, style: const TextStyle(fontSize: 12, color: Color(0xFFCC3333), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    _infoRow(context, Icons.email_outlined, lib['email']!),
                    const SizedBox(height: 4),
                    _infoRow(context, Icons.phone_outlined, lib['phone']!),
                  ])),
                ]),
              );
            },
          ),
        ]),
      ),
    );
  }
}