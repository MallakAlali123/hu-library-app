import 'package:flutter/material.dart';
import 'add_user_screen.dart'; 

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          // قللنا الـ Padding العلوي قليلاً ليتناسب مع وجود زر الرجوع
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // --- التعديل الجديد: سطر العنوان مع زر الرجوع ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر الرجوع في جهة اليسار
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF8B0000), size: 22),
                  ),
                  // العنوان في جهة اليمين
                  const Text(
                    "إدارة المستخدمين",
                    style: TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF8B0000),
                    ),
                  ),
                ],
              ),
              // -------------------------------------------
              
              const SizedBox(height: 6),
              const Text(
                "إدارة بيانات الاعتماد الأكاديمية، وأدوار النظام، والوصول إلى حسابات المكتبة الرقمية للجامعة الهاشمية.",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 25),
              
              // زر إضافة مستخدم جديد
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddUserScreen()),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 20),
                  label: const Text(
                    "إضافة مستخدم جديد", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // حقل البحث
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "البحث بالاسم، الرقم الجامعي، أو البريد الإلكتروني...",
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF8B0000)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // أزرار الفلترة
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true, 
                child: Row(
                  children: [
                    _buildFilterChip("أدمن", false),
                    const SizedBox(width: 8),
                    _buildFilterChip("أمين مكتبة", false),
                    const SizedBox(width: 8),
                    _buildFilterChip("طلاب", false),
                    const SizedBox(width: 8),
                    _buildFilterChip("الكل", true),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // قائمة المستخدمين
              _buildUserCard("أحمد الزهراني", "20234051029", "علم الحاسوب", "طالب", Colors.blue[50]!, Colors.blue),
              _buildUserCard("د. سارة منصور", "LIB-8820", "كبير القيمين", "أمين مكتبة", Colors.red[50]!, Colors.red),
              _buildUserCard("ليلى إبراهيم", "20214051012", "كلية الطب", "غير نشط", Colors.grey[200]!, Colors.grey),
              _buildUserCard("عمر خالد", "20244012005", "الهندسة", "طالب", Colors.blue[50]!, Colors.blue),
              
              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }

  // مكوّن بطاقة المستخدم
  Widget _buildUserCard(String name, String id, String dept, String role, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 8, 
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("ID: $id • $dept", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 15),
              CircleAvatar(
                radius: 25,
                backgroundColor: bgColor.withOpacity(0.5),
                child: Icon(Icons.person, color: textColor.withOpacity(0.8)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: Colors.blue, size: 22), 
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.block_flipped, color: Colors.red, size: 20), 
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              Chip(
                label: Text(
                  role, 
                  style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                backgroundColor: bgColor,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8B0000) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}