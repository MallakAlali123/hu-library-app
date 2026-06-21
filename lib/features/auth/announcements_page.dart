import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hu_library_app/widgets/common_widgets.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  // دالة لتحديد اللون بناءً على نوع الإعلان (اختياري: يمكنك إزالته إذا لم تستخدمه)
  Color _getTypeColor(String? type) {
    if (type == 'success') return Colors.green;
    if (type == 'warning') return Colors.orange;
    return const Color(0xFFCC3333);
  }

  IconData _getTypeIcon(String? type) {
    if (type == 'success') return Icons.check_circle_outline_rounded;
    if (type == 'warning') return Icons.warning_amber_rounded;
    return Icons.info_outline_rounded;
  }

  // دالة مساعدة لتنسيق التاريخ بشكل جميل
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderCard(
              context,
              icon: Icons.campaign_outlined,
              title: 'Announcements'.tr(),
              subtitle: 'Latest news and updates from the library'.tr(),
            ),
            const SizedBox(height: 20),
            
            // ✅ الاستبدال: استخدام StreamBuilder لجلب البيانات حية من Firebase
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('announcements')
                  .orderBy('timestamp', descending: true) // ترتيب من الأحدث للأقدم
                  .snapshots(),
              builder: (context, snapshot) {
                // حالة الانتظار
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Color(0xFFCC3333)),
                    ),
                  );
                }

                // في حال عدم وجود إعلانات
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.campaign_outlined, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No announcements yet'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'New updates from the library will appear here'.tr(),
                          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // عرض الإعلانات
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    
                    // استخراج البيانات (مدعوم بحقول الأمان null safety)
                    final title = data['title'] ?? 'No Title';
                    final body = data['content'] ?? ''; // ملاحظة: الـ Librarian يحفظ النص في حقل 'content'
                    final dateStr = _formatDate(data['timestamp']);
                    final type = data['type']; // حقل اختياري إذا أردت تلوين الإعلانات
                    
                    final color = _getTypeColor(type);
                    
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 0.8,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_getTypeIcon(type), color: color, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (dateStr.isNotEmpty)
                                Text(
                                  dateStr,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            body,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}