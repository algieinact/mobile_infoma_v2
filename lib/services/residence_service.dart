import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/residence_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class ResidenceService {
  // Get all residences
  static Future<List<Residence>> getResidences() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.residencesEndpoint}'),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> paginatedData = responseData['data'];
        final List<dynamic> residences = paginatedData['data'] ?? [];
        return residences.map((json) => Residence.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load residences');
      }
    } catch (e) {
      print('Error loading residences: $e');
      throw Exception('Error loading residences: $e');
    }
  }

  // Get residence by ID
  static Future<Residence> getResidenceById(int id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.residencesEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] == null ||
            responseData['data']['residence'] == null) {
          throw Exception('Residence data is null in the response');
        }
        return Residence.fromJson(responseData['data']['residence']);
      } else {
        throw Exception('Failed to load residence: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading residence: $e');
    }
  }

  // Create new residence
  static Future<Residence> createResidence(
    Map<String, dynamic> residenceData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.residencesEndpoint}'),
        headers: await ApiService.getHeaders(),
        body: jsonEncode(residenceData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (responseData['data'] == null) {
          throw Exception('Residence data is null in the response');
        }
        return Residence.fromJson(responseData['data']);
      } else if (response.statusCode == 422) {
        // Handle validation errors
        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final errorMessages =
              errors.values.expand((e) => e is List ? e : [e]).join('\n');
          throw Exception('Validation error: $errorMessages');
        }
        throw Exception(
            'Validation error: ${responseData['message'] ?? 'Unknown error'}');
      } else {
        throw Exception(
            'Failed to create residence: ${response.statusCode} - ${responseData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error creating residence: $e');
    }
  }

  // Update residence
  static Future<Residence> updateResidence(
    int id,
    Map<String, dynamic> residenceData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.residencesEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
        body: jsonEncode(residenceData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['data'] == null) {
          throw Exception('Residence data is null in the response');
        }
        return Residence.fromJson(responseData['data']);
      } else if (response.statusCode == 422) {
        // Handle validation errors
        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final errorMessages =
              errors.values.expand((e) => e is List ? e : [e]).join('\n');
          throw Exception('Validation error: $errorMessages');
        }
        throw Exception(
            'Validation error: ${responseData['message'] ?? 'Unknown error'}');
      } else {
        throw Exception(
            'Failed to update residence: ${response.statusCode} - ${responseData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error updating residence: $e');
    }
  }

  // Delete residence
  static Future<bool> deleteResidence(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.residencesEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Failed to delete residence: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error deleting residence: $e');
    }
  }

  // Search residences
  static Future<List<Residence>> searchResidences(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.residencesEndpoint}/search?q=$query',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Residence.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search residences');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
