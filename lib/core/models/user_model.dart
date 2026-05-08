class UserModel {
  final String id;
  final String email;
  final String name;
  final int role;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 0,
      isVerified: json['isVerified'] ?? false,
    );
  }
}