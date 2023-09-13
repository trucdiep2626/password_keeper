import 'package:password_keeper/common/constants/enums.dart';
import 'package:zxcvbn/zxcvbn.dart';

class PasswordHelper {
  static PasswordStrengthLevel checkPasswordStrength(String password) {
    final zxcvbn = Zxcvbn();

    final result = zxcvbn.evaluate(password);

    final score = result.score ?? 0.0;
    if (score <= 1.0) {
      return PasswordStrengthLevel.veryWeak;
    } else if (score <= 2.0) {
      return PasswordStrengthLevel.weak;
    } else if (score <= 3.0) {
      return PasswordStrengthLevel.good;
    } else {
      return PasswordStrengthLevel.strong;
    }
  }

  static PasswordType getPasswordTypeFromName(String name) {
    switch (name) {
      case 'password':
        return PasswordType.password;
      case 'passphrase':
        return PasswordType.passphrase;
      default:
        return PasswordType.password;
    }
  }

  static PasswordStrengthLevel getPasswordStrengthFromId(int id) {
    switch (id) {
      case 0:
        return PasswordStrengthLevel.veryWeak;
      case 1:
        return PasswordStrengthLevel.weak;
      case 2:
        return PasswordStrengthLevel.good;
      case 3:
        return PasswordStrengthLevel.strong;
      default:
        return PasswordStrengthLevel.weak;
    }
  }
}
