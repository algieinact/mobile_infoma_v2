class Residence {
  final int id;
  final int providerId;
  final int categoryId;
  final String title;
  final String slug;
  final String description;
  final String type;
  final double price;
  final String pricePeriod;
  final String address;
  final String city;
  final String province;
  final double? latitude;
  final double? longitude;
  final List<String> facilities;
  final List<String> rules;
  final List<String> images;
  final int totalRooms;
  final int availableRooms;
  final String genderType;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool isFeatured;
  final String? availableFrom;
  final String createdAt;
  final String updatedAt;

  Residence({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.title,
    required this.slug,
    required this.description,
    required this.type,
    required this.price,
    required this.pricePeriod,
    required this.address,
    required this.city,
    required this.province,
    this.latitude,
    this.longitude,
    required this.facilities,
    required this.rules,
    required this.images,
    required this.totalRooms,
    required this.availableRooms,
    required this.genderType,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    required this.isFeatured,
    this.availableFrom,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Residence.fromJson(Map<String, dynamic> json) {
    return Residence(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      providerId: json['provider_id'] is int
          ? json['provider_id']
          : int.tryParse(json['provider_id'].toString()) ?? 0,
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id'].toString()) ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
      pricePeriod: json['price_period'] ?? 'monthly',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      facilities: List<String>.from(json['facilities'] ?? []),
      rules: List<String>.from(json['rules'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      totalRooms: json['total_rooms'] ?? 0,
      availableRooms: json['available_rooms'] ?? 0,
      genderType: json['gender_type'] ?? 'mixed',
      rating: (json['rating'] is num) ? json['rating'].toDouble() : 0.0,
      totalReviews: json['total_reviews'] ?? 0,
      isActive: json['is_active'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      availableFrom: json['available_from'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'provider_id': providerId,
        'category_id': categoryId,
        'title': title,
        'slug': slug,
        'description': description,
        'type': type,
        'price': price,
        'price_period': pricePeriod,
        'address': address,
        'city': city,
        'province': province,
        'latitude': latitude,
        'longitude': longitude,
        'facilities': facilities,
        'rules': rules,
        'images': images,
        'total_rooms': totalRooms,
        'available_rooms': availableRooms,
        'gender_type': genderType,
        'rating': rating,
        'total_reviews': totalReviews,
        'is_active': isActive,
        'is_featured': isFeatured,
        'available_from': availableFrom,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
