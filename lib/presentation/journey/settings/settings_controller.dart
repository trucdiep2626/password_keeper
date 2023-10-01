import 'dart:convert';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/config/database/local_key.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';
import 'package:password_keeper/presentation/widgets/snack_bar/app_snack_bar.dart';

class SettingsController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedSettings = LoadedType.finish.obs;

  RxBool isDeviceQuickUnlockEnabled = false.obs;

  AccountUseCase accountUseCase;
  LocalUseCase localUseCase;

  final _cryptoController = Get.find<CryptoController>();

  User? get user => accountUseCase.user;

  SettingsController({
    required this.accountUseCase,
    required this.localUseCase,
  });

  Future<void> onTapLock() async {
    await accountUseCase.lock();
    Get.offAllNamed(AppRoutes.verifyMasterPassword);
  }

  Future<void> onTapLogout() async {
    showAppDialog(context, TranslationConstants.logout.tr,
        TranslationConstants.logoutConfirmMessage.tr,
        confirmButtonText: TranslationConstants.logout.tr,
        cancelButtonText: TranslationConstants.cancel.tr,
        confirmButtonCallback: () async {
      //  try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      rxLoadedSettings.value = LoadedType.start;

      await accountUseCase.signOut();
      Get.offAllNamed(AppRoutes.login);
      // } catch (e) {
      //   debugPrint(e.toString());
      //   showErrorMessage();
      // } finally {
      //   rxLoadedSettings.value = LoadedType.finish;
      // }
    });
  }

  Future<void> updateBiometricUnlockEnable(bool value) async {
    isDeviceQuickUnlockEnabled.value = value;
    // await accountUseCase.updateBiometricUnlockEnabled(
    //   userId: user?.uid ?? '',
    //   enabled: value,
    // );
    await localUseCase.saveSecureData(
        key: LocalStorageKey.biometricLocked, value: value.toString());
  }

  Future<void> onChangedBiometricStorageStatus() async {
    final value = !isDeviceQuickUnlockEnabled.value;
    try {
      rxLoadedSettings.value = LoadedType.start;

      if (value) {
        //enable biometric
        final response = await BiometricStorage().canAuthenticate();
        if (response == CanAuthenticateResponse.success) {
          final masterKey = await _cryptoController.getMasterKey();

          if (masterKey == null) {
            return;
          }

          await updateBiometricUnlockEnable(value);

          await localUseCase.saveDataInBiometricStorage(
              value: jsonEncode(masterKey.toJson()));

          if (Get.context != null) {
            showTopSnackBar(
              Get.context!,
              message: TranslationConstants.enableUnlockBiometric.tr,
            );
          }
        } else {
          // biometric is not supported
          await updateBiometricUnlockEnable(false);
          if (Get.context != null) {
            showTopSnackBar(
              Get.context!,
              type: SnackBarType.error,
              message: TranslationConstants.unsupportedBiometric.tr,
            );
          }
        }
      } else {
        //disable biometric
        await localUseCase.clearBiometricStorage();
        await updateBiometricUnlockEnable(value);

        if (Get.context != null) {
          showTopSnackBar(
            Get.context!,
            message: TranslationConstants.disableUnlockBiometric.tr,
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedSettings.value = LoadedType.finish;
    }
  }

  Future<bool> isBiometricLocked() async {
    final isLocked =
        await localUseCase.getSecureData(key: LocalStorageKey.biometricLocked);
    return isLocked == 'true';
  }

  Future<void> _initBiometricStorageStatus() async {
    final enabled = (await BiometricStorage().canAuthenticate()) ==
        CanAuthenticateResponse.success;
    if (enabled) {
      final isLocked = await isBiometricLocked();
      isDeviceQuickUnlockEnabled.value = isLocked;
    } else {
      isDeviceQuickUnlockEnabled.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _initBiometricStorageStatus();
  }
}
