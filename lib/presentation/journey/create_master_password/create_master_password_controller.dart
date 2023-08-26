import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:password_keeper/presentation/widgets/export.dart';

class CreateMasterPasswordController extends GetxController
    with MixinController {
  final masterPwdController = TextEditingController();
  final confirmMasterPwdController = TextEditingController();
  final masterPwdHintController = TextEditingController();

  final masterPwdFocusNode = FocusNode();
  final confirmMasterPwdFocusNode = FocusNode();
  final masterPwdHintFocusNode = FocusNode();

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;

  RxString errorText = ''.obs;

  RxString masterPwdValidate = ''.obs;
  RxString confirmMasterPwdValidate = ''.obs;
  RxString masterPwdHintValidate = ''.obs;

  RxBool masterPwdHasFocus = false.obs;
  RxBool confirmMasterPwdHasFocus = false.obs;
  RxBool masterPwdHintHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  RxBool showMasterPwd = false.obs;
  RxBool showConfirmMasterPwd = false.obs;

  RxBool showPasswordStrengthChecker = false.obs;

  Rx<PasswordStrengthLevel> passwordStrength =
      PasswordStrengthLevel.veryWeak.obs;

  AccountUseCase accountUsecase;
  final _cryptoController = Get.find<CryptoController>();
  CreateMasterPasswordController({required this.accountUsecase});

  void checkButtonEnable() {
    if (masterPwdController.text.isNotEmpty &&
        confirmMasterPwdController.text.isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void onChangedShowMasterPwd() {
    showMasterPwd.value = !(showMasterPwd.value);
  }

  void onChangedShowConfirmPwd() {
    showConfirmMasterPwd.value = !(showConfirmMasterPwd.value);
  }

  void postRegister() async {
    rxLoadedButton.value = LoadedType.finish;
    hideKeyboard();
    masterPwdValidate.value =
        AppValidator.validatePassword(masterPwdController);

    confirmMasterPwdValidate.value = AppValidator.validateConfirmPassword(
        masterPwdController, confirmMasterPwdController);

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.context != null) {
        showTopSnackBarError(
            Get.context!, TransactionConstants.noConnectionError.tr);
      }
      rxLoadedButton.value = LoadedType.finish;
      return;
    }

    if (passwordStrength.value == PasswordStrengthLevel.veryWeak) {
      masterPwdValidate.value = TransactionConstants.weakPasswordError.tr;
      return;
    }

    if (masterPwdValidate.value.isEmpty &&
        confirmMasterPwdValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      final masterPassword = masterPwdController.text;
      final email = (accountUsecase.user.email ?? '').trim().toLowerCase();

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
        email: accountUsecase.user.email,
        userId: accountUsecase.user.uid,
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
      } catch (e) {
        debugPrint(e.toString());
        showTopSnackBarError(context, TransactionConstants.unknownError.tr);
      } finally {
        rxLoadedButton.value = LoadedType.finish;
      }
    }
  }

  void onTapPwdTextField() {
    confirmMasterPwdHasFocus.value = false;
    masterPwdHasFocus.value = true;
    masterPwdHintHasFocus.value = false;
  }

  void onEditingCompletePwd() {
    confirmMasterPwdHasFocus.value = true;
    masterPwdHasFocus.value = false;
    FocusScope.of(context).requestFocus(confirmMasterPwdFocusNode);
  }

  void onChangedPwd() {
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

  void onChangedConfirmPwd() {
    checkButtonEnable();
    confirmMasterPwdValidate.value = '';
  }

  void onTapConfirmPwdTextField() {
    masterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = false;
    confirmMasterPwdHasFocus.value = true;
  }

  void onEditingCompleteConfirmPwd() {
    confirmMasterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = true;
    FocusScope.of(context).requestFocus(masterPwdHintFocusNode);
  }

  void onEditingCompleteMasterPwdHint() {
    masterPwdHintHasFocus.value = false;
    FocusScope.of(context).unfocus();
  }

  void onTapMasterPwdHintTextField() {
    masterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = true;
    confirmMasterPwdHasFocus.value = false;
  }

  void onPressedRegister() {
    masterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = false;
    confirmMasterPwdHasFocus.value = false;
    if (buttonEnable.value) {
      postRegister();
    }
  }

  onPressLogin() {
    Get.back();
  }

  @override
  void onReady() async {
    super.onReady();
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
