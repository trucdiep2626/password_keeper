import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/app_validator.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class RegisterController extends GetxController with MixinController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final fullNameFocusNode = FocusNode();

  RxString errorText = ''.obs;

  RxString emailValidate = ''.obs;
  RxString passwordValidate = ''.obs;
  RxString confirmPasswordValidate = ''.obs;
  RxString fullNameValidate = ''.obs;

  RxBool emailHasFocus = false.obs;
  RxBool pwdHasFocus = false.obs;
  RxBool confirmPwdHasFocus = false.obs;
  RxBool fullNameHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;
  AccountUseCase accountUsecase;

  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;

  RegisterController({required this.accountUsecase});

  void checkButtonEnable() {
    if (emailController.text.trim().isNotEmpty &&
            passwordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty
        // && fullNameController.text.trim().isNotEmpty
        ) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void onChangedShowPassword() {
    showPassword.value = !(showPassword.value);
  }

  void onChangedShowConfirmPwd() {
    showConfirmPassword.value = !(showConfirmPassword.value);
  }

  void postRegister() async {
    rxLoadedButton.value = LoadedType.start;
    hideKeyboard();
    errorText.value = '';
    emailValidate.value = AppValidator.validateEmail(emailController);
    passwordValidate.value = AppValidator.validatePassword(passwordController);

    confirmPasswordValidate.value = AppValidator.validateConfirmPassword(
        passwordController, confirmPasswordController);

    // fullNameValidate.value = AppValidator.validateName(
    //   fullNameController,
    // );

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.context != null) {
        showTopSnackBarError(
            Get.context!, TransactionConstants.noConnectionError.tr);
      }
      rxLoadedButton.value = LoadedType.finish;
      return;
    }

    if (emailValidate.value.isEmpty &&
        passwordValidate.value.isEmpty &&
        //    fullNameValidate.value.isEmpty &&
        confirmPasswordValidate.value.isEmpty) {
      try {
        final result = await accountUsecase.signUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (result != null) {
          debugPrint('đăng ký thành công');

          Get.toNamed(AppRoutes.verifyEmail);
        }
        // else {
        //   showTopSnackBarError(context, TransactionConstants.unknownError.tr);
        //   //
        //   // } else {
        //   //   debugPrint('đăng nhập thất bại');
        //   //   errorText.value = TransactionConstants.loginError.tr;
        // }

      } on FirebaseAuthException catch (e) {
        handleAuthException(e.code);
      }
    }

    rxLoadedButton.value = LoadedType.finish;
  }

  void handleAuthException(String code) {
    String message = '';
    switch (code) {
      case 'email-already-in-use':
        message = TransactionConstants.existingEmail.tr;
        break;
      case 'invalid-email':
        message = TransactionConstants.invalidEmail.tr;
        break;
      case 'operation-not-allowed':
        message = TransactionConstants.unknownError.tr;
        break;
      case 'weak-password':
        message = TransactionConstants.weakPasswordError.tr;
        break;
      default:
        message = TransactionConstants.unknownError.tr;
    }

    showTopSnackBarError(context, message);
  }

  void onChangedEmail() {
    checkButtonEnable();
    emailValidate.value = '';
  }

  void onTapEmailTextField() {
    pwdHasFocus.value = false;
    //  fullNameHasFocus.value = false;
    emailHasFocus.value = true;
    confirmPwdHasFocus.value = false;
  }

  void onEditingCompleteEmail() {
    pwdHasFocus.value = true;
    emailHasFocus.value = false;
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  void onChangedConfirmPwd() {
    checkButtonEnable();
    confirmPasswordValidate.value = '';
  }

  void onTapPwdTextField() {
    confirmPwdHasFocus.value = false;
    pwdHasFocus.value = true;
    //  fullNameHasFocus.value = false;
    emailHasFocus.value = false;
  }

  void onEditingCompletePwd() {
    confirmPwdHasFocus.value = true;
    pwdHasFocus.value = false;
    FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
  }

  void onChangedPwd() {
    checkButtonEnable();
    passwordValidate.value = '';
  }

  void onTapConfirmPwdTextField() {
    pwdHasFocus.value = false;
    fullNameHasFocus.value = false;
    emailHasFocus.value = false;
    confirmPwdHasFocus.value = true;
  }

  void onEditingCompleteConfirmPwd() {
    confirmPwdHasFocus.value = false;
    FocusScope.of(context).unfocus();
    if (buttonEnable.value) {
      postRegister();
    }
  }

  void onChangedFullName() {
    checkButtonEnable();
    fullNameValidate.value = '';
  }

  void onTapFullNameTextField() {
    pwdHasFocus.value = false;
    fullNameHasFocus.value = true;
    emailHasFocus.value = false;
    confirmPwdHasFocus.value = false;
  }

  void onEditingCompleteFullName() {
    fullNameHasFocus.value = false;
    emailHasFocus.value = true;
    FocusScope.of(context).requestFocus(emailFocusNode);
  }

  void onPressedRegister() {
    pwdHasFocus.value = false;
    fullNameHasFocus.value = false;
    emailHasFocus.value = false;
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
    emailFocusNode.addListener(() {
      emailHasFocus.value = emailFocusNode.hasFocus;
    });
    passwordFocusNode.addListener(() {
      pwdHasFocus.value = passwordFocusNode.hasFocus;
    });
    // fullNameFocusNode.addListener(() {
    //   fullNameHasFocus.value = fullNameFocusNode.hasFocus;
    // });
    confirmPasswordFocusNode.addListener(() {
      confirmPwdHasFocus.value = confirmPasswordFocusNode.hasFocus;
    });
  }
}
