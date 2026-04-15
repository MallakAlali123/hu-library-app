import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ إضافة الترجمة

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ استخدام لون من الثيم
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'Notifications'.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // جلب الإشعارات من مجموعتي notifications في فيربيس
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFCC3333)));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none_outlined, size: 64, color: Color(0xFFCC3333)),
                  const SizedBox(height: 16),
                  Text('No notifications yet'.tr(), style: const TextStyle(color: Color(0xFF888888))),
                ],
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final notif = notifications[index].data() as Map<String, dynamic>;
              final docId = notifications[index].id;

              // تحديد الأيقونة واللون بناءً على نوع الإشعار
              IconData icon = Icons.info_outline_rounded;
              Color iconColor = Colors.grey;
              
              if (notif['type'] == 'book') {
                icon = Icons.menu_book_rounded;
                iconColor = Colors.blue;
              } else if (notif['type'] == 'reservation') {
                icon = Icons.event_available_rounded;
                iconColor = Colors.green;
              } else if (notif['type'] == 'reminder') {
                icon = Icons.alarm_rounded;
                iconColor = Colors.orange;
              }

              bool isRead = notif['isRead'] ?? false;

              return _NotificationTile(
                title: notif['title'] ?? 'Notification'.tr(),
                message: notif['message'] ?? 'No message',
                time: _formatTimestamp(notif['timestamp']),
                icon: icon,
                iconColor: iconColor,
                isRead: isRead,
                onTap: () {
                  // تحديث حالة "مقروء" في قاعدة البيانات عند الضغط
                  if (!isRead) {
                    FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(docId)
                        .update({'isRead': true});
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // دالة مساعدة لتنسيق التاريخ
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Just now'.tr();
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago'.tr();
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago'.tr();
    } else {
      return '${difference.inDays} days ago'.tr();
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isRead ? Colors.white : Colors.red[50], // ✅ استخدام Color.red[50] بدلاً من الألوان الثابتة
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFCC3333),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}