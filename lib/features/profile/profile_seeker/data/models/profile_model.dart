class ProfileModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? bio;
  final String? avatarUrl;
  final bool isVerified;
  final int role;
  final SeekerProfileModel? seekerProfile;
  final EmployerProfileModel? employerProfile;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.bio,
    this.avatarUrl,
    required this.isVerified,
    required this.role,
    this.seekerProfile,
    this.employerProfile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      isVerified: json['isVerified'] ?? false,
      // الباك إند بيرجع الـ role كـ String زي "Seeker"، هنحوله لرقم عشان يكمل مع اللوجيك بتاعنا
      role: json['role'] == 'Employer' ? 1 : 0,
      seekerProfile: json['seekerProfile'] != null
          ? SeekerProfileModel.fromJson(json['seekerProfile'])
          : null,
      employerProfile: json['employerProfile'] != null
          ? EmployerProfileModel.fromJson(json['employerProfile'])
          : null,
    );
  }
}

class SeekerProfileModel {
  final List<String> skills;
  final int experienceYears;
  final String? educationLevel;
  final String? linkedInUrl;
  final String? gitHubUrl;

  SeekerProfileModel({
    required this.skills,
    required this.experienceYears,
    this.educationLevel,
    this.linkedInUrl,
    this.gitHubUrl,
  });

  factory SeekerProfileModel.fromJson(Map<String, dynamic> json) {
    return SeekerProfileModel(
      skills: List<String>.from(json['skills'] ?? []),
      experienceYears: json['experienceYears'] ?? 0,
      educationLevel: json['educationLevel'],
      linkedInUrl: json['linkedInUrl'],
      gitHubUrl: json['gitHubUrl'],
    );
  }
}

class EmployerProfileModel {
  final String? companyName;
  final String? companySize;
  final String? industry;
  final String? companyLogoUrl;
  final String? website;

  EmployerProfileModel({
    this.companyName,
    this.companySize,
    this.industry,
    this.companyLogoUrl,
    this.website,
  });

  factory EmployerProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployerProfileModel(
      companyName: json['companyName'],
      companySize: json['companySize'],
      industry: json['industry'],
      companyLogoUrl: json['companyLogoUrl'],
      website: json['website'],
    );
  }
}
