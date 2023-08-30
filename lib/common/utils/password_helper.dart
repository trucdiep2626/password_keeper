import 'dart:math';
import 'dart:typed_data';

import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';
import 'package:zxcvbn/zxcvbn.dart';

class PasswordHelper {
  static const String LOWERCASE_CHAR_SET = "abcdefghijkmnopqrstuvwxyz";
  static const String UPPERCASE_CHAR_SET = "ABCDEFGHJKLMNPQRSTUVWXYZ";
  static const String NUMER_CHAR_SET = "23456789";
  static const String SPECIAL_CHAR_SET = "!@#\$%^&*";
  static PasswordGenerationOptions _defaultOption = PasswordGenerationOptions();

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

  // Future<String> generatePassphraseAsync(
  //     PasswordGenerationOptions option) async {
  //   option = option.copyWith(option: _defaultOption);
  //   if ((option.numWords ?? 0) <= 2) {
  //     option.numWords = _defaultOption.numWords;
  //   }
  //   if (option.wordSeparator == null ||
  //       option.wordSeparator?.length == 0 ||
  //       (option.wordSeparator?.length ?? 0) > 1) {
  //     option.wordSeparator = " ";
  //   }
  //   option.capitalize ??= false;
  //
  //   option.includeNumber ??= false;
  //
  //   var listLength = EEFLongWordList.instance.list.length - 1;
  //   var wordList = <String>[];
  //   for (int i = 0; i < option.numWords; i++) {
  //     var wordIndex = await _cryptoService.randomNumberAsync(0, listLength);
  //     if (option.capitalize) {
  //       wordList.add(capitalize(EEFLongWordList.instance.list[wordIndex]));
  //     } else {
  //       wordList.add(EEFLongWordList.instance.list[wordIndex]);
  //     }
  //   }
  //   if (option.includeNumber) {
  //     await appendRandomNumberToRandomWordAsync(wordList);
  //   }
  //   return wordList.join(option.wordSeparator);
  // }

  static Future<String> generatePassword(
      PasswordGenerationOptions option) async {
    // Overload defaults with given option
    // option.Merge(_defaultoption);
    // if (option.Type == PasswordGenerationOptions.TYPE_PASSPHRASE)
    // {
    //   return await GeneratePassphraseAsync(option);
    // }

    // Sanitize
    sanitizePasswordLength(
      option: option,
      forGeneration: true,
    );

    final positions = <String>[];
    if ((option.useLowercase ?? false) && (option.minLowercase ?? 0) > 0) {
      for (var i = 0; i < (option.minLowercase ?? 0); i++) {
        positions.add('l');
      }
    }
    if ((option.useUppercase ?? false) && (option.minUppercase ?? 0) > 0) {
      for (var i = 0; i < (option.minUppercase ?? 0); i++) {
        positions.add('u');
      }
    }
    if ((option.useNumbers ?? false) && (option.minNumbers ?? 0) > 0) {
      for (var i = 0; i < (option.minNumbers ?? 0); i++) {
        positions.add('n');
      }
    }
    if ((option.useSpecial ?? false) && (option.minSpecial ?? 0) > 0) {
      for (var i = 0; i < (option.minSpecial ?? 0); i++) {
        positions.add('s');
      }
    }
    while (positions.length < (option.pwdLength ?? 0)) {
      positions.add('a');
    }

    await shuffleArray(positions);

    var allCharSet = '';

    var lowercaseCharSet = LOWERCASE_CHAR_SET;
    if (option.avoidAmbiguous ?? false) {
      lowercaseCharSet += 'l';
    }
    if (option.useLowercase ?? false) {
      allCharSet += lowercaseCharSet;
    }

    var uppercaseCharSet = UPPERCASE_CHAR_SET;
    if (option.avoidAmbiguous ?? false) {
      uppercaseCharSet += 'IO';
    }
    if (option.useUppercase ?? false) {
      allCharSet += uppercaseCharSet;
    }

    var numberCharSet = NUMER_CHAR_SET;
    if (option.avoidAmbiguous ?? false) {
      numberCharSet += '01';
    }
    if (option.useNumbers ?? false) {
      allCharSet += numberCharSet;
    }

    var specialCharSet = SPECIAL_CHAR_SET;
    if (option.useSpecial ?? false) {
      allCharSet += specialCharSet;
    }

    var password = '';
    for (var i = 0; i < (option.pwdLength ?? 0); i++) {
      var positionChars = '';
      switch (positions[i]) {
        case 'l':
          positionChars = lowercaseCharSet;
          break;
        case 'u':
          positionChars = uppercaseCharSet;
          break;
        case 'n':
          positionChars = numberCharSet;
          break;
        case 's':
          positionChars = specialCharSet;
          break;
        case 'a':
          positionChars = allCharSet;
          break;
        default:
          break;
      }

      final randomCharIndex =
          await randomNumberAsyncWithRange(0, positionChars.length - 1);
      password += positionChars[randomCharIndex];
    }

    return password;
  }

  static Future<int> randomNumber() async {
    final rng = Random.secure();
    final uint8List = Uint8List(4); // 4 bytes for a 32-bit integer
    for (var i = 0; i < 4; i++) {
      uint8List[i] = rng.nextInt(256);
    }
    return ByteData.sublistView(uint8List).getInt32(0);
  }

  static Future<int> randomNumberAsyncWithRange(int min, int max) async {
    max = max + 1;

    final diff = max - min;
    final upperBound = (4294967295 / diff).floor() * diff;
    int ui;
    do {
      ui = await randomNumber();
    } while (ui >= upperBound);
    return min + (ui % diff);
  }

  static Future<void> shuffleArray(List<String> array) async {
    final random = Random();
    for (var i = array.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  static void sanitizePasswordLength({
    required PasswordGenerationOptions option,
    required bool forGeneration,
  }) {
    var minUppercaseCalc = 0;
    var minLowercaseCalc = 0;
    var minNumberCalc = option.minNumbers ?? 0;
    var minSpecialCalc = option.minSpecial ?? 0;

    if ((option.useUppercase ?? false) && (option.minUppercase ?? 0) <= 0) {
      minUppercaseCalc = 1;
    } else if (!(option.useUppercase ?? false)) {
      minUppercaseCalc = 0;
    }

    if ((option.useLowercase ?? false) && (option.minLowercase ?? 0) <= 0) {
      minLowercaseCalc = 1;
    } else if (!(option.useLowercase ?? false)) {
      minLowercaseCalc = 0;
    }

    if ((option.useNumbers ?? false) && (option.minNumbers ?? 0) <= 0) {
      minNumberCalc = 1;
    } else if (!(option.useNumbers ?? false)) {
      minNumberCalc = 0;
    }

    if ((option.useSpecial ?? false) && (option.minSpecial ?? 0) <= 0) {
      minSpecialCalc = 1;
    } else if (!(option.useSpecial ?? false)) {
      minSpecialCalc = 0;
    }

    // This should never happen but is a final safety net
    if ((option.pwdLength ?? 0) < 1) {
      option.pwdLength = 10;
    }

    var minLength =
        minUppercaseCalc + minLowercaseCalc + minNumberCalc + minSpecialCalc;
    // Normalize and Generation both require this modification
    if ((option.pwdLength ?? 0) < minLength) {
      option.pwdLength = minLength;
    }

    // Apply other changes if the option object passed in is for generation
    if (forGeneration) {
      option.minUppercase = minUppercaseCalc;
      option.minLowercase = minLowercaseCalc;
      option.minNumbers = minNumberCalc;
      option.minSpecial = minSpecialCalc;
    }
  }
}
