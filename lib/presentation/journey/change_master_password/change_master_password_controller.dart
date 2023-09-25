import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/app_validator.dart';
import 'package:password_keeper/common/utils/password_helper.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/account.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';

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
  final _cryptoController = Get.find<CryptoController>();
  ChangeMasterPasswordController({required this.accountUsecase});

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
    confirmMasterPwdValidate.value = AppValidator.validateConfirmPassword(
        masterPwdController, confirmMasterPwdController);

    if (passwordStrength.value == PasswordStrengthLevel.veryWeak) {
      masterPwdValidate.value = TranslationConstants.weakPasswordError.tr;
      return;
    }

    if (masterPwdValidate.value.isEmpty &&
        currentMasterPwdValidate.value.isEmpty &&
        confirmMasterPwdValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      final masterPassword = masterPwdController.text;
      final email = (user?.email ?? '').trim().toLowerCase();

      //make master key
      var key = await _cryptoController.makeKey(
        password: masterPassword,
        salt: email,
      );

      final currentMasterPasswordValid = await _cryptoController.compareKeyHash(
        masterPassword: currentMasterPwdController.text,
        key: key,
      );

      if (!currentMasterPasswordValid) {
        currentMasterPwdValidate.value =
            TranslationConstants.wrongMasterPassword.tr;
        rxLoadedButton.value = LoadedType.finish;
        return;
      }


    }
  }

  void postRegister() async {
    if (masterPwdValidate.value.isEmpty &&
        confirmMasterPwdValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      final masterPassword = masterPwdController.text;
      final email = (accountUsecase.user?.email ?? '').trim().toLowerCase();

      // Email = Email.Trim().ToLower();
      // var kdfConfig =   KdfConfig(
      //     KdfType.PBKDF2_SHA256, Constants.Pbkdf2Iterations, null, null);
      var key = await _cryptoController.makeKey(
        password: masterPassword,
        salt: email,
      );
      var encKey = await _cryptoController.makeEncKey(key);
      var hashedPassword = await _cryptoController.hashPassword(
          password: masterPassword, key: key);
      //  var keys = await _cryptoController.makeKeyPair(encKey.Item1);

      final profile = AccountProfile(
        email: accountUsecase.user?.email,
        name: accountUsecase.user?.displayName,
        userId: accountUsecase.user?.uid,
        hashedMasterPassword: hashedPassword,
        masterPasswordHint: masterPwdHintController.text.trim(),
        kdfIterations: Constants.argon2Iterations,
        kdfMemory: Constants.argon2MemoryInMB,
        kdfParallelism: Constants.argon2Parallelism,
        key: encKey?.encKey?.encryptedString,
      );

      try {
        await accountUsecase.createUser(profile);

        debugPrint('đăng ký thành công');
        Get.offAllNamed(AppRoutes.verifyMasterPassword);
      } catch (e) {
        debugPrint(e.toString());
        showErrorMessage();
      } finally {
        rxLoadedButton.value = LoadedType.finish;
      }
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
    confirmMasterPwdValidate.value = '';
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
