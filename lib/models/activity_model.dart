import 'package:intl/intl.dart';

class Activity {
  final int id;
  final int providerId;
  final int categoryId;
  final String title;
  final String slug;
  final String description;
  final String type;
  final double price;
  final bool isFree;
  final String location;
  final String city;
  final String province;
  final String format;
  final String? meetingLink;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationDeadline;
  final String? requirements;
  final String? benefits;
  final List<String>? images;
  final int maxParticipants;
  final int currentParticipants;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Provider provider;
  final Category category;

  Activity({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.title,
    required this.slug,
    required this.description,
    required this.type,
    required this.price,
    required this.isFree,
    required this.location,
    required this.city,
    required this.province,
    required this.format,
    this.meetingLink,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    this.requirements,
    this.benefits,
    this.images,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    required this.isFeatured,
    this.createdAt,
    this.updatedAt,
    required this.provider,
    required this.category,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      providerId: json['provider_id'],
      categoryId: json['category_id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      type: json['type'],
      price: json['price'] is String
          ? double.parse(json['price'])
          : json['price'].toDouble(),
      isFree: json['is_free'],
      location: json['location'],
      city: json['city'],
      province: json['province'],
      format: json['format'],
      meetingLink: json['meeting_link'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      registrationDeadline: DateTime.parse(json['registration_deadline']),
      requirements: json['requirements'],
      benefits: json['benefits'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      maxParticipants: json['max_participants'],
      currentParticipants: json['current_participants'],
      rating: json['rating'] is String
          ? double.parse(json['rating'])
          : json['rating'].toDouble(),
      totalReviews: json['total_reviews'],
      isActive: json['is_active'],
      isFeatured: json['is_featured'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      provider: Provider.fromJson(json['provider']),
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'category_id': categoryId,
      'title': title,
      'slug': slug,
      'description': description,
      'type': type,
      'price': price,
      'is_free': isFree,
      'location': location,
      'city': city,
      'province': province,
      'format': format,
      'meeting_link': meetingLink,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'registration_deadline': registrationDeadline.toIso8601String(),
      'requirements': requirements,
      'benefits': benefits,
      'images': images,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_active': isActive,
      'is_featured': isFeatured,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'provider': provider.toJson(),
      'category': category.toJson(),
    };
  }
}

class Provider {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String role;
  final String phone;
  final String? address;
  final String? avatar;
  final DateTime? birthDate;
  final String? gender;
  final String? university;
  final String? major;
  final int? graduationYear;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Provider({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    required this.phone,
    this.address,
    this.avatar,
    this.birthDate,
    this.gender,
    this.university,
    this.major,
    this.graduationYear,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      gender: json['gender'],
      university: json['university'],
      major: json['major'],
      graduationYear: json['graduation_year'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'role': role,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'university': university,
      'major': major,
      'graduation_year': graduationYear,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String type;
  final String icon;
  final String color;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.type,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      type: json['type'],
      icon: json['icon'],
      color: json['color'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'type': type,
      'icon': icon,
      'color': color,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
