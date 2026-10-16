import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static final RegExp _digitsOnlyRegExp = RegExp(r'^[0-9]+$');

  /// Validates a generic required field
  static String? validateRequired(String? value, [String message = AppStrings.fieldRequired]) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validates full name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  /// Validates login identifier (supports either Email or 16-digit NIK)
  /// TODO(confirm): SoW allows NIK or Email
  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.identifierRequired;
    }
    final trimmed = value.trim();
    final isEmail = _emailRegExp.hasMatch(trimmed);
    final isNik = _digitsOnlyRegExp.hasMatch(trimmed) && trimmed.length == AppConstants.nikLength;

    if (!isEmail && !isNik) {
      return AppStrings.identifierInvalid;
    }
    return null;
  }

  /// Validates NIK (digits only, exact length 16)
  static String? validateNik(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nikRequired;
    }
    final trimmed = value.trim();
    if (!_digitsOnlyRegExp.hasMatch(trimmed)) {
      return AppStrings.nikDigitsOnly;
    }
    if (trimmed.length != AppConstants.nikLength) {
      return AppStrings.nikLengthInvalid;
    }
    return null;
  }

  /// Validates password against minimum length
  /// TODO(confirm): Figma copy says "harus maksimal 8 karakter" vs minimum 8
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < AppConstants.passwordMinLength) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  /// Validates password confirmation matches password
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }
    if (password != confirmPassword) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }
}
