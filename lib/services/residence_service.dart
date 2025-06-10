import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/residence_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class ResidenceService {
  // Get all residences
  static Future<List<Residence>> getResidences() async {
    try {
      print('=== Residence Service: Getting Residences ===');
      print('URL: ${AppConstants.baseUrl}${AppConstants.residencesEndpoint}');

      final headers = await ApiService.getHeaders();
      print('Headers: $headers');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.residencesEndpoint}'),
        headers: headers,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Parsed Response Data: $responseData');

        if (responseData['success'] == true && responseData['data'] != null) {
          print('Data field content: ${responseData['data']}');

          // Handle the data based on its type
          if (responseData['data'] is List) {
            final List<dynamic> residences = responseData['data'];
            print('Found ${residences.length} residences in list format');
            return residences.map((json) => Residence.fromJson(json)).toList();
          } else if (responseData['data'] is Map) {
            // Check if the data is nested under a 'residences' key
            if (responseData['data'].containsKey('residences')) {
              final List<dynamic> residences =
                  responseData['data']['residences'];
              print('Found ${residences.length} residences in nested format');
              return residences
                  .map((json) => Residence.fromJson(json))
                  .toList();
            } else {
              // If data is a single residence object
              print('Found single residence object');
              return [Residence.fromJson(responseData['data'])];
            }
          } else {
            print(
                'Unexpected data format: ${responseData['data'].runtimeType}');
            throw Exception('Unexpected data format in response');
          }
        } else {
          print('Invalid response format or missing data');
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
        throw Exception('Failed to load residences: ${response.body}');
      }
    } catch (e) {
      print('=== Residence Service Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
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
