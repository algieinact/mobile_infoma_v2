class Booking {
  final int id;
  final int residenceId;
  final String residenceName;
  final String residenceAddress;
  final String userId;
  final String userName;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  Booking({
    required this.id,
    required this.residenceId,
    required this.residenceName,
    required this.residenceAddress,
    required this.userId,
    required this.userName,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      residenceId: json['residence_id'] is int
          ? json['residence_id']
          : int.tryParse(json['residence_id'].toString()) ?? 0,
      residenceName: json['residence_name'] ?? '',
      residenceAddress: json['residence']['address'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'] ?? '',
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      totalPrice:
          (json['total_price'] is num) ? json['total_price'].toDouble() : 0.0,
      status: json['status'] ?? 'pending',
      notes: json['notes']?.toString(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'residence_id': residenceId,
        'residence_name': residenceName,
        'residence_address': residenceAddress,
        'user_id': userId,
        'user_name': userName,
        'check_in': checkIn.toIso8601String(),
        'check_out': checkOut.toIso8601String(),
        'total_price': totalPrice,
        'status': status,
        'notes': notes,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  // Calculate duration in months
  int get durationInMonths {
    return (checkOut.difference(checkIn).inDays / 30).round();
  }

  // Check if booking is active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(checkIn) && now.isBefore(checkOut);
  }

  // Check if booking is upcoming
  bool get isUpcoming {
    return DateTime.now().isBefore(checkIn);
  }

  // Check if booking is completed
  bool get isCompleted {
    return DateTime.now().isAfter(checkOut);
  }

  bool get isCancelled => status == 'cancelled';
}
