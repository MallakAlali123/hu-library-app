import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.ltr, 
          child: UserManagementScreen(),
        ),
      ),
    );

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  final Color primaryRed = const Color(0xFF8B0000); // اللون الأحمر الداكن المستخدم في الصورة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Image.network('https://via.placeholder.com/40', height: 30), // شعار التطبيق
            const SizedBox(width: 10),
            Text("Academic Curator Admin", style: TextStyle(color: primaryRed, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu, color: primaryRed))],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryRed,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text("إدارة المستخدمين", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            const Text(
              "Manage academic credentials, system roles, and account access for the Hashemite University Digital Library.",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildAddUserButton(),
            const SizedBox(height: 25),
            _buildSearchBar(),
            const SizedBox(height: 15),
            _buildFilterTabs(),
            const SizedBox(height: 25),
            // قائمة المستخدمين
            _buildUserCard("Ahmed Al-Zahrani", "ID: 20234051029 • Computer Science", "Student", Colors.blue[100]!, Colors.blue, "https://via.placeholder.com/150"),
            _buildUserCard("Dr. Sara Mansour", "ID: LIB-8820 • Senior Curator", "Librarian", Colors.red[50]!, Colors.red, "https://via.placeholder.com/150"),
            _buildUserCard("Layla Ibrahim", "ID: 20214051012 • Faculty of Medicine", "Deactivated", Colors.grey[200]!, Colors.grey, "https://via.placeholder.com/150", isDeactivated: true),
            _buildUserCard("Omar Khalid", "ID: 20244012005 • Engineering", "Student", Colors.blue[100]!, Colors.blue, "https://via.placeholder.com/150"),
          ],
        ),
      ),
    );
  }

  Widget _buildAddUserButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        label: const Text("Add New User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "...Search by name, ID, or email",
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _filterTab("Librarians", false),
          _filterTab("Students", false),
          _filterTab("All", true),
        ],
      ),
    );
  }

  Widget _filterTab(String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : [],
        ),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? primaryRed : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildUserCard(String name, String details, String role, Color roleBg, Color roleText, String imgUrl, {bool isDeactivated = false}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey[200]!)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 35, backgroundImage: NetworkImage(imgUrl)),
            const SizedBox(height: 15),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(details, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 15),
            const Text("ROLE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(color: roleBg, borderRadius: BorderRadius.circular(20)),
              child: Text(role, style: TextStyle(color: roleText, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isDeactivated ? Icons.undo : Icons.block, color: Colors.grey),
                const SizedBox(width: 30),
                const Icon(Icons.edit, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      currentIndex: 3,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "SETTINGS"),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "LOGS"),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: "ROLES"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "USERS"),
      ],
    );
  }
}