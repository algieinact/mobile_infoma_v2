class AppConstants {
  // API Configuration
  static String get baseUrl {
    if (identical(0, 0.0)) {
      return 'http://127.0.0.1:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  // Endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String logoutEndpoint = '/logout';
  static const String userEndpoint = '/user';
  static const String residencesEndpoint = '/residences';
  static const String activitiesEndpoint = '/activities';
  static const String bookingsEndpoint = '/bookings';
  static const String reviewsEndpoint = '/reviews';
  static const String bookmarksEndpoint = '/bookmarks';
  static const String notificationsEndpoint = '/notifications';
  static const String transactionsEndpoint = '/transactions';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // User Roles
  static const String customerRole = 'customer';
  static const String providerRole = 'provider';

  // App Info
  static const String appName = 'Residence Booking';
  static const String appVersion = '1.0.0';
}
