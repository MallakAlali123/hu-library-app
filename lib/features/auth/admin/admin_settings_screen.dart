import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Admin Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // بطاقة الملف الشخصي العلوي
            _buildProfileHeader(),
            
            const SizedBox(height: 24),

            // قسم إعدادات الحساب
            _buildSettingsGroup(
              title: "إعدادات الحساب",
              icon: Icons.manage_accounts,
              items: [
                _buildSettingsItem("تغيير كلمة المرور", Icons.lock_outline),
                _buildSettingsItem("تفضيلات الإشعارات", Icons.notifications_none),
                _buildSettingsItem("اللغة والموقع", Icons.language),
              ],
            ),

            const SizedBox(height: 16),

            // قسم إدارة المستخدمين
            _buildSettingsGroup(
              title: "إدارة المستخدمين",
              icon: Icons.group_outlined,
              items: [
                _buildSettingsItem("إضافة مستخدم جديد", Icons.person_add_alt),
                _buildSettingsItem("الأذونات والصلاحيات", Icons.rule),
                _buildSettingsItem("سجل نشاطات المشرفين", Icons.history),
              ],
            ),

            const SizedBox(height: 16),

            // قسم إحصائيات متقدمة
            _buildStatisticsSection(),

            const SizedBox(height: 16),

            // قسم الدعم الفني
            _buildSettingsGroup(
              title: "الدعم الفني",
              icon: Icons.support_agent,
              items: [
                _buildSettingsItem("فتح تذكرة دعم", Icons.help_outline),
                _buildSettingsItem("دليل استخدام النظام", Icons.book_outlined),
              ],
            ),

            const SizedBox(height: 16),

            // حالة النظام والإصدار
            _buildSystemStatus(),

            const SizedBox(height: 24),

            // زر تسجيل الخروج
            _buildLogoutButton(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Header الخاص بالملف الشخصي
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text("د. أحمد الهاشمي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("أمين مكتبة - الإدارة العليا", style: TextStyle(color: Colors.red, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallInfoChip(Icons.badge, "HU-88291"),
              const SizedBox(width: 8),
              _buildSmallInfoChip(Icons.calendar_month, "عضو منذ 2015"),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB01116),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("تعديل الملف الشخصي", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildSmallInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: Colors.grey[600]),
        ],
      ),
    );
  }

  // بناء مجموعة إعدادات
  Widget _buildSettingsGroup({required String title, required IconData icon, required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ListTile(
            title: Text(title, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Colors.red[900]),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon) {
    return ListTile(
      leading: const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
      title: Text(title, textAlign: TextAlign.right),
      trailing: Icon(icon, size: 20, color: Colors.grey[600]),
      onTap: () {},
    );
  }

  // قسم الإحصائيات (البطاقات الثلاث)
  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("عرض التقرير الكامل", style: TextStyle(color: Colors.red, fontSize: 12)),
              Row(
                children: [
                  const Text("إحصائيات متقدمة", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Icon(Icons.bar_chart, color: Colors.red[900]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatCard("إجمالي الإعارات", "١٢,٤٥٠", "+١٢% هذا الشهر", Colors.green),
          _buildStatCard("الزوار النشطون", "٣,٨٩٢", "+٥% هذا الأسبوع", Colors.green),
          _buildStatCard("الكتب الجديدة", "٤٢٨", "خلال الـ ٣٠ يوم الماضية", Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String sub, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(sub, style: TextStyle(fontSize: 10, color: color)),
            ],
          ),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildRowInfo("حالة النظام", "مستقر", isStatus: true),
          const SizedBox(height: 8),
          _buildRowInfo("إصدار النظام", "v2.4.1-stable"),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isStatus 
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [Text("مستقر", style: TextStyle(color: Colors.green, fontSize: 12)), SizedBox(width: 4), Icon(Icons.circle, size: 8, color: Colors.green)]),
            )
          : Text(value, style: const TextStyle(color: Colors.grey)),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("تسجيل الخروج من النظام", style: TextStyle(color: Colors.red)),
          SizedBox(width: 8),
          Icon(Icons.logout, color: Colors.red),
        ],
      ),
    );
  }
}