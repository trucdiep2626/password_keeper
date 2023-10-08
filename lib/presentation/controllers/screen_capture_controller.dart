import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/widgets/snack_bar/app_snack_bar.dart';

class ScreenCaptureController extends GetxController with MixinController {
  RxBool allowScreenCapture = false.obs;

  final SettingsController _settingsController = Get.find<SettingsController>();

  final AccountUseCase accountUseCase;

  User? get user => accountUseCase.user;

  ScreenCaptureController({
    required this.accountUseCase,
  });

  Future<void> getAllowScreenCapture() async {
    try {
      _settingsController.rxLoadedSettings.value = LoadedType.start;

      final allowCapture =
          await accountUseCase.getAllowScreenCapture(usedId: user?.uid ?? '');
      allowScreenCapture.value = allowCapture;
      await handleChangeAllowScreenCaptureLocal();
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      _settingsController.rxLoadedSettings.value = LoadedType.finish;
    }
  }

  Future<void> onChangedAllowScreenCapture() async {
    await handleChangeAllowScreenCapture(!allowScreenCapture.value);
    if (allowScreenCapture.value) {
      if (Get.context != null) {
        showTopSnackBar(Get.context!,
            message: TranslationConstants.enableScreenCapture.tr);
      }
    } else {
      if (Get.context != null) {
        showTopSnackBar(Get.context!,
            message: TranslationConstants.disableScreenCapture.tr);
      }
    }
  }

  Future<void> handleChangeAllowScreenCapture(bool value) async {
    try {
      _settingsController.rxLoadedSettings.value = LoadedType.start;

      await accountUseCase.updateAllowScreenCapture(
        userId: user?.uid ?? '',
        value: value,
      );
      allowScreenCapture.value = value;
      await handleChangeAllowScreenCaptureLocal();
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      _settingsController.rxLoadedSettings.value = LoadedType.finish;
    }
  }

  Future<void> handleChangeAllowScreenCaptureLocal() async {
    try {
      if (allowScreenCapture.value) {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    }
  }

  Future<void> resetWhenLogOut() async {
    allowScreenCapture.value = false;
    await handleChangeAllowScreenCaptureLocal();
  }

  @override
  void onReady() async {
    super.onReady();
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
