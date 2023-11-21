import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:password_keeper/domain/models/logged_in_device.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

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
  PasswordUseCase passwordUseCase;
  FirebaseMessaging fbMessaging;

  final _cryptoController = Get.find<CryptoController>();
  CreateMasterPasswordController({
    required this.accountUsecase,
    required this.passwordUseCase,
    required this.fbMessaging,
  });

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
    hideKeyboard();

    masterPwdValidate.value =
        AppValidator.validatePassword(masterPwdController);
    confirmMasterPwdValidate.value = AppValidator.validateConfirmPassword(
        masterPwdController, confirmMasterPwdController);

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    if (passwordStrength.value == PasswordStrengthLevel.veryWeak) {
      masterPwdValidate.value = TranslationConstants.weakPasswordError.tr;
      return;
    }

    if (masterPwdValidate.value.isEmpty &&
        confirmMasterPwdValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      final masterPassword = masterPwdController.text;
      final email = (accountUsecase.user?.email ?? '').trim().toLowerCase();

      // Email = Email.Trim().ToLower();
      // var kdfConfig =   KdfConfig(
      //     KdfType.PBKDF2_SHA256, Constants.Pbkdf2Iterations, null, null);

      //make master key
      var key = await _cryptoController.makeMasterKey(
        password: masterPassword,
        salt: email,
      );
      //encrypt user key with master key
      var encKey = await _cryptoController.makeEncKey(key);
      //hash master key
      var hashedPassword = await _cryptoController.hashPassword(
          password: masterPassword, key: key);
      //  var keys = await _cryptoController.makeKeyPair(encKey.Item1);

      final account = Account(
        email: accountUsecase.user?.email,
        name: accountUsecase.user?.displayName,
        userId: accountUsecase.user?.uid,
        hashedMasterPassword: hashedPassword,
        masterPasswordHint: masterPwdHintController.text.trim(),
        kdfIterations: Constants.argon2Iterations,
        kdfMemory: Constants.argon2MemoryInMB,
        kdfParallelism: Constants.argon2Parallelism,
        key: encKey?.encKey?.encryptedString,
        timingAlert: Constants.timingAlert,
        updatedMasterPasswordAt: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      try {
        await accountUsecase.createUser(account);

        debugPrint('đăng ký thành công');
        await addLoggedInDevice();
        Get.offAllNamed(AppRoutes.verifyMasterPassword);
      } catch (e) {
        debugPrint(e.toString());
        showErrorMessage();
      } finally {
        rxLoadedButton.value = LoadedType.finish;
      }
    }
  }

  Future<void> addLoggedInDevice() async {
    final deviceId = await fbMessaging.getToken();
    await passwordUseCase.addLoggedInDevice(
      userId: accountUsecase.user?.uid ?? '',
      loggedInDevice: LoggedInDevice(deviceId: deviceId),
    );
  }

  void onEditingCompletePwd() {
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

  void onEditingCompleteConfirmPwd() {
    FocusScope.of(context).requestFocus(masterPwdHintFocusNode);
  }

  void onEditingCompleteMasterPwdHint() {
    FocusScope.of(context).unfocus();
  }

  void onPressedRegister() {
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
