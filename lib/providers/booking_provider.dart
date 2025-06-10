import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  List<Booking> _filteredBookings = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Booking> get bookings => _bookings;
  List<Booking> get filteredBookings => _filteredBookings;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Get active bookings
  List<Booking> get activeBookings =>
      _bookings.where((booking) => booking.isActive).toList();

  // Get upcoming bookings
  List<Booking> get upcomingBookings =>
      _bookings.where((booking) => booking.isUpcoming).toList();

  // Get completed bookings
  List<Booking> get completedBookings =>
      _bookings.where((booking) => booking.isCompleted).toList();

  // Load all bookings
  Future<void> loadBookings() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _bookings = await BookingService.getUserBookings();
      _filteredBookings = _bookings;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter bookings by status
  void filterByStatus(String status) {
    switch (status) {
      case 'active':
        _filteredBookings = activeBookings;
        break;
      case 'upcoming':
        _filteredBookings = upcomingBookings;
        break;
      case 'completed':
        _filteredBookings = completedBookings;
        break;
      default:
        _filteredBookings = _bookings;
    }
    notifyListeners();
  }

  // Create new booking
  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final newBooking = await BookingService.createBooking(bookingData);
      _bookings.add(newBooking);
      _filteredBookings = _bookings;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update booking
  Future<void> updateBooking(int id, Map<String, dynamic> bookingData) async {
    try {
      final updatedBooking = await BookingService.updateBooking(
        id,
        bookingData,
      );
      final index = _bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bookings[index] = updatedBooking;
        _filteredBookings = _bookings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Cancel booking
  Future<void> cancelBooking(int id) async {
    try {
      final success = await BookingService.cancelBooking(id);
      if (success) {
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          _bookings[index] = Booking(
            id: _bookings[index].id,
            residenceId: _bookings[index].residenceId,
            residenceName: _bookings[index].residenceName,
            residenceAddress: _bookings[index].residenceAddress,
            userId: _bookings[index].userId,
            userName: _bookings[index].userName,
            checkIn: _bookings[index].checkIn,
            checkOut: _bookings[index].checkOut,
            totalPrice: _bookings[index].totalPrice,
            status: 'cancelled',
            notes: _bookings[index].notes,
            createdAt: _bookings[index].createdAt,
            updatedAt: _bookings[index].updatedAt,
          );
          _filteredBookings = _bookings;
          notifyListeners();
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get bookings by residence
  Future<List<Booking>> getBookingsByResidence(int residenceId) async {
    try {
      return await BookingService.getBookingsByResidence(residenceId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
