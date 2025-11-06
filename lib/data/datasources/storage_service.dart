import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/storage_constants.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth Methods
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(StorageConstants.keyToken, token);
  }

  String? getToken() {
    return _prefs.getString(StorageConstants.keyToken);
  }

  Future<bool> saveRefreshToken(String token) async {
    return await _prefs.setString(StorageConstants.keyRefreshToken, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(StorageConstants.keyRefreshToken);
  }

  Future<bool> saveUserId(int userId) async {
    return await _prefs.setInt(StorageConstants.keyUserId, userId);
  }

  int? getUserId() {
    return _prefs.getInt(StorageConstants.keyUserId);
  }

  Future<bool> saveUserEmail(String email) async {
    return await _prefs.setString(StorageConstants.keyUserEmail, email);
  }

  String? getUserEmail() {
    return _prefs.getString(StorageConstants.keyUserEmail);
  }

  Future<bool> saveUserFullName(String fullName) async {
    return await _prefs.setString(StorageConstants.keyUserFullName, fullName);
  }

  String? getUserFullName() {
    return _prefs.getString(StorageConstants.keyUserFullName);
  }

  Future<bool> saveUserRole(String role) async {
    return await _prefs.setString(StorageConstants.keyUserRole, role);
  }

  String? getUserRole() {
    return _prefs.getString(StorageConstants.keyUserRole);
  }

  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(StorageConstants.keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(StorageConstants.keyIsLoggedIn) ?? false;
  }

  // Clear all auth data
  Future<bool> clearAuthData() async {
    await _prefs.remove(StorageConstants.keyToken);
    await _prefs.remove(StorageConstants.keyRefreshToken);
    await _prefs.remove(StorageConstants.keyUserId);
    await _prefs.remove(StorageConstants.keyUserEmail);
    await _prefs.remove(StorageConstants.keyUserFullName);
    await _prefs.remove(StorageConstants.keyUserRole);
    return await _prefs.setBool(StorageConstants.keyIsLoggedIn, false);
  }

  // Settings Methods
  Future<bool> setFirstLaunch(bool value) async {
    return await _prefs.setBool(StorageConstants.keyFirstLaunch, value);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(StorageConstants.keyFirstLaunch) ?? true;
  }

  Future<bool> saveLastSyncTime(DateTime time) async {
    return await _prefs.setString(
      StorageConstants.keyLastSyncTime,
      time.toIso8601String(),
    );
  }

  DateTime? getLastSyncTime() {
    final timeStr = _prefs.getString(StorageConstants.keyLastSyncTime);
    if (timeStr != null) {
      return DateTime.parse(timeStr);
    }
    return null;
  }

  // Offline Data Methods
  Future<bool> savePendingCheckIns(List<Map<String, dynamic>> checkIns) async {
    final jsonStr = jsonEncode(checkIns);
    return await _prefs.setString(
      StorageConstants.keyPendingCheckIns,
      jsonStr,
    );
  }

  List<Map<String, dynamic>> getPendingCheckIns() {
    final jsonStr = _prefs.getString(StorageConstants.keyPendingCheckIns);
    if (jsonStr != null) {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  Future<bool> savePendingCheckOuts(
      List<Map<String, dynamic>> checkOuts) async {
    final jsonStr = jsonEncode(checkOuts);
    return await _prefs.setString(
      StorageConstants.keyPendingCheckOuts,
      jsonStr,
    );
  }

  List<Map<String, dynamic>> getPendingCheckOuts() {
    final jsonStr = _prefs.getString(StorageConstants.keyPendingCheckOuts);
    if (jsonStr != null) {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  // Generic Methods
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }
}
