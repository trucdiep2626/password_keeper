import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/symmetric_crypto_key.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/auto_fill_controller.dart';
import 'package:password_keeper/presentation/controllers/biometric_controller.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/screen_capture_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class VerifyMasterPasswordController extends GetxController
    with MixinController {
  final masterPwdController = TextEditingController();

  final masterPwdFocusNode = FocusNode();

  RxString errorText = ''.obs;

  RxString masterPwdValidate = ''.obs;

  RxBool masterPwdHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  RxInt wrongMasterPwdCount = 0.obs;

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;

  AccountUseCase accountUseCase;
  LocalUseCase localUseCase;
  PasswordUseCase passwordUseCase;
  FirebaseMessaging fbMessaging;

  final CryptoController _cryptoController = Get.find<CryptoController>();

  RxBool showMasterPwd = false.obs;
  RxBool showConfirmMasterPwd = false.obs;

  VerifyMasterPasswordController({
    required this.accountUseCase,
    required this.localUseCase,
    required this.passwordUseCase,
    required this.fbMessaging,
  });

  void checkButtonEnable() {
    if (masterPwdController.text.isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  User? get user => accountUseCase.user;

  void onChangedShowMasterPwd() {
    showMasterPwd.value = !(showMasterPwd.value);
  }

  void onChangedShowConfirmPwd() {
    showConfirmMasterPwd.value = !(showConfirmMasterPwd.value);
  }

  Future<void> handleVerify() async {
    hideKeyboard();
    // masterPwdValidate.value =
    //     AppValidator.validatePassword(masterPwdController);

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    if (masterPwdValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      final masterPassword = masterPwdController.text;
      final email = (user?.email ?? '').trim().toLowerCase();
      bool passwordValid = false;

      //make master key
      var masterKey = await _cryptoController.makeMasterKey(
        password: masterPassword,
        salt: email,
      );

      var storedHashedPassword = await _cryptoController.getHashedMasterKey();
      final profile = await accountUseCase.getProfile(userId: user?.uid ?? '');

      if (!isNullEmpty(storedHashedPassword)) {
        passwordValid = await _cryptoController.compareKeyHash(
          masterPassword: masterPassword,
          key: masterKey,
        );
      } else {
        var hashedMasterKey = await _cryptoController.hashPassword(
          password: masterPassword,
          key: masterKey,
        );

        if (profile?.hashedMasterPassword != null &&
            profile?.hashedMasterPassword!.compareTo(hashedMasterKey) == 0) {
          passwordValid = true;
          await _cryptoController.setHashedMasterKey(hashedMasterKey);
        }
      }

      if (passwordValid) {
        var hasMasterKey = await _cryptoController.hasMasterKey();
        if (!hasMasterKey) {
          await _cryptoController.setMasterKey(masterKey);
        }
        if (profile?.key != null) {
          await _cryptoController.setEncKeyEncrypted(profile!.key!);
        }
        wrongMasterPwdCount.value = 0;
        //    _cryptoController.setBiometricLocked();

        debugPrint('đăng ký thành công');
        // showTopSnackBar(context,
        //     message: TranslationConstants..tr,
        //     type: SnackBarType.done);
        // Read all values

        navigateWhenVerified();
      } else {
        errorText.value = TranslationConstants.wrongMasterPassword.tr;
        wrongMasterPwdCount.value = wrongMasterPwdCount.value + 1;
        if (wrongMasterPwdCount.value >= 3) {
          wrongMasterPwdCount.value = 0;

          await Get.find<ScreenCaptureController>().resetWhenLogOut();
          final deviceId = await FirebaseMessaging.instance.getToken();
          await passwordUseCase.deleteLoggedInDevice(
            userId: user?.uid ?? '',
            deviceId: deviceId ?? '',
          );
          await accountUseCase.multipleLoginFailuresNotice(
            name: user?.displayName ?? '',
            email: email,
          );
          await accountUseCase.signOut();

          Get.offAllNamed(AppRoutes.login);
        }
        // if (Get.context != null) {
        //   showTopSnackBarError(
        //       Get.context!, TranslationConstants.loginError.tr);
        // }
        //
        // } else {
        //   debugPrint('đăng nhập thất bại');
      }

      //    }
    } else {
      // if (Get.context != null) {
      //   showTopSnackBarError(Get.context!, TranslationConstants.loginError.tr);
      // }
      //
      // } else {
      //   debugPrint('đăng nhập thất bại');
      errorText.value = TranslationConstants.wrongMasterPassword.tr;
    }

    rxLoadedButton.value = LoadedType.finish;
  }

  // Future<SymmetricCryptoKey?> makePreLoginKey() async {
  //   final masterPassword = masterPwdController.text;
  //   final email = (user.email ?? '').trim().toLowerCase();
  //
  //   if (email.isEmpty || masterPwdController.text.isEmpty) {
  //     return null;
  //   }
  //
  //   return await _cryptoController.makeKey(
  //     password: masterPassword,
  //     salt: email,
  //   );
  // }

  // String? getUserId() {
  //   return accountUseCase.getAccount?.profile?.userId;
  // }

  void onChangedPwd() {
    checkButtonEnable();
    masterPwdValidate.value = '';
  }

  Future<void> onPressedVerify() async {
    masterPwdHasFocus.value = false;
    FocusScope.of(context).unfocus();
    if (buttonEnable.value) {
      await handleVerify();
    }
  }

  Future<void> getMasterPasswordHint() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    try {
      await accountUseCase.sendPasswordHint(
          email: user?.email ?? '', userId: user?.uid ?? '');

      if (Get.context != null) {
        showTopSnackBar(
          Get.context!,
          message: TranslationConstants.masterPwdSentSuccessfully.tr,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      if (Get.context != null) {
        showTopSnackBarError(Get.context!, e.toString());
      }
    }
  }

  Future<void> onTapLogout() async {
    try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      final deviceId = await FirebaseMessaging.instance.getToken();
      await passwordUseCase.deleteLoggedInDevice(
        userId: user?.uid ?? '',
        deviceId: deviceId ?? '',
      );

      await accountUseCase.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    }
  }

  Future<void> handleBiometricUnlock() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    rxLoadedButton.value = LoadedType.start;

    final masterKeyString = await localUseCase.getDataInBiometricStorage();

    if (masterKeyString != null) {
      final masterKey =
          SymmetricCryptoKey.fromJson(jsonDecode(masterKeyString));
      final profile = await accountUseCase.getProfile(userId: user?.uid ?? '');
      await _cryptoController.setMasterKey(masterKey);
      if (profile?.key != null) {
        await _cryptoController.setEncKeyEncrypted(profile!.key!);
      }

      navigateWhenVerified();
    }

    rxLoadedButton.value = LoadedType.finish;
  }

  Future<void> navigateWhenVerified() async {
    final autofillController = Get.find<AutofillController>();
    logger(
        '-------------- ------${autofillController.enableAutofillService.value}----${(autofillController.forceInteractive ?? false)}');

    if (autofillController.isAutofilling()) {
      final result = await passwordUseCase.getPasswordList(
        userId: user?.uid ?? '',
      );
      final decryptedList = await _cryptoController.decryptPasswordList(result);

      if (autofillController.enableAutofillService.value) {
        if (!(autofillController.forceInteractive ?? false)) {
          final matchFound =
              await autofillController.autofillWithList(decryptedList);
          if (matchFound) {
            return;
          }
        }
      }
      Get.offAllNamed(AppRoutes.passwordList);
    } else if (autofillController.isAutofillSaving()) {
      Get.offAllNamed(AppRoutes.addEditPassword);
    } else {
      Get.offAllNamed(AppRoutes.main);
    }
  }

  Future<void> getLoggedDeviceInfo() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    try {
      final deviceId = await fbMessaging.getToken();
      final result = await passwordUseCase.getLoggedInDevice(
        userId: user?.uid ?? '',
        deviceId: deviceId ?? '',
      );

      if (result != null) {
        if (result.showChangedMasterPassword ?? false) {
          await Get.find<BiometricController>()
              .onChangedBiometricStorageStatus();
          await localUseCase.deleteAllSecureData();
          await passwordUseCase.updateLoggedInDevice(
            userId: user?.uid ?? '',
            loggedInDevice: result.copyWith(showChangedMasterPassword: false),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await Get.find<BiometricController>().init();
    await Get.find<ScreenCaptureController>().getAllowScreenCapture();
    masterPwdFocusNode.addListener(() {
      masterPwdHasFocus.value = masterPwdFocusNode.hasFocus;
    });
    if (Get.find<BiometricController>().enableBiometricUnlock.value) {
      await getLoggedDeviceInfo();
    }
    if (Get.find<BiometricController>().enableBiometricUnlock.value) {
      await handleBiometricUnlock();
    }
  }
}
