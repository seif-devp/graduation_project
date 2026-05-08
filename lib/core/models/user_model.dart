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
      role: _parseRole(json['role']),
      isVerified: json['isVerified'] ?? false,
    );
  }

  static int _parseRole(dynamic role) {
    if (role is int) return role;
    if (role is String) {
      switch (role.toLowerCase()) {
        case 'jobseeker': return 0;
        case 'employer':  return 1;
        case 'admin':     return 2;
        default:          return 0;
      }
    }
    return 0;
  }
}