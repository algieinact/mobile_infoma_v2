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
        final data = jsonDecode(response.body)['data'];
        return Residence.fromJson(data);
      } else {
        throw Exception('Failed to load residence');
      }
    } catch (e) {
      throw Exception('Error: $e');
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

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        return Residence.fromJson(data);
      } else {
        throw Exception('Failed to create residence');
      }
    } catch (e) {
      throw Exception('Error: $e');
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Residence.fromJson(data);
      } else {
        throw Exception('Failed to update residence');
      }
    } catch (e) {
      throw Exception('Error: $e');
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

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
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
