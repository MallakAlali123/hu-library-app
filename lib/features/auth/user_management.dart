import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String details;
  final String role;
  final bool isActive;
  final String imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.details,
    required this.role,
    required this.isActive,
    required this.imageUrl,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      name: data['name'] ?? 'Unknown',
      details: data['details'] ?? 'No details',
      role: data['role'] ?? 'student',
      isActive: data['isActive'] ?? true,
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final Color primaryRed = const Color(0xFF8B0000);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedFilter = "All";
  String _searchQuery = "";

  Future<void> _toggleUserStatus(String userId, bool currentStatus) async {
    try {
      await _firestore.collection('users').doc(userId).update({'isActive': !currentStatus});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User status updated")),
        );
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    }
  }

  Stream<QuerySnapshot> _getUsersStream() {
    Query query = _firestore.collection('users');
    if (_selectedFilter == "Librarians") {
      query = query.where('role', isEqualTo: 'librarian');
    } else if (_selectedFilter == "Students") {
      query = query.where('role', isEqualTo: 'student');
    }
    return query.orderBy('name').snapshots();
  }

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final departmentController = TextEditingController();
    String selectedRole = 'student';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.person_add, color: primaryRed),
              const SizedBox(width: 8),
              const Text("Add User", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: "User ID (e.g. STU-001)",
                    prefixIcon: const Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: departmentController,
                  decoration: InputDecoration(
                    labelText: "Department / Title",
                    prefixIcon: const Icon(Icons.school_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRole,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      items: const [
                        DropdownMenuItem(value: 'student', child: Text('Student')),
                        DropdownMenuItem(value: 'librarian', child: Text('Librarian')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (value) {
                        setDialogState(() => selectedRole = value!);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (nameController.text.trim().isEmpty || idController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill Name and ID")),
                        );
                        return;
                      }
                      setDialogState(() => isLoading = true);
                      try {
                        await _firestore.collection('users').add({
                          'name': nameController.text.trim(),
                          'details': 'ID: ${idController.text.trim()} • ${departmentController.text.trim()}',
                          'role': selectedRole,
                          'isActive': true,
                          'imageUrl': '',
                        });
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("User added successfully ✅")),
                          );
                        }
                      } catch (e) {
                        setDialogState(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        // ✅ الإصلاح: زر الرجوع يرجع للـ Dashboard
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryRed),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
        title: Text("Academic Curator Admin",
            style: TextStyle(color: primaryRed, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
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
              child: Text("إدارة المستخدمين",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            const Text(
              "Manage academic credentials, system roles, and account access for the Hashemite University Digital Library.",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 15),
            _buildFilterTabs(),
            const SizedBox(height: 25),
            StreamBuilder<QuerySnapshot>(
              stream: _getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No users found.", style: TextStyle(color: Colors.grey)));
                }

                List<UserModel> users = snapshot.data!.docs
                    .map((doc) => UserModel.fromSnapshot(doc))
                    .toList();

                if (_searchQuery.isNotEmpty) {
                  users = users
                      .where((user) =>
                          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          user.details.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                }

                if (users.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No users match your search.",
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    Color roleBg = Colors.blue[100]!;
                    Color roleText = Colors.blue;

                    if (user.role == "librarian") {
                      roleBg = Colors.red[50]!;
                      roleText = Colors.red;
                    } else if (user.role == "admin") {
                      roleBg = Colors.purple[50]!;
                      roleText = Colors.purple;
                    }

                    String roleLabel = user.isActive ? user.role : "Deactivated";
                    Color displayRoleBg = user.isActive ? roleBg : Colors.grey[200]!;
                    Color displayRoleText = user.isActive ? roleText : Colors.grey;

                    return _buildUserCard(
                      id: user.id,
                      name: user.name,
                      details: user.details,
                      role: roleLabel,
                      roleBg: displayRoleBg,
                      roleText: displayRoleText,
                      imgUrl: user.imageUrl,
                      isDeactivated: !user.isActive,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      currentIndex: 3,
      onTap: (index) {
        switch (index) {
          // ✅ الإصلاح: التنقل بين صفحات المجموعة بـ go عادي
          case 0: context.go('/admin/system-settings'); break;
          case 1: context.go('/admin/logs'); break;
          case 2: context.go('/admin/roles'); break;
          case 3: break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "SETTINGS"),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "LOGS"),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: "ROLES"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "USERS"),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: "Search by name, ID, or email...",
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _filterTab("Librarians"),
          _filterTab("Students"),
          _filterTab("All"),
        ],
      ),
    );
  }

  Widget _filterTab(String label) {
    final isSelected = _selectedFilter == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? primaryRed : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required String id,
    required String name,
    required String details,
    required String role,
    required Color roleBg,
    required Color roleText,
    required String imgUrl,
    bool isDeactivated = false,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey[200]!)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
              child: imgUrl.isEmpty ? const Icon(Icons.person, size: 35) : null,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 15),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(details, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 15),
            const Text("ROLE",
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(color: roleBg, borderRadius: BorderRadius.circular(20)),
              child: Text(role,
                  style: TextStyle(color: roleText, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _toggleUserStatus(id, !isDeactivated),
                  child: Row(
                    children: [
                      Icon(isDeactivated ? Icons.undo : Icons.block, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(isDeactivated ? "Activate" : "Deactivate",
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.grey),
                      SizedBox(width: 5),
                      Text("Edit", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}