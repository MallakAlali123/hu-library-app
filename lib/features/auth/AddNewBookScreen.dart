import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BookModel {
  final String title;
  final String author;
  final String isbn;
  final String category;

  BookModel({
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
  });
}

class AddNewBookScreen extends StatefulWidget {
  const AddNewBookScreen({super.key});

  @override
  State<AddNewBookScreen> createState() => _AddNewBookScreenState();
}

class _AddNewBookScreenState extends State<AddNewBookScreen> {
  final Color primaryRed = const Color(0xFFB01E1E);
  final Color bgGrey = const Color(0xFFF8F9FA);
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _isbnController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
    _isbnController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _goBack() {
   
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go('/admin');
    }
  }

  Future<void> _submitBook() async {
    if (!_formKey.currentState!.validate()) {
      try {
       
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Book Added Successfully ✅"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _goBack();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error adding book: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack,
        ),
        title: const Text("Add New Book", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // صورة الغلاف
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 50, color: Color.fromARGB(255, 206, 14, 14)),
                      const SizedBox(height: 10),
                      Text("Tap to upload cover image", style: TextStyle(color: Color.fromARGB(255, 206, 14, 14))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // الحقول
              _buildInputField("Book Title", "Enter book title", _titleController),
              const SizedBox(height: 15),
              _buildInputField("Author", "Enter author name", _authorController),
              const SizedBox(height: 15),
              _buildInputField("ISBN", "Enter ISBN number", _isbnController),
              const SizedBox(height: 15),
              _buildInputField("Category", "e.g. Engineering, Science", _categoryController),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Add Book", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "This field is required";
            return null;
          },
        ),
      ],
    );
  }
}