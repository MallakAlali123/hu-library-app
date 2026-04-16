import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'book_suggestions_screen.dart';
import 'reservation_requests_screen.dart'; // تم تفعيل الاستيراد هنا
import 'system_logs_screen.dart';
import 'admin_settings_screen.dart';
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  // نبدأ من الداشبورد (رقم 2) كافتراضي عند فتح التطبيق
  int _currentIndex = 2; 

  // قائمة الشاشات المرتبطة بالشريط - الآن جميعها مفعلة
  final List<Widget> _screens = [
    const BookSuggestionsScreen(),   // الشاشة رقم 0
    const ReservationRequestsScreen(), // الشاشة رقم 1 (تم تحديثها من النص المؤقت)
    const AdminDashboard(), 
    const SystemLogsScreen(), 
    const AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // يعرض الشاشة الحالية بناءً على الاختيار من الشريط السفلي
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ), 
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          border: const Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF8B0000),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // تحديث الواجهة عند الضغط
            });
          },
          items: [
            _buildNavItem(Icons.lightbulb_outline, "SUGGESTIONS", 0),
            _buildNavItem(Icons.menu_book, "REQUESTS", 1),
            _buildNavItem(Icons.dashboard_outlined, "DASHBOARD", 2),
            _buildNavItem(Icons.receipt_long_outlined, "system log screen", 3),
            _buildNavItem(Icons.settings_outlined, "ACCOUNT", 4),
            
          ],
        ),
      ),
    );
  }

  // Widget مساعد لبناء عناصر الشريط السفلي بنفس تصميمك المرتفع
  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B0000) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
          size: 26,
        ),
      ),
      label: label,
    );
  }
}