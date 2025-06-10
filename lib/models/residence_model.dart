class Residence {
  final int id;
  final int providerId;
  final int categoryId;
  final String title;
  final String slug;
  final String description;
  final String address;
  final String city;
  final String province;
  final double price;
  final int totalRooms;
  final int availableRooms;
  final String type;
  final String gender;
  final List<String> facilities;
  final List<String> images;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Residence({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.title,
    required this.slug,
    required this.description,
    required this.address,
    required this.city,
    required this.province,
    required this.price,
    required this.totalRooms,
    required this.availableRooms,
    required this.type,
    required this.gender,
    required this.facilities,
    required this.images,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    required this.isFeatured,
    this.createdAt,
    this.updatedAt,
  });

  factory Residence.fromJson(Map<String, dynamic> json) {
    return Residence(
      id: json['id'],
      providerId: json['provider_id'],
      categoryId: json['category_id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      province: json['province'],
      price: json['price'] is String
          ? double.parse(json['price'])
          : json['price'].toDouble(),
      totalRooms: json['total_rooms'],
      availableRooms: json['available_rooms'],
      type: json['type'],
      gender: json['gender'],
      facilities: List<String>.from(json['facilities']),
      images: List<String>.from(json['images']),
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
      'address': address,
      'city': city,
      'province': province,
      'price': price,
      'total_rooms': totalRooms,
      'available_rooms': availableRooms,
      'type': type,
      'gender': gender,
      'facilities': facilities,
      'images': images,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_active': isActive,
      'is_featured': isFeatured,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
