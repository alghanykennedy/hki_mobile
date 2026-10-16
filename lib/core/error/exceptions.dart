abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

class NoInternetException extends AppException {
  const NoInternetException({super.message = 'Tidak ada koneksi internet'});
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Koneksi melebihi batas waktu (timeout)',
    super.statusCode,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Sesi telah berakhir atau tidak terautentikasi',
    super.statusCode = 401,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Akses ditolak',
    super.statusCode = 403,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Data tidak ditemukan',
    super.statusCode = 404,
  });
}

class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;

  const ValidationException({
    super.message = 'Validasi gagal',
    super.statusCode = 422,
    this.fieldErrors = const {},
  });

  @override
  String toString() =>
      'ValidationException(message: $message, statusCode: $statusCode, fieldErrors: $fieldErrors)';
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException({
    super.message = 'Terlalu banyak permintaan, coba lagi nanti',
    super.statusCode = 429,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Terjadi kesalahan pada server',
    super.statusCode = 500,
  });
}

class CancelledException extends AppException {
  const CancelledException({super.message = 'Permintaan dibatalkan'});
}

class BadCertificateException extends AppException {
  const BadCertificateException({super.message = 'Sertifikat keamanan tidak valid'});
}

class ParsingException extends AppException {
  const ParsingException({super.message = 'Gagal memproses data respons'});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Terjadi kesalahan pada penyimpanan lokal'});
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Terjadi kesalahan yang tidak diketahui',
    super.statusCode,
  });
}
