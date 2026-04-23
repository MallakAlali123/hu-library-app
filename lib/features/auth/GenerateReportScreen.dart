import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenerateReportScreen extends StatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  State<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  final Color primaryRed = const Color(0xFFB01E1E);
  
  String _selectedMonth = "APR";
  String _selectedFormat = "PDF";
  String _reportType = "Circulation Report";

  final List<String> _months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

  // ✅ حل الرجوع الآمن
  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/admin'); // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack, // ✅ تم التعديل
        ),
        title: const Text("Generate Report", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Month", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _months.map((month) {
                      final isSelected = _selectedMonth == month;
                      return InkWell(
                        onTap: () => setState(() => _selectedMonth = month),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryRed : Colors.grey[100],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            month,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description, color: primaryRed),
                      const SizedBox(width: 10),
                      const Text("Report Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildRadioOption("Circulation Report", "Total loans and returns.", _reportType, (val) => setState(() => _reportType = val)),
                  _buildRadioOption("Overdue Books", "Books not returned on time.", _reportType, (val) => setState(() => _reportType = val)),
                  _buildRadioOption("User Activity", "Most active students.", _reportType, (val) => setState(() => _reportType = val)),
                  const SizedBox(height: 20),
                  const Text("Export Format", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      Radio<String>(
                        value: "PDF",
                        groupValue: _selectedFormat,
                        activeColor: primaryRed,
                        onChanged: (val) => setState(() => _selectedFormat = val!),
                      ),
                      const Text("PDF Document"),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: "Excel",
                        groupValue: _selectedFormat,
                        activeColor: primaryRed,
                        onChanged: (val) => setState(() => _selectedFormat = val!),
                      ),
                      const Text("Excel Sheet"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Generating $_reportType for $_selectedMonth..."),
                      backgroundColor: primaryRed,
                    ),
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text("Download Report", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, String desc, String groupValue, Function(String) onChanged) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: title,
      groupValue: groupValue,
      activeColor: primaryRed,
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}