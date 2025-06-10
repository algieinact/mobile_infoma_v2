class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String role;
  final String? phone;
  final String? address;
  final String? avatar;
  final String? birthDate;
  final String? gender;
  final String? university;
  final String? major;
  final String? graduationYear;
  final bool isActive;
  final String? rememberToken;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    this.phone,
    this.address,
    this.avatar,
    this.birthDate,
    this.gender,
    this.university,
    this.major,
    this.graduationYear,
    required this.isActive,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at']?.toString(),
      role: json['role'] ?? 'user',
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      avatar: json['avatar']?.toString(),
      birthDate: json['birth_date']?.toString(),
      gender: json['gender']?.toString(),
      university: json['university']?.toString(),
      major: json['major']?.toString(),
      graduationYear: json['graduation_year']?.toString(),
      isActive: json['is_active'] == 1,
      rememberToken: json['remember_token']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt,
        'role': role,
        'phone': phone,
        'address': address,
        'avatar': avatar,
        'birth_date': birthDate,
        'gender': gender,
        'university': university,
        'major': major,
        'graduation_year': graduationYear,
        'is_active': isActive ? 1 : 0,
        'remember_token': rememberToken,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
