import 'dart:convert';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:did_change_authlocal/did_change_authlocal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/config/database/local_key.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class BiometricController extends GetxController with MixinController {
  RxBool enableBiometricUnlock = false.obs;

  final LocalUseCase localUseCase;

  final CryptoController _cryptoController = Get.find<CryptoController>();

  BiometricController({required this.localUseCase});

  Future<bool> isBiometricLocked() async {
    final isLocked =
        await localUseCase.getSecureData(key: LocalStorageKey.biometricLocked);
    return isLocked == 'true';
  }

  Future<void> getBiometricStorageStatus() async {
    final enabled = (await BiometricStorage().canAuthenticate()) ==
        CanAuthenticateResponse.success;
    if (enabled) {
      final isLocked = await isBiometricLocked();
      enableBiometricUnlock.value = isLocked;
    } else {
      enableBiometricUnlock.value = false;
    }
  }

  Future<void> updateBiometricUnlockEnable(bool value) async {
    enableBiometricUnlock.value = value;
    // await accountUseCase.updateBiometricUnlockEnabled(
    //   userId: user?.uid ?? '',
    //   enabled: value,
    // );
    await localUseCase.saveSecureData(
        key: LocalStorageKey.biometricLocked, value: value.toString());
  }

  Future<void> onChangedBiometricStorageStatus() async {
    final value = !enableBiometricUnlock.value;
    try {
      Get.find<SettingsController>().rxLoadedSettings.value = LoadedType.start;

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
      Get.find<SettingsController>().rxLoadedSettings.value = LoadedType.finish;
    }
  }

  void checkUpdateBiometric() async {
    await DidChangeAuthLocal.instance.onCheckBiometric().then((value) async {
      if (value == AuthLocalStatus.changed) {
        await Future.delayed(const Duration(seconds: 1)).then((value) {
          showAppDialog(
            Get.context!,
            TranslationConstants.biometricDataUpdated.tr,
            TranslationConstants.biometricUpdatedMessage.tr,
            confirmButtonText: TranslationConstants.ok.tr,
            checkTimeout: false,
            confirmButtonCallback: () async {
              enableBiometricUnlock.value = false;
              await localUseCase.saveSecureData(
                  key: LocalStorageKey.biometricLocked, value: 'false');
              Get.back();
            },
          );
        });
      }
    });
  }

  Future<void> init() async {
    await getBiometricStorageStatus();
    if (enableBiometricUnlock.value) {
      checkUpdateBiometric();
    }
  }
}
