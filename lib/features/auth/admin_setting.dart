import 'package:flutter/material.dart';
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl, // للغة العربية
        child: AdminSettingsScreen(),
      ),
    ));

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  final Color primaryRed = const Color(0xFFB01E1E);
  final Color bgGrey = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("إعدادات المسؤول", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildSectionHeader("إعدادات الحساب", Icons.manage_accounts_outlined),
            _buildSettingsItem("تغيير كلمة المرور", Icons.lock_outline),
            _buildSettingsItem("تفضيلات الإشعارات", Icons.notifications_none),
            _buildSettingsItem("اللغة والموقع", Icons.language),
            const SizedBox(height: 20),
            _buildSectionHeader("إدارة المستخدمين", Icons.group_outlined),
            _buildSettingsItem("إضافة مستخدم جديد", Icons.person_add_alt),
            _buildSettingsItem("الأذونات والصلاحيات", Icons.rule),
            _buildSettingsItem("سجل نشاطات المشرفين", Icons.history_edu),
            const SizedBox(height: 20),
            _buildAdvancedMetrics(),
            const SizedBox(height: 20),
            _buildSectionHeader("الدعم الفني", Icons.support_agent),
            _buildSettingsItem("فتح تذكرة دعم", Icons.help_outline),
            _buildSettingsItem("دليل استخدام النظام", Icons.menu_book),
            const SizedBox(height: 20),
            _buildSystemStatus(),
            const SizedBox(height: 30),
            _buildLogoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // كارت الملف الشخصي
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // استبدلها بصورتك
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.verified, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text("أحمد محمود - Library admin",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag("HU-88291", Icons.badge_outlined),
              const SizedBox(width: 10),
              _buildTag("عضو منذ ٢٠١٥", Icons.calendar_today_outlined),
            ],
          ),
          const SizedBox(height: 20),
         ElevatedButton(
  onPressed: () {
    // أضف الأوامر هنا لاحقاً
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryRed,
    minimumSize: const Size(200, 45),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Text(
    "تعديل الملف الشخصي",
    style: TextStyle(color: Colors.white),
  ),
)
          
        ],
      ),
    );
  }

  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // عناصر القوائم
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: primaryRed, size: 20),
          ),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }

  // قسم الإحصائيات المتقدمة
  Widget _buildAdvancedMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("إحصائيات متقدمة", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("عرض التقرير الكامل", style: TextStyle(color: primaryRed, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 15),
          _buildMetricItem("إجمالي الإعارات", "١٢,٤٥٠", "+١٢٪ هذا الشهر", Colors.green),
          _buildMetricItem("الزوار النشطون", "٣,٨٩٢", "+٥٪ هذا الأسبوع", Colors.green),
          _buildMetricItem("الكتب الجديدة", "٤٢٨", "خلال الـ ٣٠ يوم الماضية", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, String trend, Color trendColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(trend, style: TextStyle(color: trendColor, fontSize: 10)),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  // حالة النظام
  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildStatusRow("حالة النظام", "مستقر", Colors.green),
          const Divider(),
          _buildStatusRow("إصدار النظام", "v2.4.1-stable", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Row(
          children: [
            if (color == Colors.green) Icon(Icons.circle, color: color, size: 10),
            const SizedBox(width: 5),
            Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text("تسجيل الخروج من النظام", style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}