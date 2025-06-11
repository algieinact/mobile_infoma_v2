import 'package:flutter/foundation.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class ActivityProvider with ChangeNotifier {
  List<Activity> _activities = [];
  List<Activity> _filteredActivities = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Activity> get activities => _activities;
  List<Activity> get filteredActivities => _filteredActivities;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Load all activities
  Future<void> loadActivities() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _activities = await ActivityService.getActivities();
      _filteredActivities = _activities;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new activity
  Future<void> createActivity(Map<String, dynamic> activityData) async {
    try {
      final newActivity = await ActivityService.createActivity(activityData);
      _activities.add(newActivity);
      _filteredActivities = _activities;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update activity
  Future<void> updateActivity(int id, Map<String, dynamic> activityData) async {
    try {
      // Check if user is admin
      final user = await ApiService.getCurrentUser();
      if (user?.role != AppConstants.providerRole) {
        throw Exception('Only admin can update activities');
      }

      final updatedActivity =
          await ActivityService.updateActivity(id, activityData);
      final index = _activities.indexWhere((a) => a.id == id);
      if (index != -1) {
        _activities[index] = updatedActivity;
        _filteredActivities = _activities;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete activity
  Future<void> deleteActivity(int id) async {
    try {
      // Check if user is admin
      final user = await ApiService.getCurrentUser();
      if (user?.role != AppConstants.providerRole) {
        throw Exception('Only admin can delete activities');
      }

      await ActivityService.deleteActivity(id);
      _activities.removeWhere((a) => a.id == id);
      _filteredActivities = _activities;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Search activities
  Future<void> searchActivities(String query) async {
    if (query.isEmpty) {
      _filteredActivities = _activities;
    } else {
      try {
        _filteredActivities = await ActivityService.searchActivities(query);
      } catch (e) {
        _error = e.toString();
      }
    }
    notifyListeners();
  }

  // Filter activities by category
  void filterByCategory(int categoryId) {
    _filteredActivities = _activities.where((activity) {
      return activity.categoryId == categoryId;
    }).toList();
    notifyListeners();
  }

  // Filter activities by price range
  void filterByPriceRange(double minPrice, double maxPrice) {
    _filteredActivities = _activities.where((activity) {
      return activity.price >= minPrice && activity.price <= maxPrice;
    }).toList();
    notifyListeners();
  }
}
