import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  String? get token => data?['token'];
  User? get user => data?['user'] != null ? User.fromJson(data!['user']) : null;
}
