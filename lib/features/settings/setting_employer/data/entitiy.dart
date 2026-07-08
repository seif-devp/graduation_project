class UserEntity {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final bool isLightMode;
  final String? avatarUrl; // 🔴 ضفنا مسار الصورة هنا

  final String? companyName;
  final String? companySize;
  final String? industry;
  final String? website;

  UserEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.isLightMode,
    this.avatarUrl,
    this.companyName,
    this.companySize,
    this.industry,
    this.website,
  });

  UserEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    bool? isLightMode,
    String? avatarUrl,
    String? companyName,
    String? companySize,
    String? industry,
    String? website,
  }) {
    return UserEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      isLightMode: isLightMode ?? this.isLightMode,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      companyName: companyName ?? this.companyName,
      companySize: companySize ?? this.companySize,
      industry: industry ?? this.industry,
      website: website ?? this.website,
    );
  }
}