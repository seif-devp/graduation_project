class SeekerEntity {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final bool isLightMode;

  SeekerEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.isLightMode,
  });

  // بنعمل copyWith عشان نقدر نغير الـ Theme بسهولة
  SeekerEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    bool? isLightMode,
  }) {
    return SeekerEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      isLightMode: isLightMode ?? this.isLightMode,
    );
  }
}