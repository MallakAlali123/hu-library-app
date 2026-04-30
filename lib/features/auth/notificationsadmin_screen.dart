import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsAdminScreen extends StatelessWidget {
  const NotificationsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Color primaryRed = const Color(0xFF8B0000);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // استخدام navigator بدلاً من GoRouter للعودة البسيطة
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Notifications", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {
              // يمكنك هنا إضافة كود لفتح نافذة لإضافة إشعار جديد
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Add Notification Feature")),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // جلب البيانات من المجموعة notifications
        stream: _firestore.collection('notifications').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          // 1. حالة التحميل
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. حالة الخطأ
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 10),
                  Text("Error: ${snapshot.error}"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // طباعة الخطأ في الكونسول للمساعدة
                      debugPrint("Firestore Error: ${snapshot.error}");
                    },
                    child: const Text("Print Error Log"),
                  )
                ],
              ),
            );
          }

          // 3. حالة لا توجد بيانات
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No notifications found.", style: TextStyle(color: Colors.grey)),
            );
          }

          // 4. عرض البيانات
          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notif = notifications[index].data() as Map<String, dynamic>;
              var notifId = notifications[index].id;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryRed.withOpacity(0.1),
                    child: Icon(Icons.notifications, color: primaryRed),
                  ),
                  title: Text(
                    notif['title'] ?? 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(notif['message'] ?? 'No Message'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () {
                      _deleteNotification(notifId);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // دالة للحذف
  Future<void> _deleteNotification(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').doc(docId).delete();
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }
}