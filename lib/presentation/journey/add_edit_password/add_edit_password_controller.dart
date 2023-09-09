import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/snack_bar/app_snack_bar.dart';

class AddEditPasswordController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;

  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  final noteController = TextEditingController();

  final userIdFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final noteFocusNode = FocusNode();

  RxString errorText = ''.obs;

  RxString userIdValidate = ''.obs;
  RxString passwordValidate = ''.obs;

  RxBool buttonEnable = false.obs;

  // RxBool userIdHasFocus = false.obs;
  // RxBool pwdHasFocus = false.obs;
  // RxBool noteHasFocus = false.obs;

  AccountUseCase accountUseCase;
  PasswordUseCase passwordUseCase;

  RxBool showPassword = false.obs;

  AddEditPasswordController({
    required this.accountUseCase,
    required this.passwordUseCase,
  });

  User? get user => accountUseCase.user;

  void onChangedShowPassword() {
    showPassword.value = !showPassword.value;
  }

  void checkButtonEnable() {
    if (userIdController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void handleSave() async {
    hideKeyboard();
    errorText.value = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.context != null) {
        showTopSnackBarError(
            Get.context!, TranslationConstants.noConnectionError.tr);
      }
      rxLoadedButton.value = LoadedType.finish;
      return;
    }

    if (userIdValidate.value.isEmpty && passwordValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;

      try {} catch (e) {}
    }

    rxLoadedButton.value = LoadedType.finish;
  }

  void onChangedUserId() {
    checkButtonEnable();
    userIdValidate.value = '';
  }

  void onTapUserIdTextField() {
    // pwdHasFocus.value = false;
    // userIdHasFocus.value = true;
    // noteHasFocus.value = false;
  }

  void onEditingCompleteUserId() {
    // userIdHasFocus.value = false;
    // pwdHasFocus.value = true;
    // noteHasFocus.value = false;
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  void onChangedPwd() {
    checkButtonEnable();
    passwordValidate.value = '';
  }

  void onTapPwdTextField() {
    // userIdHasFocus.value = false;
    // pwdHasFocus.value = true;
    // noteHasFocus.value = false;
  }

  void onEditingCompletePwd() {
    //   pwdHasFocus.value = false;
    FocusScope.of(context).unfocus();
  }

  void onEditingCompleteNote() {
    //  noteHasFocus.value = false;
    FocusScope.of(context).unfocus();
  }

  void onTapNoteTextField() {
    // pwdHasFocus.value = false;
    // noteHasFocus.value = true;
    // userIdHasFocus.value = false;
  }

  void onPressedSave() {
    // pwdHasFocus.value = false;
    //   userIdHasFocus.value = false;
    // noteHasFocus.value = false;
    if (buttonEnable.value) {
      handleSave();
    }
  }

  onPressPickLocationOrApp() {
    Get.toNamed(AppRoutes.signInLocation);
  }

  @override
  void onReady() async {
    super.onReady();
    // userIdFocusNode.addListener(() {
    //   userIdHasFocus.value = userIdFocusNode.hasFocus;
    // });
    // passwordFocusNode.addListener(() {
    //   pwdHasFocus.value = passwordFocusNode.hasFocus;
    // });
    // noteFocusNode.addListener(() {
    //   noteHasFocus.value = passwordFocusNode.hasFocus;
    // });
  }
}
