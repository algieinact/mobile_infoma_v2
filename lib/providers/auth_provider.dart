import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    final response = await ApiService.login(email, password);

    _setLoading(false);
    if (response.success) {
      // Save token and user data
      if (response.token != null) {
        await ApiService.saveToken(response.token!);
        if (response.user != null) {
          _user = response.user;
        }
      }
      notifyListeners();
      return true;
    } else {
      _setError(response.message);
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
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
      _setLoading(true);
      _setError(null);

      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
        university: university,
        major: major,
        graduationYear: graduationYear,
        gender: gender,
        birthDate: birthDate,
      );

      if (response.success && response.user != null) {
        _user = response.user;
        notifyListeners();
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await ApiService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUser() async {
    try {
      _setLoading(true);
      final user = await ApiService.getCurrentUser();
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load user: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final isAuth = await ApiService.isAuthenticated();
      if (isAuth) {
        await loadUser();
      } else {
        _user = null;
        notifyListeners();
      }
    } catch (e) {
      _user = null;
      notifyListeners();
    }
  }
}
