import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class ActivityService {
  // Get all activities
  static Future<List<Activity>> getActivities() async {
    try {
      print('=== Activity Service: Getting Activities ===');
      print('URL: ${AppConstants.baseUrl}${AppConstants.activitiesEndpoint}');

      final headers = await ApiService.getHeaders();
      print('Headers: $headers');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.activitiesEndpoint}'),
        headers: headers,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          final Map<String, dynamic> paginatedData = responseData['data'];
          final List<dynamic> activities = paginatedData['data'] ?? [];
          print('Found ${activities.length} activities');
          return activities.map((json) => Activity.fromJson(json)).toList();
        } else {
          throw Exception(
              'Failed to load activities: ${responseData['message']}');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      print('=== Activity Service Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      throw Exception('Error loading activities: $e');
    }
  }

  // Get activity by ID
  static Future<Activity> getActivityById(int id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.activitiesEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Activity.fromJson(data);
      } else {
        throw Exception('Failed to load activity');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create new activity
  static Future<Activity> createActivity(
    Map<String, dynamic> activityData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.activitiesEndpoint}'),
        headers: await ApiService.getHeaders(),
        body: jsonEncode(activityData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['data'];
        return Activity.fromJson(data);
      } else {
        throw Exception('Failed to create activity');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update activity
  static Future<Activity> updateActivity(
    int id,
    Map<String, dynamic> activityData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.activitiesEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
        body: jsonEncode(activityData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Activity.fromJson(data);
      } else {
        throw Exception('Failed to update activity');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete activity
  static Future<bool> deleteActivity(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.activitiesEndpoint}/$id',
        ),
        headers: await ApiService.getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Search activities
  static Future<List<Activity>> searchActivities(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.activitiesEndpoint}/search?q=$query',
        ),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search activities');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
