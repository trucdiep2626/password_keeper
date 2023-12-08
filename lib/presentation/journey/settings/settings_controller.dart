import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/constants.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/screen_capture_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';

class SettingsController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedSettings = LoadedType.finish.obs;

  RxInt selectedTimeout = Constants.timeout.obs;
  RxInt selectedTimingAlert = Constants.timingAlert.obs;

  Timer? _timer;

  AccountUseCase accountUseCase;
  LocalUseCase localUseCase;
  PasswordUseCase passwordUseCase;

  User? get user => accountUseCase.user;

  SettingsController({
    required this.accountUseCase,
    required this.localUseCase,
    required this.passwordUseCase,
  });

  void onSelectedTimeOut({required String type, required int timeout}) async {
    if (type == TranslationConstants.hours.tr) {
      selectedTimeout.value = timeout * 3600;
    } else if (type == TranslationConstants.minutes.tr) {
      selectedTimeout.value = timeout * 60;
    } else if (type == TranslationConstants.seconds.tr) {
      selectedTimeout.value = timeout;
    }
    await updateTimeoutSetting();
  }

  Future<void> updateTimeoutSetting() async {
    try {
      rxLoadedSettings.value = LoadedType.start;

      await accountUseCase.updateTimeoutSetting(
        userId: user?.uid ?? '',
        timeout: selectedTimeout.value,
      );
      handleUserInteraction();
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedSettings.value = LoadedType.finish;
    }
  }

  Future<void> getTimeoutSetting() async {
    try {
      rxLoadedSettings.value = LoadedType.start;

      final timeout =
          await accountUseCase.getTimeoutSetting(usedId: user?.uid ?? '');
      selectedTimeout.value = timeout;

      log('get timeout setting: $timeout');
      handleUserInteraction();
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedSettings.value = LoadedType.finish;
    }
  }

  Future<void> getAlertSetting() async {
    try {
      rxLoadedSettings.value = LoadedType.start;

      final timingAlert =
          await accountUseCase.getAlertSetting(usedId: user?.uid ?? '');
      selectedTimingAlert.value = timingAlert;

      log('get timingAlert setting: $timingAlert');
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedSettings.value = LoadedType.finish;
    }
  }

  Future<void> onTapLock() async {
    await accountUseCase.lock();
    _timer?.cancel();
    _timer = null;
    Get.offAllNamed(AppRoutes.verifyMasterPassword);
  }

  Future<void> onTapLogout() async {
    showAppDialog(context, TranslationConstants.logout.tr,
        TranslationConstants.logoutConfirmMessage.tr,
        confirmButtonText: TranslationConstants.logout.tr,
        cancelButtonText: TranslationConstants.cancel.tr,
        confirmButtonCallback: () async {
      try {
        //check internet connection
        final isConnected = await checkConnectivity();
        if (!isConnected) {
          return;
        }

        rxLoadedSettings.value = LoadedType.start;
        _timer?.cancel();
        _timer = null;

        await Get.find<ScreenCaptureController>().resetWhenLogOut();
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
      } finally {
        rxLoadedSettings.value = LoadedType.finish;
      }
    });
  }

  Future<void> onTapDeleteAccount() async {
    showAppDialog(context, TranslationConstants.deleteAccount.tr,
        TranslationConstants.deleteConfirmMessage.tr,
        confirmButtonText: TranslationConstants.confirm.tr,
        cancelButtonText: TranslationConstants.cancel.tr,
        confirmButtonCallback: () async {
      try {
        //check internet connection
        final isConnected = await checkConnectivity();
        if (!isConnected) {
          return;
        }

        rxLoadedSettings.value = LoadedType.start;
        _timer?.cancel();
        _timer = null;
        await Get.find<ScreenCaptureController>().resetWhenLogOut();
        await accountUseCase.deleteAccount(user?.uid ?? '');

        Get.offAllNamed(AppRoutes.login);
      } catch (e) {
        debugPrint(e.toString());
        showErrorMessage();
      } finally {
        rxLoadedSettings.value = LoadedType.finish;
      }
    });
  }

  Future<void> updateScheduleTimingAlert(int time) async {
    try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      rxLoadedSettings.value = LoadedType.start;
      selectedTimingAlert.value = time;
      accountUseCase.updateAlertSetting(
          userId: user?.uid ?? '', time: selectedTimingAlert.value);
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedSettings.value = LoadedType.finish;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getTimeoutSetting();
    await getAlertSetting();
  }

  void _initializeTimer() {
    log('reset');
    log(DateTime.now().toIso8601String());
    if (_timer != null) {
      log('not null');
      _timer!.cancel();
    }

    _timer = Timer(Duration(seconds: selectedTimeout.value), _logOutUser);
  }

  void _logOutUser() async {
    _timer?.cancel();

    if (!(Get.currentRoute == AppRoutes.register ||
        Get.currentRoute == AppRoutes.login ||
        Get.currentRoute == AppRoutes.verifyEmail ||
        Get.currentRoute == AppRoutes.verifyMasterPassword ||
        Get.currentRoute == AppRoutes.verifyMasterPassword ||
        Get.currentRoute == AppRoutes.resetPassword)) {
      log(' lock app');
      log(DateTime.now().toIso8601String());
      _timer?.cancel();
      _timer = null;
      await onTapLock();
    }
  }

  void handleUserInteraction([_]) {
    if ((Get.currentRoute == AppRoutes.register ||
        Get.currentRoute == AppRoutes.login ||
        Get.currentRoute == AppRoutes.verifyEmail ||
        Get.currentRoute == AppRoutes.createMasterPassword ||
        Get.currentRoute == AppRoutes.verifyMasterPassword ||
        Get.currentRoute == AppRoutes.resetPassword)) {
      return;
    }
    _initializeTimer();
  }

  String getTimeoutString(int timeout) {
    if (timeout >= 3600) {
      return '${timeout ~/ 3600} ${TranslationConstants.hours.tr}';
    } else if (timeout >= 60) {
      return '${timeout ~/ 60} ${TranslationConstants.minutes.tr}';
    } else {
      return '$timeout ${TranslationConstants.seconds.tr}';
    }
  }

  String getTimingAlertString(int time) {
    return '${millisecondsToDays(time)} ${TranslationConstants.days.tr}';
  }

  int getTimeoutIndex() {
    if (selectedTimeout.value >= 3600) {
      return (selectedTimeout.value ~/ 3600) - 1;
    } else if (selectedTimeout.value >= 60) {
      return (selectedTimeout.value ~/ 60) - 1;
    } else {
      return selectedTimeout.value - 1;
    }
  }

  int getTypeIndex() {
    if (selectedTimeout.value >= 3600) {
      return 0;
    } else if (selectedTimeout.value >= 60) {
      return 1;
    } else {
      return 2;
    }
  }
}
