import 'dart:math';

import 'package:get/get.dart';
import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/domain/models/encrypted_string.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class PasswordGenerationController extends GetxController with MixinController {
  final CryptoController _cryptoController = Get.find<CryptoController>();
  final PasswordUseCase passwordUseCase;

  PasswordGenerationController({required this.passwordUseCase});

  final List<GeneratedPasswordItem> history = <GeneratedPasswordItem>[];

  Future<String> generatePassword(
      PasswordGenerationOptions passwordGenerationOption) async {
    // Sanitize
    final option = sanitizePasswordLength(
      option: passwordGenerationOption,
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

    var lowercaseCharSet = Constants.lowercaseCharSet;
    if (option.avoidAmbiguous ?? false) {
      lowercaseCharSet += 'l';
    }
    if (option.useLowercase ?? false) {
      allCharSet += lowercaseCharSet;
    }

    var uppercaseCharSet = Constants.uppercaseCharSet;
    if (option.avoidAmbiguous ?? false) {
      uppercaseCharSet += 'IO';
    }
    if (option.useUppercase ?? false) {
      allCharSet += uppercaseCharSet;
    }

    var numberCharSet = Constants.numCharSet;
    if (option.avoidAmbiguous ?? false) {
      numberCharSet += '01';
    }
    if (option.useNumbers ?? false) {
      allCharSet += numberCharSet;
    }

    var specialCharSet = Constants.specialCharSet;
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

      final randomCharIndex = await _cryptoController
          .randomNumberAsyncWithRange(0, positionChars.length - 1);
      password += positionChars[randomCharIndex];
    }

    return password;
  }

  Future<void> shuffleArray(List<String> array) async {
    final random = Random();
    for (var i = array.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  PasswordGenerationOptions sanitizePasswordLength({
    required PasswordGenerationOptions option,
    required bool forGeneration,
  }) {
    final updatedOption = option;
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
      updatedOption.pwdLength = 10;
    }

    var minLength =
        minUppercaseCalc + minLowercaseCalc + minNumberCalc + minSpecialCalc;
    // Normalize and Generation both require this modification
    if ((option.pwdLength ?? 0) < minLength) {
      updatedOption.pwdLength = minLength;
    }

    // Apply other changes if the option object passed in is for generation
    if (forGeneration) {
      updatedOption.minUppercase = minUppercaseCalc;
      updatedOption.minLowercase = minLowercaseCalc;
      updatedOption.minNumbers = minNumberCalc;
      updatedOption.minSpecial = minSpecialCalc;
    }

    return updatedOption;
  }

  Future<bool> matchesPrevious(
      {required String userId, required String password}) async {
    final previous =
        await passwordUseCase.getLatestGeneratedHistory(userId: userId);

    if (previous == null) {
      return false;
    }
    return previous.password == password;
  }

  Future<List<GeneratedPasswordItem>> encryptHistory(
      {List<GeneratedPasswordItem>? history}) async {
    final encryptedHistory = <GeneratedPasswordItem>[];

    if (history == null || history.isEmpty) {
      return encryptedHistory;
    }

    for (var item in history) {
      final encrypted =
          await _cryptoController.encryptString(plainValue: item.password);

      if (encrypted != null) {
        encryptedHistory.add(GeneratedPasswordItem(
          password: encrypted.encryptedString,
          createdAt: item.createdAt,
        ));
      }
    }

    return encryptedHistory;
  }

  Future<List<GeneratedPasswordItem>> decryptHistory(
      {List<GeneratedPasswordItem>? history}) async {
    final decryptedHistory = <GeneratedPasswordItem>[];

    if (history == null || history.isEmpty) {
      return decryptedHistory;
    }

    for (var item in history) {
      final decrypted = await _cryptoController.decryptToUtf8(
          encString:
              EncryptedString.fromString(encryptedString: item.password));

      if (decrypted != null) {
        decryptedHistory.add(GeneratedPasswordItem(
          password: decrypted,
          createdAt: item.createdAt,
        ));
      }
    }

    return decryptedHistory;
  }

  Future<bool> addGeneratedPassword({
    required String userId,
    required String password,
  }) async {
    if (await matchesPrevious(userId: userId, password: password)) {
      return false;
    }

    final currentHistoryLength =
        await passwordUseCase.getGeneratedPasswordHistoryLength(userId: userId);

    if (currentHistoryLength >= Constants.maxGeneratedPasswordInHistory) {
      await passwordUseCase.deleteOldestGeneratedHistory(userId: userId);
    }

    final encPassword =
        await _cryptoController.encryptString(plainValue: password);

    await passwordUseCase.addGeneratedPassword(
        userId: userId,
        passwordItem: GeneratedPasswordItem(
          password: encPassword?.encryptedString,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
    return true;
  }
}
