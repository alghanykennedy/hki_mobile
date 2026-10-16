import 'package:flutter_test/flutter_test.dart';
import 'package:hki_mobile/core/constants/app_strings.dart';
import 'package:hki_mobile/core/utils/validators.dart';

void main() {
  group('Validators - Email', () {
    test('returns error for empty email', () {
      expect(Validators.validateEmail(''), AppStrings.emailRequired);
      expect(Validators.validateEmail(null), AppStrings.emailRequired);
    });

    test('returns error for invalid email format', () {
      expect(Validators.validateEmail('invalid-email'), AppStrings.emailInvalid);
      expect(Validators.validateEmail('test@com'), AppStrings.emailInvalid);
    });

    test('returns null for valid email', () {
      expect(Validators.validateEmail('admin@test.com'), isNull);
      expect(Validators.validateEmail('user.name@hki.co.id'), isNull);
    });
  });

  group('Validators - NIK', () {
    test('returns error for empty NIK', () {
      expect(Validators.validateNik(''), AppStrings.nikRequired);
    });

    test('returns error for non-digit NIK', () {
      expect(Validators.validateNik('123456789012345a'), AppStrings.nikDigitsOnly);
    });

    test('returns error for NIK with invalid length', () {
      expect(Validators.validateNik('12345678'), AppStrings.nikLengthInvalid);
      expect(Validators.validateNik('12345678901234567'), AppStrings.nikLengthInvalid);
    });

    test('returns null for valid 16-digit NIK', () {
      expect(Validators.validateNik('3201012345678901'), isNull);
    });
  });

  group('Validators - Identifier', () {
    test('accepts valid email', () {
      expect(Validators.validateIdentifier('admin@test.com'), isNull);
    });

    test('accepts valid 16-digit NIK', () {
      expect(Validators.validateIdentifier('3201012345678901'), isNull);
    });

    test('rejects arbitrary invalid string', () {
      expect(Validators.validateIdentifier('random_string'), AppStrings.identifierInvalid);
    });
  });

  group('Validators - Password', () {
    test('returns error when password is empty', () {
      expect(Validators.validatePassword(''), AppStrings.passwordRequired);
    });

    test('returns error when password is shorter than 8 chars', () {
      expect(Validators.validatePassword('1234567'), AppStrings.passwordMinLength);
    });

    test('returns null when password is 8 chars or longer', () {
      expect(Validators.validatePassword('Test1234'), isNull);
      expect(Validators.validatePassword('LongPassword123!'), isNull);
    });
  });

  group('Validators - Confirm Password', () {
    test('returns error when passwords do not match', () {
      expect(
        Validators.validateConfirmPassword('Test1234', 'Different123'),
        AppStrings.passwordMismatch,
      );
    });

    test('returns null when passwords match', () {
      expect(Validators.validateConfirmPassword('Test1234', 'Test1234'), isNull);
    });
  });
}
