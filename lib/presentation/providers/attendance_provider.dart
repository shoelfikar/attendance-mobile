import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/datasources/api_service.dart';
import '../../data/datasources/location_service.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/attendance_location_model.dart';

enum AttendanceStatus {
  notCheckedIn,
  checkedIn,
  checkedOut,
}

class AttendanceProvider with ChangeNotifier {
  final ApiService _apiService;
  final LocationService _locationService;

  bool _isLoading = false;
  String? _errorMessage;

  AttendanceModel? _todayAttendance;
  List<AttendanceModel> _attendanceHistory = [];
  List<AttendanceLocationModel> _nearbyLocations = [];
  Position? _currentPosition;

  AttendanceProvider({
    required ApiService apiService,
    required LocationService locationService,
  })  : _apiService = apiService,
        _locationService = locationService;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AttendanceModel? get todayAttendance => _todayAttendance;
  List<AttendanceModel> get attendanceHistory => _attendanceHistory;
  List<AttendanceLocationModel> get nearbyLocations => _nearbyLocations;
  Position? get currentPosition => _currentPosition;

  AttendanceStatus get attendanceStatus {
    if (_todayAttendance == null) {
      return AttendanceStatus.notCheckedIn;
    } else if (_todayAttendance!.checkOutTime == null) {
      return AttendanceStatus.checkedIn;
    } else {
      return AttendanceStatus.checkedOut;
    }
  }

  // Get current location
  Future<bool> getCurrentLocation() async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _currentPosition = await _locationService.getCurrentPosition();

      if (_currentPosition != null) {
        // Get nearby locations
        await getNearbyLocations(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Get nearby attendance locations
  Future<void> getNearbyLocations(
    double latitude,
    double longitude, {
    double radiusKm = 5.0, // Default 5 km radius
  }) async {
    try {
      print('DEBUG: Getting nearby locations...');
      print('DEBUG: User location: $latitude, $longitude');
      print('DEBUG: Search radius: $radiusKm km');

      final response = await _apiService.getNearbyLocations(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );

      print('DEBUG: Nearby locations response status: ${response.statusCode}');
      print('DEBUG: Nearby locations response data: ${response.data}');

      if (response.statusCode == 200) {
        // Handle different response formats
        List<dynamic> data = [];

        if (response.data is List) {
          // Direct array response
          data = response.data as List<dynamic>;
        } else if (response.data is Map) {
          // Check for nested data
          if (response.data['data'] != null) {
            if (response.data['data'] is List) {
              data = response.data['data'] as List<dynamic>;
            } else if (response.data['data']['locations'] != null) {
              data = response.data['data']['locations'] as List<dynamic>;
            }
          } else if (response.data['locations'] != null) {
            data = response.data['locations'] as List<dynamic>;
          }
        }

        print('DEBUG: Found ${data.length} locations');

        _nearbyLocations = data
            .map((json) => AttendanceLocationModel.fromJson(json))
            .toList();

        print('DEBUG: Parsed ${_nearbyLocations.length} locations');
        if (_nearbyLocations.isNotEmpty) {
          print('DEBUG: First location: ${_nearbyLocations[0].name}');
        }

        notifyListeners();
      }
    } catch (e) {
      print('DEBUG: Error getting nearby locations: $e');
      // Silent fail for nearby locations
      _nearbyLocations = [];
    }
  }

  // Get today's attendance
  Future<void> getTodayAttendance() async {
    try {
      print('DEBUG: Fetching today\'s attendance...');
      final response = await _apiService.getTodayAttendance();

      print('DEBUG: Today attendance response status: ${response.statusCode}');
      print('DEBUG: Today attendance response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        // Handle nested response format
        final actualData = response.data['data'] ?? response.data;

        _todayAttendance = AttendanceModel.fromJson(actualData);
        print('DEBUG: Today\'s attendance loaded: CheckIn=${_todayAttendance?.checkInTime}, CheckOut=${_todayAttendance?.checkOutTime}');
        notifyListeners();
      }
    } catch (e) {
      // No attendance today (404 or other error)
      print('DEBUG: No attendance today or error: $e');
      _todayAttendance = null;
      notifyListeners();
    }
  }

  // Check in
  Future<bool> checkIn({
    required AttendanceLocationModel location,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      // Get current position
      final position = await _locationService.getCurrentPosition();

      // Validate location
      final isWithinRadius = _locationService.isWithinRadius(
        userLat: position.latitude,
        userLon: position.longitude,
        locationLat: location.latitude,
        locationLon: location.longitude,
        radiusInMeters: location.radius.toDouble(),
      );

      if (!isWithinRadius) {
        final distance = _locationService.calculateDistance(
          position.latitude,
          position.longitude,
          location.latitude,
          location.longitude,
        );
        _errorMessage =
            'You are ${_locationService.getFormattedDistance(distance)} away from the location. Please move closer (within ${location.radius}m)';
        _setLoading(false);
        return false;
      }

      // Call check-in API
      final response = await _apiService.checkIn(
        locationId: location.id,
        latitude: position.latitude,
        longitude: position.longitude,
        notes: notes,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle nested response format
        final actualData = response.data['data'] ?? response.data;
        _todayAttendance = AttendanceModel.fromJson(actualData);
        _setLoading(false);
        notifyListeners();
        return true;
      }

      _errorMessage = 'Check-in failed';
      _setLoading(false);
      return false;
    } on DioException catch (e) {
      _handleDioError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Check out
  Future<bool> checkOut({String? notes}) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      if (_todayAttendance == null) {
        _errorMessage = 'No active check-in found';
        _setLoading(false);
        return false;
      }

      // Get current position
      final position = await _locationService.getCurrentPosition();

      // Call check-out API
      final response = await _apiService.checkOut(
        attendanceId: _todayAttendance!.id,
        latitude: position.latitude,
        longitude: position.longitude,
        notes: notes,
      );

      if (response.statusCode == 200) {
        // Handle nested response format
        final actualData = response.data['data'] ?? response.data;
        _todayAttendance = AttendanceModel.fromJson(actualData);
        _setLoading(false);
        notifyListeners();
        return true;
      }

      _errorMessage = 'Check-out failed';
      _setLoading(false);
      return false;
    } on DioException catch (e) {
      _handleDioError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Get attendance history
  Future<void> getAttendanceHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _setLoading(true);

      final response = await _apiService.getAttendanceHistory(
        startDate: startDate,
        endDate: endDate,
      );

      if (response.statusCode == 200) {
        // Handle nested response format
        final actualData = response.data['data'] ?? response.data;
        final List<dynamic> data = actualData['data'] ?? actualData['attendances'] ?? [];
        _attendanceHistory =
            data.map((json) => AttendanceModel.fromJson(json)).toList();
      }

      _setLoading(false);
      notifyListeners();
    } on DioException catch (e) {
      _handleDioError(e);
      _setLoading(false);
    }
  }

  // Validate location before check-in
  Future<Map<String, dynamic>?> validateLocation(
      AttendanceLocationModel location) async {
    try {
      final position = await _locationService.getCurrentPosition();

      final distance = _locationService.calculateDistance(
        position.latitude,
        position.longitude,
        location.latitude,
        location.longitude,
      );

      final isWithinRadius = distance <= location.radius;

      return {
        'isValid': isWithinRadius,
        'distance': distance,
        'distanceFormatted': _locationService.getFormattedDistance(distance),
        'position': position,
      };
    } catch (e) {
      return null;
    }
  }

  // Handle Dio errors
  void _handleDioError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      _errorMessage = data['message'] ?? 'An error occurred';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      _errorMessage = 'Connection timeout. Please check your internet connection';
    } else {
      _errorMessage = 'Network error. Please check your internet connection';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _todayAttendance = null;
    _attendanceHistory = [];
    _nearbyLocations = [];
    _currentPosition = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
