/// ONE place that knows the response envelope structure.
/// Assumes a Laravel-style body:
/// {
///   "success": true/false, // optional
///   "message": "...",
///   "data": { ... },
///   "errors": {
///     "email": ["Email sudah dipakai"],
///     "nik": ["NIK sudah dipakai"]
///   }
/// }
class ApiResponseParser {
  ApiResponseParser._();

  /// Extracts the main payload from response body.
  static dynamic extractData(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json.containsKey('data')) {
        return json['data'];
      }
      return json;
    }
    return json;
  }

  /// Extracts a human-readable message from response body.
  static String? extractMessage(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json['message'] is String && (json['message'] as String).isNotEmpty) {
        return json['message'] as String;
      }
      if (json['error'] is String && (json['error'] as String).isNotEmpty) {
        return json['error'] as String;
      }
    }
    return null;
  }

  /// Extracts field validation errors as Map<String, List<String>>.
  static Map<String, List<String>> extractFieldErrors(dynamic json) {
    final Map<String, List<String>> result = {};
    if (json is! Map<String, dynamic>) {
      return result;
    }

    final rawErrors = json['errors'];
    if (rawErrors is Map<String, dynamic>) {
      rawErrors.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => e.toString()).toList();
        } else if (value is String) {
          result[key] = [value];
        }
      });
    }

    return result;
  }
}
