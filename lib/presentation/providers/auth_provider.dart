import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/api_service.dart';
import '../../data/datasources/storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/auth_response_model.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthProvider({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  // Initialize auth state
  Future<void> init() async {
    _setState(AuthState.loading);

    final token = _storageService.getToken();
    if (token != null) {
      _apiService.setToken(token);

      // Try to get current user
      try {
        await getCurrentUser();
        _setState(AuthState.authenticated);
      } catch (e) {
        // Token might be expired
        await logout();
      }
    } else {
      _setState(AuthState.unauthenticated);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _setState(AuthState.loading);
      _errorMessage = null;

      final response = await _apiService.login(email, password);

      print('DEBUG: Login response status: ${response.statusCode}');
      print('DEBUG: Login response full: ${response.data}');
      print('DEBUG: Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // Check if response has expected format
        if (response.data == null) {
          _errorMessage = 'Server returned empty response';
          _setState(AuthState.error);
          return false;
        }

        // Get actual data (might be nested in 'data' field)
        final actualData = response.data['data'] ?? response.data;

        print('DEBUG: Actual data: $actualData');
        print('DEBUG: Checking fields...');
        print('DEBUG: token = ${actualData['token']}');
        print('DEBUG: access_token = ${actualData['access_token']}');
        print('DEBUG: refresh_token = ${actualData['refresh_token']}');
        print('DEBUG: user = ${actualData['user']}');
        print('DEBUG: expires_at = ${actualData['expires_at']}');

        try {
          final authResponse = AuthResponseModel.fromJson(actualData);
          print('DEBUG: Parse successful!');

          // Save token and user info
          await _storageService.saveToken(authResponse.token);
          if (authResponse.refreshToken != null) {
            await _storageService.saveRefreshToken(authResponse.refreshToken!);
          }
          await _storageService.saveUserId(authResponse.user.id);
          await _storageService.saveUserEmail(authResponse.user.email);
          await _storageService.saveUserFullName(authResponse.user.fullName);
          await _storageService.saveUserRole(authResponse.user.role);
          await _storageService.setLoggedIn(true);

          _currentUser = authResponse.user;
          _apiService.setToken(authResponse.token);

          _setState(AuthState.authenticated);
          return true;
        } catch (parseError) {
          print('DEBUG: Parse error: $parseError');
          _errorMessage = 'Invalid response format from server';
          _setState(AuthState.error);
          return false;
        }
      }

      _errorMessage = 'Login failed';
      _setState(AuthState.error);
      return false;
    } on DioException catch (e) {
      print('DEBUG: DioException: ${e.message}');
      print('DEBUG: Response: ${e.response?.data}');
      _handleDioError(e);
      return false;
    } catch (e) {
      print('DEBUG: Unexpected error: $e');
      _errorMessage = 'An unexpected error occurred: $e';
      _setState(AuthState.error);
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      _setState(AuthState.loading);
      _errorMessage = null;

      final response = await _apiService.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      print('DEBUG: Register response status: ${response.statusCode}');
      print('DEBUG: Register response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Auto login after registration
        print('DEBUG: Registration successful, auto-logging in...');
        return await login(email, password);
      }

      _errorMessage = 'Registration failed';
      _setState(AuthState.error);
      return false;
    } on DioException catch (e) {
      print('DEBUG: Register DioException: ${e.message}');
      print('DEBUG: Register Response: ${e.response?.data}');
      _handleDioError(e);
      return false;
    } catch (e) {
      print('DEBUG: Register error: $e');
      _errorMessage = 'An unexpected error occurred';
      _setState(AuthState.error);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Call logout API
      await _apiService.logout();
    } catch (e) {
      // Ignore errors on logout
    } finally {
      // Clear local data
      await _storageService.clearAuthData();
      _apiService.setToken(null);
      _currentUser = null;
      _setState(AuthState.unauthenticated);
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    try {
      final response = await _apiService.getCurrentUser();

      if (response.statusCode == 200) {
        _currentUser = UserModel.fromJson(response.data);
        notifyListeners();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Token expired, logout
        await logout();
      }
      rethrow;
    }
  }

  // Update user info
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Handle Dio errors
  void _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      if (statusCode == 400) {
        _errorMessage = data['message'] ?? 'Invalid request';
      } else if (statusCode == 401) {
        _errorMessage = 'Invalid email or password';
      } else if (statusCode == 404) {
        _errorMessage = 'User not found';
      } else if (statusCode == 500) {
        _errorMessage = 'Server error. Please try again later';
      } else {
        _errorMessage = data['message'] ?? 'An error occurred';
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      _errorMessage = 'Connection timeout. Please check your internet connection';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      _errorMessage = 'Server is not responding';
    } else {
      _errorMessage = 'Network error. Please check your internet connection';
    }

    _setState(AuthState.error);
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
