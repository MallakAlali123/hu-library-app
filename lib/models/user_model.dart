class UserModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final int fines;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.fines,
  });
}