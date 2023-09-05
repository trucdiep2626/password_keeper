import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/injector/locators/app_locator.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/domain/models/password_generation_option.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/password_generation_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class PasswordGeneratorController extends GetxController with MixinController {
  RxBool useUppercase = true.obs;
  RxBool useLowercase = true.obs;
  RxBool useNumbers = false.obs;
  RxBool useSpecial = false.obs;
  RxBool avoidAmbiguous = false.obs;

  RxInt pwdLength = 10.obs;
  RxInt minNumbers = 0.obs;
  RxInt minSpecial = 0.obs;
  RxInt numWords = 0.obs;

  TextEditingController wordSeparatorColtroller = TextEditingController();
  RxBool capitalize = false.obs;
  RxBool includeNumber = false.obs;

  RxString generatedPassword = ''.obs;

  Rx<PasswordType> selectedType = PasswordType.password.obs;

  final PasswordUsecase passwordUsecase;
  final AccountUseCase accountUseCase;

  PasswordGenerationOptions _option = PasswordGenerationOptions();

  final PasswordGenerationOptions _defaultOption = PasswordGenerationOptions();

  PasswordGeneratorController({
    required this.passwordUsecase,
    required this.accountUseCase,
  });

  final PasswordGenerationController _passwordGenerationController =
      getIt<PasswordGenerationController>();

  User? get user => accountUseCase.user;

  Future<void> onChangedPasswordType(PasswordType type) async {
    selectedType.value = type;
    await onChangedOptions();
  }

  Future<void> onChangedUseUppercase() async {
    useUppercase.value = !useUppercase.value;
    await onChangedOptions();
  }

  Future<void> onChangedUseLowercase() async {
    useLowercase.value = !useLowercase.value;
    await onChangedOptions();
  }

  Future<void> onChangedUseNumbers() async {
    useNumbers.value = !useNumbers.value;
    await onChangedOptions();
  }

  Future<void> onChangedUseSpecial() async {
    useSpecial.value = !useSpecial.value;
    await onChangedOptions();
  }

  Future<void> onChangedAvoidAmbiguous() async {
    avoidAmbiguous.value = !avoidAmbiguous.value;
    await onChangedOptions();
  }

  Future<void> onChangedPwdLength(int value) async {
    pwdLength.value = value;
    await onChangedOptions();
  }

  Future<void> increaseMinimumNumbers() async {
    if (pwdLength.value > (minNumbers.value + minSpecial.value)) {
      minNumbers.value = minNumbers.value + 1;
      await onChangedOptions();
    }
  }

  Future<void> decreaseMinimumNumbers() async {
    if (minNumbers.value > 0) {
      minNumbers.value = minNumbers.value - 1;
      await onChangedOptions();
    }
  }

  Future<void> decreaseMinimumSpecial() async {
    if (minSpecial.value > 0) {
      minSpecial.value = minSpecial.value - 1;
      await onChangedOptions();
    }
  }

  Future<void> increaseMinimumSpecial() async {
    if (pwdLength.value > (minNumbers.value + minSpecial.value)) {
      minSpecial.value = minSpecial.value + 1;
      await onChangedOptions();
    }
  }

  Future<void> decreaseNumWords() async {
    if (numWords.value > 0) {
      numWords.value = numWords.value - 1;
      await onChangedOptions();
    }
  }

  Future<void> increaseNumWords() async {
    numWords.value = numWords.value + 1;
    await onChangedOptions();
  }

  Future<void> onChangedCapitalize() async {
    capitalize.value = !capitalize.value;
    await onChangedOptions();
  }

  Future<void> onChangedIncludeNumber() async {
    includeNumber.value = !includeNumber.value;
    await onChangedOptions();
  }

  Future<void> onChangedOptions() async {
    await saveOption();
    await generatePassword();
  }

  Future<void> generatePassword() async {
    generatedPassword.value =
        await _passwordGenerationController.generatePassword(_option);

    await _passwordGenerationController.addGeneratedPassword(
      userId: user?.uid ?? '',
      password: generatedPassword.value,
    );
  }

  Future<PasswordGenerationOptions> getOption() async {
    PasswordGenerationOptions? option = await passwordUsecase
        .getPasswordGenerationOption(userId: user?.uid ?? '');
    if (option == null) {
      option = _defaultOption;
      await passwordUsecase.setPasswordGenerationOption(
          userId: user?.uid ?? '', option: _defaultOption);
    }

    return option;
  }

  Future<void> saveOption() async {
    try {
      _option = PasswordGenerationOptions(
        avoidAmbiguous: avoidAmbiguous.value,
        minNumbers: minNumbers.value,
        minSpecial: minSpecial.value,
        useSpecial: useSpecial.value,
        useUppercase: useUppercase.value,
        useLowercase: useLowercase.value,
        useNumbers: useNumbers.value,
        pwdLength: pwdLength.value,
        numWords: numWords.value,
        capitalize: capitalize.value,
        includeNumber: includeNumber.value,
        type: selectedType.value,
        wordSeparator: wordSeparatorColtroller.text,
      );
      await passwordUsecase.setPasswordGenerationOption(
        option: _option,
        userId: user?.uid ?? '',
      );
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
    }
  }

  void applyOption(PasswordGenerationOptions option) {
    useUppercase.value = option.useUppercase ?? true;

    useLowercase.value = option.useLowercase ?? true;

    useNumbers.value = option.useNumbers ?? true;
    useSpecial.value = option.useSpecial ?? false;
    avoidAmbiguous.value = option.avoidAmbiguous ?? true;
    pwdLength.value = option.pwdLength ?? 14;
    minNumbers.value = option.minNumbers ?? 1;
    minSpecial.value = option.minSpecial ?? 1;
    numWords.value = option.numWords ?? 3;
    wordSeparatorColtroller.text = '-';
    capitalize.value = option.capitalize ?? false;
    includeNumber.value = option.includeNumber ?? false;
    selectedType.value = option.type ?? PasswordType.password;
  }

  @override
  void onReady() async {
    _option = await getOption();

    applyOption(_option);
    await generatePassword();
  }
}
