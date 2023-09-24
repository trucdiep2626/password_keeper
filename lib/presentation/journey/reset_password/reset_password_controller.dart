import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/app_validator.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class ResetPasswordController extends GetxController with MixinController {
  final emailController = TextEditingController();

  final emailFocusNode = FocusNode();

  RxString errorText = ''.obs;

  RxString emailValidate = ''.obs;

  RxBool emailHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;
  final AccountUseCase accountUseCase;

  ResetPasswordController({required this.accountUseCase});

  void checkButtonEnable() {
    if (emailController.text.trim().isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void onChangedEmail() {
    checkButtonEnable();
    emailValidate.value = '';
  }

  Future<void> onPressedReset() async {
    if (buttonEnable.value) {
      await handleReset();
    }
  }

  Future<void> handleReset() async {
    hideKeyboard();
    errorText.value = '';
    emailValidate.value = AppValidator.validateEmail(emailController);

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    if (emailValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      try {
        await accountUseCase
            .sendPasswordResetEmail(emailController.text.trim());

        debugPrint('reset thành công');

        if (Get.context != null) {
          showTopSnackBar(Get.context!,
              type: SnackBarType.done,
              message: TranslationConstants.resetPasswordSentSuccessfully.tr);
          Get.back();
        }
      } on FirebaseAuthException catch (e) {
        if (Get.context != null) {
          showTopSnackBarError(
            Get.context!,
            e.message ?? TranslationConstants.unknownError.tr,
          );
        }
      } finally {
        rxLoadedButton.value = LoadedType.finish;
      }
    }
  }

  onPressLogin() {
    Get.back();
  }

  @override
  void onReady() async {
    super.onReady();
    emailFocusNode.addListener(() {
      emailHasFocus.value = emailFocusNode.hasFocus;
    });
  }
}
