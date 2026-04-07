import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: SystemLogsScreen(),
      debugShowCheckedModeBanner: false,
    ));

class SystemLogsScreen extends StatelessWidget {
  const SystemLogsScreen({super.key});

  final Color primaryRed = const Color(0xFF8B0000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            _buildLibrarianBadge(),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Academic Curator Admin", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                Text("Librarian Administrator", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.black))],
      ),
      bottomNavigationBar: _buildBottomNav(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("نشاط النظام", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("مراقبة السجلات والأنشطة اللحظية داخل النظام الأكاديمي.", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 25),
            _buildSearchAndFilterSection(),
            const SizedBox(height: 25),
            _buildStatCard("إجمالي النشاط اليوم", "1,284", Icons.trending_up, Colors.red[50]!, "+12%"),
            _buildStatCard("محاولات وصول مرفوضة", "3", Icons.security, Colors.blue[50]!, null),
            _buildStatCard("آخر نسخة احتياطية", "ناجحة (منذ ساعتين)", Icons.cloud_done, Colors.green[50]!, null),
            const SizedBox(height: 30),
            _buildLogsHeader(),
            _buildLogItem(
              title: "تعديل صلاحيات المستخدم",
              subtitle: "قام المسؤول Admin_Hashemite بتحديث صلاحيات المستخدم #USR-9920 من 'طالب' إلى 'باحث'.",
              time: "منذ 5 دقائق",
              icon: Icons.admin_panel_settings,
              iconBg: Colors.red[50]!,
              id: "882731",
              ip: "192.168.1.1",
            ),
            _buildLogItem(
              title: "إضافة مصدر جديد",
              subtitle: "تمت إضافة كتاب 'الذكاء الاصطناعي في التعليم' بواسطة Librarian_Sarah.",
              time: "منذ 24 دقيقة",
              icon: Icons.library_add,
              iconBg: Colors.blue[50]!,
              id: "882690",
              ip: "192.168.1.42",
            ),
            _buildLogItem(
              title: "اكتمال النسخ الاحتياطي",
              subtitle: "أتم النظام عملية النسخ الاحتياطي الدوري لقاعدة البيانات بنجاح. الحجم: 2.4 GB.",
              time: "منذ ساعتين",
              icon: Icons.sync,
              iconBg: Colors.green[50]!,
              status: "SUCCESS",
              statusColor: Colors.green,
            ),
            _buildLogItem(
              title: "محاولة دخول فاشلة",
              subtitle: "تم رصد محاولة دخول فاشلة متكررة (3 مرات) للمستخدم #USR-1102 من موقع جغرافي غير معتاد.",
              time: "منذ 3 ساعات",
              icon: Icons.warning_amber_rounded,
              iconBg: Colors.orange[50]!,
              status: "WARNING",
              statusColor: Colors.orange,
              ip: "103.22.45.1",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryRed,
        child: const Icon(Icons.download, color: Colors.white),
      ),
    );
  }

  // أدوات بناء الواجهة
  Widget _buildStatCard(String title, String value, IconData icon, Color bg, String? trend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (trend != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(10)), child: Text(trend, style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, size: 40, color: primaryRed.withOpacity(0.8)),
        ],
      ),
    );
  }

  Widget _buildLogItem({required String title, required String subtitle, required String time, required IconData icon, required Color iconBg, String? id, String? ip, String? status, Color? statusColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    const SizedBox(width: 10),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(subtitle, textAlign: TextAlign.right, style: const TextStyle(color: Colors.black87, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status != null) Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(width: 10),
                    if (ip != null) Text("IP: $ip", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    const SizedBox(width: 10),
                    if (id != null) Text("ID: $id", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: primaryRed, size: 20)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: primaryRed, borderRadius: BorderRadius.circular(8)), child: const Row(children: [Icon(Icons.search, color: Colors.white, size: 18), SizedBox(width: 5), Text("بحث", style: TextStyle(color: Colors.white))])),
        const SizedBox(width: 10),
        Expanded(child: _buildFilterDropdown("أخر 24 ساعة", Icons.calendar_today)),
        const SizedBox(width: 10),
        Expanded(child: _buildFilterDropdown("كل العمليات", Icons.filter_list)),
      ],
    );
  }

  Widget _buildFilterDropdown(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey), Text(text, style: const TextStyle(fontSize: 12)), Icon(icon, size: 16, color: Colors.grey)]),
    );
  }

  Widget _buildLibrarianBadge() => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryRed, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20));

  Widget _buildLogsHeader() => const Padding(padding: EdgeInsets.only(bottom: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.refresh, color: Colors.grey, size: 20), SizedBox(width: 15), Icon(Icons.more_vert, color: Colors.grey)]), Text("سجل العمليات الأخير", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]));

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "SETTINGS"),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "LOGS"),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: "ROLES"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "USERS"),
      ],
    );
  }
}