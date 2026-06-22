import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  // الألوان
  final Color primaryRed = const Color(0xFF8B0000);
  final Color bgGrey = const Color(0xFFFBFBFB);

  // متغيرات حالة الـ Switches
  bool isMaintenanceMode = false;
  bool isErrorReporting = true;
  bool isAcademicSync = true;

  // متغيرات حالة الـ Dropdowns
  String selectedLanguage = "(Arabic) العربية";
  String selectedTimezone = "Amman (GMT+03:00)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, size: 16, color: Colors.grey[600]),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hashemite University Admin",
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                Text("إعدادات النظام العامة",
                    style: TextStyle(
                        color: primaryRed,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  _showSnackBar("قائمة الخيارات قيد التطوير", Icons.menu),
              icon: const Icon(Icons.menu, color: Colors.black))
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDatabaseManagement(),
            const SizedBox(height: 25),
            _buildLocalizationSection(),
            const SizedBox(height: 25),
            _buildSystemHealth(),
            const SizedBox(height: 25),
            _buildQuickActions(),
            const SizedBox(height: 25),
            _buildGeneralConfiguration(),
            const SizedBox(height: 30),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لإظهار رسائل SnackBar
  void _showSnackBar(String message, [IconData? icon]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.white, size: 20),
            if (icon != null) const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: primaryRed,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // دالة مساعدة لإظهار نوافذ التأكيد Alert Dialog
  void _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(title,
              style: TextStyle(
                  color: isDestructive ? primaryRed : Colors.black)),
          content: Text(message,
              textAlign: TextAlign.right, style: const TextStyle(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDestructive ? primaryRed : Colors.grey[800],
              ),
              child:
                  Text(confirmText, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatabaseManagement() {
    return _buildSectionCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20)),
                child: const Text("OPERATIONAL",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              const Row(children: [
                Text("Database Management  ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.storage, size: 18)
              ]),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Manage the core repository of the Academic Curator. Ensure data integrity through scheduled backups and controlled restoration processes.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          _buildDbButton(
            title: "Initialize",
            sub: "Wipe & Reset",
            icon: Icons.refresh,
            textColor: Colors.black,
            onTap: () => _showConfirmationDialog(
              title: "تهيئة قاعدة البيانات",
              message:
                  "هل أنت متأكد؟ سيتم مسح جميع البيانات الحالية وإعادة تعيين النظام بالكامل.",
              confirmText: "مسح الكل",
              isDestructive: true,
              onConfirm: () =>
                  _showSnackBar("تم إعادة تعيين قاعدة البيانات بنجاح", Icons.check_circle),
            ),
          ),
          const SizedBox(height: 10),
          _buildDbButton(
            title: "Backup Now",
            sub: "Full Snapshot",
            icon: Icons.cloud_upload,
            textColor: Colors.white,
            isPrimary: true,
            onTap: () => _showConfirmationDialog(
              title: "نسخ احتياطي",
              message: "سيتم إنشاء نسخة احتياطية كاملة للنظام الآن. قد يستغرق ذلك بضع دقائق.",
              confirmText: "بدء النسخ",
              onConfirm: () =>
                  _showSnackBar("جارئ إنشاء النسخة الاحتياطية...", Icons.cloud_upload),
            ),
          ),
          const SizedBox(height: 10),
          _buildDbButton(
            title: "Restore",
            sub: "Point in Time",
            icon: Icons.history,
            textColor: Colors.black,
            onTap: () => _showConfirmationDialog(
              title: "استعادة البيانات",
              message: "سيتم استبدال البيانات الحالية بالبيانات الموجودة في آخر نقطة حفظ.",
              confirmText: "استعادة الآن",
              isDestructive: true,
              onConfirm: () =>
                  _showSnackBar("تم استعادة البيانات بنجاح", Icons.history),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => _showSnackBar("فتح سجل النسخ الاحتياطي...", Icons.history),
            child: _buildLastBackupInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildDbButton({
    required String title,
    required String sub,
    required IconData icon,
    required Color textColor,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? primaryRed : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: isPrimary ? null : Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: isPrimary ? Colors.white : primaryRed, size: 20),
            Text(title,
                style:
                    TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            Text(sub,
                style: TextStyle(
                    color: isPrimary ? Colors.white70 : Colors.grey,
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalizationSection() {
    return _buildSectionCard(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Localization & Language  ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.public, size: 18)
            ],
          ),
          const SizedBox(height: 15),
          _buildDropdownLabel("Default Interface Language"),
          GestureDetector(
            onTap: () => _showLanguageBottomSheet(),
            child: _buildDropdownField(selectedLanguage),
          ),
          const SizedBox(height: 15),
          _buildDropdownLabel("Primary Timezone"),
          GestureDetector(
            onTap: () => _showTimezoneBottomSheet(),
            child: _buildDropdownField(selectedTimezone),
          ),
        ],
      ),
    );
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("اختر اللغة",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(),
            ListTile(
              title: const Text("(Arabic) العربية"),
              trailing: selectedLanguage == "(Arabic) العربية"
                  ? const Icon(Icons.check, color: Color(0xFF8B0000))
                  : null,
              onTap: () {
                setState(() => selectedLanguage = "(Arabic) العربية");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("(English) English"),
              trailing: selectedLanguage == "(English) English"
                  ? const Icon(Icons.check, color: Color(0xFF8B0000))
                  : null,
              onTap: () {
                setState(() => selectedLanguage = "(English) English");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTimezoneBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("اختر المنطقة الزمنية",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(),
            ListTile(
              title: const Text("Amman (GMT+03:00)"),
              trailing: selectedTimezone == "Amman (GMT+03:00)"
                  ? const Icon(Icons.check, color: Color(0xFF8B0000))
                  : null,
              onTap: () {
                setState(() => selectedTimezone = "Amman (GMT+03:00)");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("New York (GMT-05:00)"),
              trailing: selectedTimezone == "New York (GMT-05:00)"
                  ? const Icon(Icons.check, color: Color(0xFF8B0000))
                  : null,
              onTap: () {
                setState(() => selectedTimezone = "New York (GMT-05:00)");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("London (GMT+00:00)"),
              trailing: selectedTimezone == "London (GMT+00:00)"
                  ? const Icon(Icons.check, color: Color(0xFF8B0000))
                  : null,
              onTap: () {
                setState(() => selectedTimezone = "London (GMT+00:00)");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealth() {
    return _buildSectionCard(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("System Health  ",
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          const SizedBox(height: 15),
          _buildHealthRow("Server Status", "Operational", Icons.check_circle,
              Colors.green),
          _buildHealthRow("Memory Usage", "GB 1.6 / 4.2", Icons.check_circle,
              Colors.green),
          _buildHealthRow(
              "Storage Space", "Full 82%", Icons.warning, Colors.orange),
          const SizedBox(height: 10),
          LinearProgressIndicator(
              value: 0.82,
              backgroundColor: Colors.grey[200],
              color: primaryRed,
              minHeight: 8),
          const SizedBox(height: 5),
          const Text(
              "Storage capacity approaching limit. Consider archiving old logs.",
              style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[100]!)),
      child: child,
    );
  }

  Widget _buildHealthRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Row(children: [
            Text(label),
            const SizedBox(width: 10),
            Icon(icon, color: color, size: 18)
          ]),
        ],
      ),
    );
  }

  Widget _buildDropdownLabel(String text) => Align(
      alignment: Alignment.centerRight,
      child:
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)));

  Widget _buildDropdownField(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            Text(text)
          ]),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.red[50]!.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const Align(
              alignment: Alignment.centerRight,
              child: Text("Quick Actions",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => _showConfirmationDialog(
              title: "مسح الكاش",
              message: "سيتم حذف الملفات المؤقتة لتسريع النظام.",
              confirmText: "مسح",
              onConfirm: () =>
                  _showSnackBar("تم مسح الكاش بنجاح", Icons.bolt),
            ),
            child: _buildActionItem("Clear System Cache", Icons.bolt),
          ),
          InkWell(
            onTap: () =>
                _showSnackBar("جارئ تشغيل خدمة الفهرسة...", Icons.search),
            child: _buildActionItem("Run Indexing Service", Icons.search),
          ),
          InkWell(
            onTap: () =>
                _showSnackBar("جارئ تحميل ملف السجل...", Icons.download),
            child: _buildActionItem("Download System Log", Icons.download),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(icon, size: 18, color: Colors.grey)
        ],
      ),
    );
  }

  Widget _buildGeneralConfiguration() {
    return Column(
      children: [
        const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("General Configuration  ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.tune)
            ]),
        _buildSwitchTile(
            title: "Maintenance Mode",
            sub: "Temporarily disable user access while performing updates.",
            val: isMaintenanceMode, 
            onChanged: (val) {
          String action = val ? "تفعيل" : "إيقاف";
          _showConfirmationDialog(
            title: "$action وضع الصيانة",
            message: val
                ? "سيتم تسجيل خروج جميع المستخدمين ومنع الوصول للنظام."
                : "سيتم إعادة تفعيل الوصول للنظام للمستخدمين.",
            confirmText: "تأكيد",
            onConfirm: () => setState(() => isMaintenanceMode = val),
          );
        }),
        _buildSwitchTile(
            title: "Automatic Error Reporting",
            sub: "Send anonymous diagnostic data to the development team.",
            val: isErrorReporting,
            onChanged: (val) => setState(() => isErrorReporting = val)),
        _buildSwitchTile(
            title: "Academic Term Sync",
            sub: "Sync repository collections with the university's central academic calendar.",
            val: isAcademicSync,
            onChanged: (val) => setState(() => isAcademicSync = val)),
      ],
    );
  }

  // ✅ تم تعديل هذه الدالة لتصبح متغيراتها مسماة (Named Parameters)
  Widget _buildSwitchTile({
    required String title,
    required String sub,
    required bool val,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(title,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(sub,
          textAlign: TextAlign.right, style: const TextStyle(fontSize: 11)),
      leading: Switch(
          value: val, onChanged: onChanged, activeColor: primaryRed),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
                onPressed: () =>
                    _showSnackBar("تم التراجع عن التعديلات", Icons.undo),
                child: const Text("Discard Changes",
                    style: TextStyle(color: Colors.black)))),
        const SizedBox(width: 15),
        Expanded(
            child: ElevatedButton(
                onPressed: () => _showSnackBar(
                    "تم حفظ الإعدادات بنجاح", Icons.check_circle),
                style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
                child: const Text("Save Configuration",
                    style: TextStyle(color: Colors.white)))),
      ],
    );
  }

  Widget _buildLastBackupInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.grey, size: 18),
          SizedBox(width: 10),
          Expanded(
              child: Text("Last automated backup: Today, 04:00 AM",
                  style: TextStyle(fontSize: 10))),
          Text("View History",
              style:
                  TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            context.go('/admin/logs');
            break;
          case 2:
            context.go('/admin/roles');
            break;
          case 3:
            context.go('/admin/users');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: "SETTINGS"),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "LOGS"),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: "ROLES"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "USERS"),
      ],
    );
  }
}