import '../../domain/entities/auth_tokens.dart';

class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    super.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedExpiresAt;
    if (json['expires_at'] != null) {
      parsedExpiresAt = DateTime.tryParse(json['expires_at'].toString());
    } else if (json['expires_in'] != null) {
      final seconds = int.tryParse(json['expires_in'].toString());
      if (seconds != null) {
        parsedExpiresAt = DateTime.now().add(Duration(seconds: seconds));
      }
    }

    return AuthTokensModel(
      accessToken: (json['access_token'] ?? json['accessToken'] ?? json['token'] ?? '').toString(),
      refreshToken: (json['refresh_token'] ?? json['refreshToken'] ?? '').toString(),
      expiresAt: parsedExpiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }

  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}
