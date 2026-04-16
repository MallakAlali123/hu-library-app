import 'package:flutter/material.dart';

class SystemLogsScreen extends StatelessWidget {
  const SystemLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text("Academic Curator Admin", 
          style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.bold, fontSize: 16)),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Librarian", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                Text("Administrator", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
          CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("نشاط النظام", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("مراقبة السجلات والأنشطة اللحظية داخل النظام الأكاديمي.", 
              style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),

            // الفلاتر والبحث
            _buildFilters(),

            const SizedBox(height: 20),

            // بطاقات الإحصائيات السريعة
            _buildStatCard("إجمالي النشاط اليوم", "1,284", "+12%", Icons.trending_up, Colors.red),
            _buildStatCard("محاولات وصول مرفوضة", "3", "", Icons.shield_outlined, Colors.blueGrey),
            _buildStatCard("آخر نسخة احتياطية", "ناجحة (منذ ساعتين)", "", Icons.cloud_done_outlined, Colors.blue),

            const SizedBox(height: 24),

            // سجل العمليات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.refresh, color: Colors.grey),
                const Text("سجل العمليات الأخير", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildLogItem(
              title: "تعديل صلاحيات المستخدم",
              desc: "قام المسؤول Admin_Hashemite بتحديث صلاحيات المستخدم #USR-9920 من 'طالب' إلى 'باحث'.",
              time: "منذ 5 دقائق",
              icon: Icons.admin_panel_settings,
              color: Colors.red[50]!,
            ),
            _buildLogItem(
              title: "إضافة مصدر جديد",
              desc: "تمت إضافة كتاب 'الذكاء الاصطناعي في التعليم' بواسطة Librarian_Sarah.",
              time: "منذ 24 دقيقة",
              icon: Icons.post_add,
              color: Colors.blue[50]!,
            ),
            _buildLogItem(
              title: "اكتمال النسخ الاحتياطي",
              desc: "تمت عملية النسخ الدوري بنجاح. الحجم: 2.4 GB.",
              time: "منذ ساعتين",
              icon: Icons.backup_outlined,
              color: Colors.green[50]!,
              status: "SUCCESS",
              statusColor: Colors.green,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF8B0000),
        child: const Icon(Icons.file_download, color: Colors.white),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(child: ElevatedButton(onPressed: () {}, 
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0000)),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("بحث", style: TextStyle(color: Colors.white)), SizedBox(width: 8), Icon(Icons.search, size: 16, color: Colors.white)]))),
        const SizedBox(width: 8),
        _buildDropdown("أخر 24 ساعة"),
        const SizedBox(width: 8),
        _buildDropdown("كل العمليات"),
      ],
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Row(children: [const Icon(Icons.arrow_drop_down, size: 18), const SizedBox(width: 4), Text(text, style: const TextStyle(fontSize: 11))]),
    );
  }

  Widget _buildStatCard(String title, String value, String change, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        subtitle: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: Icon(icon, color: color, size: 30),
        trailing: change.isNotEmpty ? Text(change, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)) : null,
      ),
    );
  }

  Widget _buildLogItem({required String title, required String desc, required String time, required IconData icon, required Color color, String? status, Color? statusColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                if (status != null) ...[
                  const SizedBox(height: 8),
                  Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                ]
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.black87, size: 20),
          ),
        ],
      ),
    );
  }
}