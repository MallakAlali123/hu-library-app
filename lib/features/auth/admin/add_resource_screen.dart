import 'package:flutter/material.dart';

class AddResourceScreen extends StatelessWidget {
  const AddResourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // زر الرجوع للخلف
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8B0000)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "إضافة مورد جديد",
          style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF8B0000)),
            onPressed: () {
              // هنا سيتم إضافة كود الحفظ لاحقاً
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الكارت العلوي (بوابة القيمين)
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=1000'), 
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF8B0000).withOpacity(0.6),
                ),
                child: const Text(
                  "بوابة القيمين الأكاديميين",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // قسم اختيار نوع المورد
            const Text("نوع المورد", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTypeButton("كتاب", Icons.book, true),
                const SizedBox(width: 8),
                _buildTypeButton("بحث علمي", Icons.science, false),
                const SizedBox(width: 8),
                _buildTypeButton("مجلة", Icons.menu_book, false),
              ],
            ),
            const SizedBox(height: 25),

            // حقول الإدخال (Text Fields)
            _buildInputField("عنوان المورد", "أدخل العنوان الكامل للكتاب أو البحث", Icons.title),
            _buildInputField("المؤلف / الكاتب", "اسم الباحث أو الكاتب الرئيسي", Icons.person),
            _buildInputField("الناشر", "دار النشر أو المؤسسة الأكاديمية", Icons.business),
            _buildInputField("رقم التصنيف الدولي / ISBN", "000-0-00-000000-0", Icons.qr_code_scanner),
            _buildInputField("تاريخ النشر", "mm/dd/yyyy", Icons.calendar_today),
            _buildInputField("وصف مختصر", "ملخص عن المحتوى الأكاديمي للمورد...", Icons.description, maxLines: 3),

            const SizedBox(height: 25),

            // قسم تحميل الملف
            const Text("تحميل الملف أو الغلاف", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload, size: 45, color: Color(0xFF8B0000)),
                  const SizedBox(height: 10),
                  const Text("اسحب الملف هنا أو اضغط للتصفح", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("PDF, EPUB, JPG (MAX 50MB)", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // زر الإضافة النهائي
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("جاري معالجة البيانات...")),
                  );
                },
                icon: const Icon(Icons.add_box, color: Colors.white),
                label: const Text("إضافة إلى المكتبة", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B0000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // دالة بناء زر نوع المورد (كتاب، بحث، مجلة)
  Widget _buildTypeButton(String label, IconData icon, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B0000) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black87),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // دالة بناء حقل الإدخال
  Widget _buildInputField(String label, String hint, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // للمحاذاة من اليمين
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF8B0000))),
              const SizedBox(width: 8),
              Icon(icon, size: 20, color: const Color(0xFF8B0000)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: maxLines,
            textAlign: TextAlign.right, // الكتابة تبدأ من اليمين
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}