enum Environment { dev, staging, prod }

class AppConfig {
  AppConfig._();

  static const String _envString = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const bool _useMockOverride = bool.fromEnvironment('USE_MOCK', defaultValue: false);

  static Environment get environment {
    switch (_envString.toLowerCase()) {
      case 'prod':
      case 'production':
        return Environment.prod;
      case 'staging':
        return Environment.staging;
      case 'dev':
      default:
        return Environment.dev;
    }
  }

  static bool get isDev => environment == Environment.dev;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProd => environment == Environment.prod;

  // Toggle mock data source (default true until real backend is ready)
  static bool get useMock => _useMockOverride;

  // Toggle refresh token flow (default true, easily switched off if backend doesn't support it)
  // TODO(confirm): Confirm if backend supports refresh token mechanism
  static const bool useRefreshToken = true;

  static String get baseUrl {
    switch (environment) {
      case Environment.prod:
        return 'https://api.hki-alpha.dc.mapid.io/api';
      case Environment.staging:
        return 'https://api.hki-alpha.dc.mapid.io/api';
      case Environment.dev:
      default:
        return 'https://api.hki-alpha.dc.mapid.io/api';
    }
  }

  // Timeouts in milliseconds
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
