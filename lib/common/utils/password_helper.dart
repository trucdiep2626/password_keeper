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
}
