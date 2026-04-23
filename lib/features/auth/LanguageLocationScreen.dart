import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageLocationScreen extends StatefulWidget {
  const LanguageLocationScreen({super.key});

  @override
  State<LanguageLocationScreen> createState() => _LanguageLocationScreenState();
}

class _LanguageLocationScreenState extends State<LanguageLocationScreen> {
  // ✅ تغيير اللون إلى أحمر
  final Color primaryColor = const Color(0xFFB01E1E); 

  String _selectedLang = "English";
  String _selectedLocation = "Zarqa, Jordan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/admin/account'),
        ),
        title: const Text("Language & Location", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Language Card
            _buildSelectionCard(
              Icons.language,
              "App Language",
              "Select your preferred language for interface.",
              primaryColor, // ✅ اللون أحمر
              [
                _buildRadioOption("English", _selectedLang, (val) => setState(() => _selectedLang = val)),
                _buildRadioOption("Arabic", _selectedLang, (val) => setState(() => _selectedLang = val)),
              ],
            ),
            const SizedBox(height: 20),
            // Location Card
            _buildSelectionCard(
              Icons.location_on,
              "Library Location",
              "Update main library location settings.",
              primaryColor, // ✅ اللون أحمر
              [
                // ✅ تم حذف عمان وإربيد، وبقي الزرقاء فقط (Zarqa)
                _buildRadioOption("Zarqa, Jordan", _selectedLocation, (val) => setState(() => _selectedLocation = val)),
              ],
            ),
             const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Preferences Saved"), backgroundColor: Colors.red),
                   );
                   context.pop();
                },
                // ✅ لون الزر أحمر
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(IconData icon, String title, String desc, Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, String groupValue, Function(String) onChanged) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: title,
      groupValue: groupValue,
    
      activeColor: primaryColor,
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}