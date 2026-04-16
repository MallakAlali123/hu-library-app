import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  // متغير لتخزين التصنيف المختار
  String selectedCategory = "علمي";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // تعديل: تفعيل زر الرجوع
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB01116)),
          onPressed: () {
            Navigator.pop(context); // للرجوع للشاشة السابقة
          },
        ),
        title: const Text(
          "إضافة كتاب جديد",
          style: TextStyle(color: Color(0xFFB01116), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "HU",
              style: TextStyle(color: Color(0xFFB01116), fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // للمحاذاة من اليمين (عربي)
          children: [
            const Text(
              "أدخل تفاصيل المورد الأكاديمي الجديد لإضافته إلى مقتنيات الجامعة الهاشمية.",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            
            // منطقة رفع الغلاف
            Center(
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: InkWell( // لجعل المنطقة قابلة للضغط
                  onTap: () {
                    // هنا تضع كود فتح معرض الصور لاحقاً
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 45, color: const Color(0xFFB01116)),
                      const SizedBox(height: 10),
                      const Text(
                        "رفع غلاف الكتاب",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // الحقول النصية
            _buildInputField("عنوان الكتاب", "مثال: مقدمة في الخوارزميات"),
            _buildInputField("اسم المؤلف", "اسم الكاتب الكامل"),
            _buildInputField("رقم ISBN", "X-XXXX-XXXX-X-978"),
            
            const SizedBox(height: 10),
            const Text(
              "التصنيف الأكاديمي",
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB01116)),
            ),
            const SizedBox(height: 10),
            
            // أزرار التصنيفات
            Directionality(
              textDirection: TextDirection.rtl, // لترتيب الـ Chips من اليمين
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: ["علمي", "إنساني", "فنون", "هندسة", "طب"].map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    selectedColor: const Color(0xFFB01116),
                    labelStyle: TextStyle(
                      color: selectedCategory == cat ? Colors.white : Colors.black87,
                      fontWeight: selectedCategory == cat ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 15),
            _buildInputField("سنة النشر", "2026"),
            _buildInputField("وصف الكتاب / ملخص", "اكتب ملخصاً موجزاً عن محتوى الكتاب...", maxLines: 3),
            
            const SizedBox(height: 30),
            
            // زر الإضافة
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // كود إضافة الكتاب
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("جاري إضافة الكتاب للمكتبة...")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB01116),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "إضافة الكتاب للمكتبة",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "\"العلم صيد والكتابة قيد\"",
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget مساعد لبناء الحقول بسرعة
  Widget _buildInputField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: maxLines,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFB01116), width: 1.5),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ],
      ),
    );
  }
}