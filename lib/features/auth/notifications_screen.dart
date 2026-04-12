import 'package:flutter/material.dart';


class NotificationsManager {
  static final NotificationsManager _instance = NotificationsManager._internal();
  factory NotificationsManager() => _instance;
  NotificationsManager._internal();

  final List<NotificationItem> notifications = [
    NotificationItem(
      type: NotifType.returnBook,
      title: 'Book Return Reminder',
      message: 'Please return "Clean Code" by tomorrow.',
      time: '2 hours ago',
      isRead: false,
    ),
    NotificationItem(
      type: NotifType.approved,
      title: 'Request Approved',
      message: 'Your request for "Algorithms" has been approved. Pick it up from the library.',
      time: '5 hours ago',
      isRead: false,
    ),
    NotificationItem(
      type: NotifType.available,
      title: 'Book Now Available',
      message: '"Data Structures" is now available. Reserve it before someone else does!',
      time: 'Yesterday',
      isRead: true,
    ),
    NotificationItem(
      type: NotifType.overdue,
      title: 'Overdue Book',
      message: '"Introduction to Algorithms" is overdue. Please return it as soon as possible.',
      time: '2 days ago',
      isRead: true,
    ),
    NotificationItem(
      type: NotifType.approved,
      title: 'Donation Approved',
      message: 'Thank you! Your donated book has been added to the library collection.',
      time: '3 days ago',
      isRead: true,
    ),
    NotificationItem(
      type: NotifType.returnBook,
      title: 'Book Return Reminder',
      message: '"Design Patterns" is due in 3 days. Please plan to return it on time.',
      time: '4 days ago',
      isRead: true,
    ),
  ];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
  }

  void markAsRead(int index) {
    notifications[index].isRead = true;
  }
}

// ── Notifications Screen ──────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _manager = NotificationsManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1A1A)),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (_manager.unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFCC3333), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${_manager.unreadCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        centerTitle: true,
        actions: [
          if (_manager.unreadCount > 0)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() => _manager.markAllAsRead());
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Mark all read', style: TextStyle(fontSize: 13, color: Color(0xFFCC3333), fontWeight: FontWeight.w500)),
                ),
              ),
            ),
        ],
      ),
      body: _manager.notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 64, color: Color(0xFFCCCCCC)),
                  SizedBox(height: 12),
                  Text('No notifications yet', style: TextStyle(fontSize: 16, color: Color(0xFF888888))),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _manager.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _NotificationCard(
                  notification: _manager.notifications[index],
                  onTap: () {
                    setState(() => _manager.markAsRead(index));
                  },
                );
              },
            ),
    );
  }
}

// ── Notification Card ─────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xFFFFF8F8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: notification.isRead ? const Color(0xFFEEEEEE) : const Color(0xFFFFCCCC)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: notification.type.bgColor, borderRadius: BorderRadius.circular(12)),
                child: Icon(notification.type.icon, color: notification.type.iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: Color(0xFFCC3333), shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notification.message, style: const TextStyle(fontSize: 12, color: Color(0xFF888888), height: 1.4)),
                    const SizedBox(height: 6),
                    Text(notification.time, style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Notification Types ────────────────────────────────────────────────────────

enum NotifType { returnBook, approved, available, overdue }

extension NotifTypeExtension on NotifType {
  IconData get icon {
    switch (this) {
      case NotifType.returnBook: return Icons.assignment_return_outlined;
      case NotifType.approved: return Icons.check_circle_outline_rounded;
      case NotifType.available: return Icons.menu_book_rounded;
      case NotifType.overdue: return Icons.warning_amber_rounded;
    }
  }

  Color get bgColor {
    switch (this) {
      case NotifType.returnBook: return const Color(0xFFFFF0F0);
      case NotifType.approved: return const Color(0xFFE8F5E9);
      case NotifType.available: return const Color(0xFFE3F2FD);
      case NotifType.overdue: return const Color(0xFFFFF3E0);
    }
  }

  Color get iconColor {
    switch (this) {
      case NotifType.returnBook: return const Color(0xFFCC3333);
      case NotifType.approved: return const Color(0xFF2E7D32);
      case NotifType.available: return const Color(0xFF1565C0);
      case NotifType.overdue: return const Color(0xFFE65100);
    }
  }
}

// ── Data Model ────────────────────────────────────────────────────────────────

class NotificationItem {
  final NotifType type;
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationItem({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}