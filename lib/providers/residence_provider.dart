import 'package:flutter/foundation.dart';
import '../models/residence_model.dart';
import '../services/residence_service.dart';

class ResidenceProvider with ChangeNotifier {
  List<Residence> _residences = [];
  List<Residence> _filteredResidences = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Residence> get residences => _residences;
  List<Residence> get filteredResidences => _filteredResidences;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Load all residences
  Future<void> loadResidences() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('=== Residence Provider: Loading Residences ===');
      _residences = await ResidenceService.getResidences();
      print('Loaded ${_residences.length} residences');
      _filteredResidences = _residences;
      print('Filtered residences count: ${_filteredResidences.length}');
    } catch (e) {
      print('=== Residence Provider Error ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search residences
  Future<void> searchResidences(String query) async {
    if (query.isEmpty) {
      _filteredResidences = _residences;
    } else {
      try {
        _filteredResidences = await ResidenceService.searchResidences(query);
      } catch (e) {
        _error = e.toString();
      }
    }
    notifyListeners();
  }

  // Filter residences by price range
  void filterByPriceRange(double minPrice, double maxPrice) {
    _filteredResidences = _residences.where((residence) {
      return residence.price >= minPrice && residence.price <= maxPrice;
    }).toList();
    notifyListeners();
  }

  // Filter residences by amenities
  void filterByAmenities(List<String> amenities) {
    _filteredResidences = _residences.where((residence) {
      return amenities.every(
        (amenity) => residence.facilities.contains(amenity),
      );
    }).toList();
    notifyListeners();
  }

  // Sort residences
  void sortResidences(String sortBy) {
    switch (sortBy) {
      case 'price_low':
        _filteredResidences.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _filteredResidences.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        _filteredResidences.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'reviews':
        _filteredResidences.sort(
          (a, b) => b.totalReviews.compareTo(a.totalReviews),
        );
        break;
    }
    notifyListeners();
  }

  // Add new residence
  Future<void> addResidence(Map<String, dynamic> residenceData) async {
    try {
      final newResidence = await ResidenceService.createResidence(
        residenceData,
      );
      _residences.add(newResidence);
      _filteredResidences = _residences;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update residence
  Future<void> updateResidence(
    int id,
    Map<String, dynamic> residenceData,
  ) async {
    try {
      final updatedResidence = await ResidenceService.updateResidence(
        id,
        residenceData,
      );
      final index = _residences.indexWhere((r) => r.id == id);
      if (index != -1) {
        _residences[index] = updatedResidence;
        _filteredResidences = _residences;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete residence
  Future<void> deleteResidence(int id) async {
    try {
      final success = await ResidenceService.deleteResidence(id);
      if (success) {
        _residences.removeWhere((r) => r.id == id);
        _filteredResidences = _residences;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
