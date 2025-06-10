import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import '../utils/constants.dart';

class ApiService {
  static String get baseUrl => AppConstants.baseUrl;
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String logoutEndpoint = '/logout';
  static const String userEndpoint = '/user';

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get headers with token
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Login
  static Future<AuthResponse> login(String email, String password) async {
    try {
      print('=== API Request Details ===');
      print('Base URL: $baseUrl');
      print('Login Endpoint: $loginEndpoint');
      print('Full URL: ${baseUrl}${loginEndpoint}');
      print('Headers: ${await getHeaders()}');
      print('Request Body: {"email": "$email", "password": "*****"}');

      final response = await http
          .post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: await getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Request timed out after 10 seconds');
          throw TimeoutException('Request timed out');
        },
      );

      print('=== API Response Details ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(data);
        if (authResponse.token != null) {
          await saveToken(authResponse.token!);
          print('Token saved successfully');
        }
        return authResponse;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      print('=== API Error Details ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      if (e is SocketException) {
        print('Socket Error: ${e.message}');
        print('Address: ${e.address}');
        print('Port: ${e.port}');
      }
      return AuthResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Register
  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? role,
    String? phone,
    String? university,
    String? major,
    int? graduationYear,
    String? gender,
    String? birthDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: await getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (role != null) 'role': role,
          if (phone != null) 'phone': phone,
          if (university != null) 'university': university,
          if (major != null) 'major': major,
          if (graduationYear != null) 'graduation_year': graduationYear,
          if (gender != null) 'gender': gender,
          if (birthDate != null) 'birth_date': birthDate,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(data);
        if (authResponse.token != null) {
          await saveToken(authResponse.token!);
        }
        return authResponse;
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Logout
  static Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$logoutEndpoint'),
        headers: await getHeaders(),
      );

      await removeToken();
      return response.statusCode == 200;
    } catch (e) {
      await removeToken();
      return false;
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$userEndpoint'),
        headers: await getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user'] ?? data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;

    final user = await getCurrentUser();
    return user != null;
  }
}
