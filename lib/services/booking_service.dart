import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class BookingService {
  // Get all bookings for current user
  static Future<List<Booking>> getUserBookings() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.bookingsEndpoint}'),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get booking by ID
  static Future<Booking> getBookingById(int id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.bookingsEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Booking.fromJson(data);
      } else {
        throw Exception('Failed to load booking');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create new booking
  static Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.bookingsEndpoint}'),
        headers: await ApiService.getHeaders(),
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        return Booking.fromJson(data);
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update booking
  static Future<Booking> updateBooking(
    int id,
    Map<String, dynamic> bookingData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.bookingsEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Booking.fromJson(data);
      } else {
        throw Exception('Failed to update booking');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Cancel booking
  static Future<bool> cancelBooking(int id) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.bookingsEndpoint}/$id/cancel',
        ),
        headers: await ApiService.getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get bookings by status
  static Future<List<Booking>> getBookingsByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.bookingsEndpoint}/status/$status',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get bookings by residence ID
  static Future<List<Booking>> getBookingsByResidence(int residenceId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.bookingsEndpoint}/residence/$residenceId',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
