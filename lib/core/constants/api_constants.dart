class ApiConstants {
  // Base URL - Update this with your actual backend URL
  static const String baseUrl = 'http://192.168.1.4:8000/api/v1';

  // For Android Emulator to access localhost
  // static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // For real device (use your computer's IP address)
  // static const String baseUrl = 'http://192.168.1.100:8000/api/v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String me = '/auth/me';

  // Attendance Endpoints
  static const String attendanceLocations = '/attendance/locations';
  static const String checkIn = '/attendance/check-in';
  static const String checkOut = '/attendance/check-out';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceToday = '/attendance/today';
  static const String attendanceStatus = '/attendance/status';
  static const String validateLocation = '/attendance/validate-location';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Map<String, String> authHeaders(String token) => {
        ...headers,
        'Authorization': 'Bearer $token',
      };
}
