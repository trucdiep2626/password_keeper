import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/screen_capture_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';

class SettingsController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedSettings = LoadedType.finish.obs;

  AccountUseCase accountUseCase;
  LocalUseCase localUseCase;

  final _cryptoController = Get.find<CryptoController>();
  final _screenCaptureController = Get.find<ScreenCaptureController>();

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
      try {
        //check internet connection
        final isConnected = await checkConnectivity();
        if (!isConnected) {
          return;
        }

        rxLoadedSettings.value = LoadedType.start;

        await _screenCaptureController.resetWhenLogOut();
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
}
