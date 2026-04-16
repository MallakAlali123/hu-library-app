import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  // متغير لتحديد نوع الحساب المختار (طالب، موظف، مكتبي)
  String selectedType = "طالب";
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "إضافة مستخدم جديد", 
          style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.bold)
        ),
        // تعديل: تفعيل زر الرجوع بذكاء
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8B0000)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
            child: Text(
              "HU", 
              style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.bold, fontSize: 18)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // منطقة صورة الملف الشخصي
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Icon(Icons.person_add_outlined, size: 45, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Color(0xFF8B0000), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Center(child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("رفع صورة المستخدم", style: TextStyle(color: Colors.grey, fontSize: 12)),
            )),
            
            const SizedBox(height: 30),

            // الحقول النصية
            _buildLabel("الاسم الكامل"),
            _buildTextField(hint: "أدخل الاسم الرباعي", icon: Icons.person_outline),

            _buildLabel("البريد الإلكتروني الجامعي"),
            _buildTextField(hint: "example@hu.edu.jo", icon: Icons.email_outlined),

            _buildLabel("الرقم الجامعي/الوظيفي"),
            _buildTextField(hint: "مثال: 20240001", icon: Icons.badge_outlined),

            const SizedBox(height: 20),
            _buildLabel("نوع الحساب"),
            const SizedBox(height: 10),
            
            // اختيار نوع الحساب (Account Type Selection)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAccountTypeCard("مكتبي", Icons.account_balance, selectedType == "مكتبي"),
                _buildAccountTypeCard("موظف", Icons.work_outline, selectedType == "موظف"),
                _buildAccountTypeCard("طالب", Icons.school_outlined, selectedType == "طالب"),
              ],
            ),

            const SizedBox(height: 20),
            _buildLabel("كلمة المرور الأولية"),
            _buildTextField(
              hint: "••••••••", 
              icon: Icons.lock_outline, 
              isPassword: true,
              suffix: IconButton(
                icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                onPressed: () => setState(() => obscureText = !obscureText),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text("يجب أن تحتوي على 8 رموز على الأقل", 
                style: TextStyle(color: Colors.grey, fontSize: 10)),
            ),

            const SizedBox(height: 40),

            // زر إنشاء الحساب
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                   // إظهار رسالة نجاح قبل العودة
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("تم إنشاء الحساب بنجاح"), backgroundColor: Colors.green),
                   );
                   Navigator.pop(context); 
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text("تأكيد إنشاء الحساب", 
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B0000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget مساعد للعنوان
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
    );
  }

  // Widget مساعد للحقول
  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false, Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        obscureText: isPassword ? obscureText : false,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF8B0000), size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  // Widget مساعد لاختيار نوع الحساب
  Widget _buildAccountTypeCard(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedType = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B0000) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF8B0000).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 28),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}