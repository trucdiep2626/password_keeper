import 'dart:async';

import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class VerifyEmailController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;
  late Timer _timer;

  AccountUseCase accountUseCase;

  VerifyEmailController({required this.accountUseCase});

  void onPressedContinueButton() async {
    await accountUseCase.user?.reload();
    if (accountUseCase.user?.emailVerified ?? false) {
      Get.toNamed(AppRoutes.createMasterPassword);
    }
  }

  Future<void> sendVerifyEmail() async {
    try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      await accountUseCase.sendEmailVerification();
      if (Get.context != null) {
        showTopSnackBar(
          Get.context!,
          type: SnackBarType.done,
          message: TranslationConstants.verificationSent.tr,
        );
      }
    } catch (e) {
      showTopSnackBarError(context, e.toString());
    }
  }

  void setTimeForAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await accountUseCase.user?.reload();
      if (accountUseCase.user?.emailVerified ?? false) {
        timer.cancel();
        Get.toNamed(AppRoutes.createMasterPassword);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    sendVerifyEmail();
    setTimeForAutoRedirect();
  }
}
