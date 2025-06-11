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
  final List<String>? images;
  final int totalRooms;
  final int availableRooms;
  final String genderType;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool isFeatured;
  final String? availableFrom;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    this.images,
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
      pricePeriod: json['price_period'],
      address: json['address'],
      city: json['city'],
      province: json['province'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      facilities: List<String>.from(json['facilities']),
      rules: List<String>.from(json['rules']),
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      totalRooms: json['total_rooms'],
      availableRooms: json['available_rooms'],
      genderType: json['gender_type'],
      rating: json['rating'] is String
          ? double.parse(json['rating'])
          : json['rating'].toDouble(),
      totalReviews: json['total_reviews'],
      isActive: json['is_active'],
      isFeatured: json['is_featured'],
      availableFrom: json['available_from'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
