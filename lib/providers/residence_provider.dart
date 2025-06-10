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
    _setLoading(true);
    _setError('');

    try {
      final residences = await ResidenceService.getResidences();
      _residences = residences;
      _filteredResidences = residences;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Search residences
  void searchResidences(String query) {
    if (query.isEmpty) {
      _filteredResidences = _residences;
    } else {
      _filteredResidences = _residences.where((residence) {
        final name = residence.title.toLowerCase();
        final description = residence.description.toLowerCase();
        final address = residence.address.toLowerCase();
        final city = residence.city.toLowerCase();
        final province = residence.province.toLowerCase();
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            description.contains(searchQuery) ||
            address.contains(searchQuery) ||
            city.contains(searchQuery) ||
            province.contains(searchQuery);
      }).toList();
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
  Future<void> createResidence(Map<String, dynamic> residenceData) async {
    _setLoading(true);
    _setError('');

    try {
      final residence = await ResidenceService.createResidence(residenceData);
      _residences.add(residence);
      _filteredResidences = _residences;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update residence
  Future<void> updateResidence(
      int id, Map<String, dynamic> residenceData) async {
    _setLoading(true);
    _setError('');

    try {
      final updatedResidence =
          await ResidenceService.updateResidence(id, residenceData);
      final index = _residences.indexWhere((r) => r.id == id);
      if (index != -1) {
        _residences[index] = updatedResidence;
        _filteredResidences = _residences;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Delete residence
  Future<void> deleteResidence(int id) async {
    _setLoading(true);
    _setError('');

    try {
      await ResidenceService.deleteResidence(id);
      _residences.removeWhere((r) => r.id == id);
      _filteredResidences = _residences;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void filterResidences({
    String? type,
    String? gender,
    double? minPrice,
    double? maxPrice,
  }) {
    _filteredResidences = _residences.where((residence) {
      if (type != null && residence.type != type) return false;
      if (gender != null && residence.gender != gender) return false;
      if (minPrice != null && residence.price < minPrice) return false;
      if (maxPrice != null && residence.price > maxPrice) return false;
      return true;
    }).toList();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
