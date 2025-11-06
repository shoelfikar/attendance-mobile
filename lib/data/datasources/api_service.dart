import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  late final Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: ApiConstants.headers,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add token to request if available
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          if (error.response?.statusCode == 401) {
            // Token expired or unauthorized
            // You can trigger logout or token refresh here
          }
          return handler.next(error);
        },
      ),
    );
  }

  void setToken(String? token) {
    _token = token;
  }

  // Auth APIs
  Future<Response> login(String email, String password) async {
    return await _dio.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    return await _dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone': phone,
      },
    );
  }

  Future<Response> logout() async {
    return await _dio.post(ApiConstants.logout);
  }

  Future<Response> getCurrentUser() async {
    return await _dio.get(ApiConstants.me);
  }

  // Attendance Location APIs
  Future<Response> getNearbyLocations({
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) async {
    return await _dio.get(
      ApiConstants.attendanceLocations,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        if (radiusKm != null) 'radius_km': radiusKm,
      },
    );
  }

  // Attendance APIs
  Future<Response> checkIn({
    required int locationId,
    required double latitude,
    required double longitude,
    String? notes,
    String? photoUrl,
  }) async {
    return await _dio.post(
      ApiConstants.checkIn,
      data: {
        'location_id': locationId,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
        'photo_url': photoUrl,
      },
    );
  }

  Future<Response> checkOut({
    required int attendanceId,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    return await _dio.post(
      ApiConstants.checkOut,
      data: {
        'attendance_id': attendanceId,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
      },
    );
  }

  Future<Response> getAttendanceHistory({
    int? page,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _dio.get(
      ApiConstants.attendanceHistory,
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      },
    );
  }

  Future<Response> getTodayAttendance() async {
    return await _dio.get(ApiConstants.attendanceToday);
  }

  Future<Response> getAttendanceStatus() async {
    return await _dio.get(ApiConstants.attendanceStatus);
  }

  Future<Response> validateLocation({
    required int locationId,
    required double latitude,
    required double longitude,
  }) async {
    return await _dio.post(
      ApiConstants.validateLocation,
      data: {
        'location_id': locationId,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }
}
