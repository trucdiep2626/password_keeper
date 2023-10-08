import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/app_validator.dart';
import 'package:password_keeper/common/utils/password_helper.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/generated_password_item.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/password_generation_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';
import 'package:password_keeper/presentation/widgets/snack_bar/app_snack_bar.dart';

class ChangeMasterPasswordController extends GetxController
    with MixinController {
  final currentMasterPwdController = TextEditingController();
  final masterPwdController = TextEditingController();
  final confirmMasterPwdController = TextEditingController();
  final masterPwdHintController = TextEditingController();

  final currentMasterPwdFocusNode = FocusNode();
  final masterPwdFocusNode = FocusNode();
  final confirmMasterPwdFocusNode = FocusNode();
  final masterPwdHintFocusNode = FocusNode();

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;

  RxString errorText = ''.obs;

  RxString currentMasterPwdValidate = ''.obs;
  RxString masterPwdValidate = ''.obs;
  RxString confirmMasterPwdValidate = ''.obs;
  RxString masterPwdHintValidate = ''.obs;

  RxBool currentMasterPwdHasFocus = false.obs;
  RxBool masterPwdHasFocus = false.obs;
  RxBool confirmMasterPwdHasFocus = false.obs;
  RxBool masterPwdHintHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  RxBool showCurrentMasterPwd = false.obs;
  RxBool showMasterPwd = false.obs;
  RxBool showConfirmMasterPwd = false.obs;

  RxBool showPasswordStrengthChecker = false.obs;

  Rx<PasswordStrengthLevel> passwordStrength =
      PasswordStrengthLevel.veryWeak.obs;

  AccountUseCase accountUsecase;
  PasswordUseCase passwordUseCase;
  LocalUseCase localUseCase;

  final _cryptoController = Get.find<CryptoController>();
  final PasswordGenerationController _passwordGenerationController =
      Get.find<PasswordGenerationController>();

  ChangeMasterPasswordController({
    required this.accountUsecase,
    required this.passwordUseCase,
    required this.localUseCase,
  });

  User? get user => accountUsecase.user;

  void checkButtonEnable() {
    if (masterPwdController.text.isNotEmpty &&
        confirmMasterPwdController.text.isNotEmpty &&
        currentMasterPwdController.text.isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void onChangedShowCurrentMasterPwd() {
    showCurrentMasterPwd.value = !(showCurrentMasterPwd.value);
  }

  void onChangedShowMasterPwd() {
    showMasterPwd.value = !(showMasterPwd.value);
  }

  void onChangedShowConfirmPwd() {
    showConfirmMasterPwd.value = !(showConfirmMasterPwd.value);
  }

  Future<void> onPressedChange() async {
    if (buttonEnable.value) {
      hideKeyboard();

      showAppDialog(
        context,
        TranslationConstants.changeMasterPassword.tr,
        TranslationConstants.changeMasterPasswordConfirm.tr,
        confirmButtonText: TranslationConstants.confirm.tr,
        confirmButtonCallback: () async => await handleChangeMasterPassword(),
        cancelButtonText: TranslationConstants.cancel.tr,
      );
    }
  }

  Future<void> handleChangeMasterPassword() async {
    Get.back();

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    //check valid
    currentMasterPwdValidate.value = currentMasterPwdController.text.isEmpty
        ? TranslationConstants.requiredFields.tr
        : '';
    masterPwdValidate.value =
        AppValidator.validatePassword(masterPwdController);
    masterPwdValidate.value =
        currentMasterPwdController.text.compareTo(masterPwdController.text) == 0
            ? TranslationConstants.sameMasterPassword.tr
            : '';
    confirmMasterPwdValidate.value = AppValidator.validateConfirmPassword(
        masterPwdController, confirmMasterPwdController);

    if (passwordStrength.value == PasswordStrengthLevel.veryWeak) {
      masterPwdValidate.value = TranslationConstants.weakPasswordError.tr;

      return;
    }

    try {
      if (masterPwdValidate.value.isEmpty &&
          currentMasterPwdValidate.value.isEmpty &&
          confirmMasterPwdValidate.value.isEmpty) {
        rxLoadedButton.value = LoadedType.start;

        final email = (user?.email ?? '').trim().toLowerCase();
        final newMasterPassword = masterPwdController.text;

        final currentMasterPasswordValid = await checkCurrentMasterPassword();

        if (!currentMasterPasswordValid) {
          currentMasterPwdValidate.value =
              TranslationConstants.wrongMasterPassword.tr;
          rxLoadedButton.value = LoadedType.finish;

          return;
        }

        //get all passwords and decrypt
        final allPasswordItems = await getPasswordList();
        final allDecryptedPasswordItems =
            await _cryptoController.decryptPasswordList(allPasswordItems);

        //get all generated passwords and decrypt
        final allGeneratedPasswordItems = await getGeneratedPasswordList();
        final allDecryptedGeneratedPasswordItems =
            await _passwordGenerationController.decryptHistory(
                history: allGeneratedPasswordItems);

        //create new master key
        var newMasterKey = await _cryptoController.makeMasterKey(
          password: newMasterPassword,
          salt: email,
        );

        //update new enc key and hash master key
        var newEncKey = await _cryptoController.makeEncKey(newMasterKey);
        var hashedNewPassword = await _cryptoController.hashPassword(
          password: newMasterPassword,
          key: newMasterKey,
        );
        final profile =
            await accountUsecase.getProfile(userId: user?.uid ?? '');
        await accountUsecase.editProfile(profile!.copyWith(
          key: newEncKey?.encKey?.encryptedString,
          hashedMasterPassword: hashedNewPassword,
          masterPasswordHint: masterPwdHintController.text,
        ));

        //save new key in local
        _cryptoController.setHashedMasterKey(hashedNewPassword);
        await _cryptoController.setMasterKey(newMasterKey);
        await _cryptoController
            .setEncKeyEncrypted(newEncKey?.encKey?.encryptedString ?? '');

        //change biometric data
        if (Get.find<SettingsController>().isDeviceQuickUnlockEnabled.value) {
          await localUseCase.saveDataInBiometricStorage(
              value: jsonEncode(newMasterKey.toJson()));
        }

        //encrypt password list with new key
        final encryptedGeneratedList =
            await _passwordGenerationController.encryptHistory(
          history: allDecryptedGeneratedPasswordItems,
        );

        //update all encrypted passwords
        await passwordUseCase.updateGeneratedPasswordList(
          userId: user?.uid ?? '',
          passwords: encryptedGeneratedList,
        );

        //encrypt password list with new key
        final encryptedList = await _cryptoController.encryptPasswordList(
          passwords: allDecryptedPasswordItems,
        );

        //update all encrypted passwords
        await passwordUseCase.updatePasswordList(
          userId: user?.uid ?? '',
          passwords: encryptedList,
        );

        await accountUsecase.lock();
        Get.offAllNamed(AppRoutes.verifyMasterPassword);
      }
    } catch (e) {
      logger(e.toString());
    } finally {
      rxLoadedButton.value = LoadedType.finish;
    }
  }

  Future<bool> checkCurrentMasterPassword() async {
    final email = (user?.email ?? '').trim().toLowerCase();
    //make master key
    var key = await _cryptoController.makeMasterKey(
      password: currentMasterPwdController.text,
      salt: email,
    );

    final currentMasterPasswordValid = await _cryptoController.compareKeyHash(
      masterPassword: currentMasterPwdController.text,
      key: key,
    );
    return currentMasterPasswordValid;
  }

  Future<List<PasswordItem>> getPasswordList() async {
    try {
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return [];
      }

      return await passwordUseCase.getPasswordList(
        userId: user?.uid ?? '',
      );
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
      return [];
    }
  }

  Future<List<GeneratedPasswordItem>> getGeneratedPasswordList() async {
    try {
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return [];
      }

      return await passwordUseCase.getGeneratedPasswordHistory(
        userId: user?.uid ?? '',
      );
    } catch (e) {
      logger(e.toString());
      showTopSnackBarError(context, e.toString());
      return [];
    }
  }

  void onChangedMasterPwd() {
    if (masterPwdController.text.isNotEmpty) {
      passwordStrength.value =
          PasswordHelper.checkPasswordStrength(masterPwdController.text);
      showPasswordStrengthChecker.value = true;
    } else {
      showPasswordStrengthChecker.value = false;
    }
    checkButtonEnable();
    masterPwdValidate.value = '';
  }

  void onChangedConfirmMasterPwd() {
    checkButtonEnable();
    confirmMasterPwdValidate.value = '';
  }

  void onChangedCurrentMasterPwd() {
    checkButtonEnable();
    currentMasterPwdValidate.value = '';
  }

  void onEditingCompleteCurrentMasterPwd() {
    FocusScope.of(context).requestFocus(masterPwdFocusNode);
  }

  void onEditingCompleteMasterPwd() {
    FocusScope.of(context).requestFocus(confirmMasterPwdFocusNode);
  }

  void onEditingCompleteConfirmMasterPwd() {
    FocusScope.of(context).requestFocus(masterPwdHintFocusNode);
  }

  void onEditingCompleteMasterPwdHint() {
    FocusScope.of(context).unfocus();
  }

  @override
  void onReady() async {
    super.onReady();
    currentMasterPwdFocusNode.addListener(() {
      currentMasterPwdHasFocus.value = currentMasterPwdFocusNode.hasFocus;
    });
    masterPwdFocusNode.addListener(() {
      masterPwdHasFocus.value = masterPwdFocusNode.hasFocus;
    });
    masterPwdHintFocusNode.addListener(() {
      masterPwdHintHasFocus.value = masterPwdHintFocusNode.hasFocus;
    });
    confirmMasterPwdFocusNode.addListener(() {
      confirmMasterPwdHasFocus.value = confirmMasterPwdFocusNode.hasFocus;
    });
  }
}
