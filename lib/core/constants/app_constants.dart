class AppConstants {
  AppConstants._();

  // Field validation rules
  // TODO(confirm): Figma copy says "Maksimal dengan 8 karakter" / "harus maksimal 8 karakter",
  // default minimum 8 characters.
  static const int passwordMinLength = 8;

  // TODO(confirm): NIK length standard in Indonesia is 16 digits.
  static const int nikLength = 16;

  // Reachability check
  static const String reachabilityHost = '1.1.1.1';
  static const int reachabilityPort = 53;
  static const Duration reachabilityTimeout = Duration(seconds: 3);

  // Mock delays
  static const int mockDelayMinMs = 600;
  static const int mockDelayMaxMs = 800;
}
