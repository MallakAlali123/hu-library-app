import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hu_library_app/widgets/common_widgets.dart';


class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  final List<Map<String, String>> _announcements = const [
    {'title': 'Library Closed on Friday', 'body': 'The library will be closed this Friday for maintenance.', 'date': 'May 8, 2025', 'type': 'info'},
    {'title': 'New Books Arrived', 'body': 'Over 200 new books have been added to our collection this week.', 'date': 'May 6, 2025', 'type': 'success'},
    {'title': 'Extended Hours', 'body': 'During exam season the library will be open until midnight.', 'date': 'May 3, 2025', 'type': 'warning'},
    {'title': 'Digital Resources Available', 'body': 'Students can now access digital databases from home using their university ID.', 'date': 'Apr 28, 2025', 'type': 'info'},
  ];

  Color _getTypeColor(String type) {
    switch (type) {
      case 'success': return Colors.green;
      case 'warning': return Colors.orange;
      default: return const Color(0xFFCC3333);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'success': return Icons.check_circle_outline_rounded;
      case 'warning': return Icons.warning_amber_rounded;
      default: return Icons.info_outline_rounded;
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
        title: Text('Announcements'.tr(),
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
              icon: Icons.campaign_outlined,
              title: 'Announcements'.tr(),
              subtitle: 'Latest news and updates from the library'.tr()),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _announcements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final a = _announcements[index];
              final color = _getTypeColor(a['type']!);
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 0.8),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(_getTypeIcon(a['type']!), color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(a['title']!,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface))),
                    Text(a['date']!,
                        style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
                  ]),
                  const SizedBox(height: 8),
                  Text(a['body']!,
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          height: 1.5)),
                ]),
              );
            },
          ),
        ]),
      ),
    );
  }
}