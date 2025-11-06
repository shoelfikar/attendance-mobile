import 'user_model.dart';

class AuthResponseModel {
  final String token;
  final String? refreshToken;
  final UserModel user;
  final DateTime expiresAt;

  AuthResponseModel({
    required this.token,
    this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      // Support both 'access_token' and 'token'
      token: (json['access_token'] ?? json['token']) as String,
      refreshToken: json['refresh_token'] as String?,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : DateTime.now().add(const Duration(days: 7)), // Default 7 days
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
