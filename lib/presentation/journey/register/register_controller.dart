import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/app_validator.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

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
  Rx<LoadedType> rxLoadedGoogleButton = LoadedType.finish.obs;
  AccountUseCase accountUsecase;

  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;

  RegisterController({required this.accountUsecase});

  void checkButtonEnable() {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        fullNameController.text.trim().isNotEmpty) {
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

  Future<void> onTapGoogleSignIn() async {
    hideKeyboard();
    errorText.value = '';

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    try {
      rxLoadedGoogleButton.value = LoadedType.start;
      final result = await accountUsecase.signInWithGoogle();

      if (result != null) {
        await accountUsecase.setUserCredential(authCredential: result);
        debugPrint('đăng ký thành công');

        Get.toNamed(AppRoutes.createMasterPassword);
      } else {
        showErrorMessage();
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseException(
        code: e.code,
      );
    } finally {
      rxLoadedGoogleButton.value = LoadedType.finish;
    }
  }

  void postRegister() async {
    hideKeyboard();
    errorText.value = '';
    emailValidate.value = AppValidator.validateEmail(emailController);
    passwordValidate.value = AppValidator.validatePassword(passwordController);

    confirmPasswordValidate.value = AppValidator.validateConfirmPassword(
        passwordController, confirmPasswordController);

    fullNameValidate.value = AppValidator.validateName(
      fullNameController,
    );

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    if (emailValidate.value.isEmpty &&
        passwordValidate.value.isEmpty &&
        fullNameValidate.value.isEmpty &&
        confirmPasswordValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      try {
        await accountUsecase.signUpWithEmail(
          fullname: fullNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // if (result != null) {
        //    await accountUsecase.setUserCredential(authCredential: result);
        debugPrint('đăng ký thành công');

        Get.toNamed(AppRoutes.verifyEmail);
        //    }
        // else {
        //   showTopSnackBarError(context, TranslationConstants.unknownError.tr);
        //   //
        //   // } else {
        //   //   debugPrint('đăng nhập thất bại');
        //   //   errorText.value = TranslationConstants.loginError.tr;
        // }
      } on FirebaseAuthException catch (e) {
        handleFirebaseException(
          code: e.code,
        );
      } finally {
        rxLoadedGoogleButton.value = LoadedType.finish;
      }
    }
  }

  void onChangedEmail() {
    checkButtonEnable();
    emailValidate.value = '';
  }

  void onEditingCompleteEmail() {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  void onChangedConfirmPwd() {
    checkButtonEnable();
    confirmPasswordValidate.value = '';
  }

  void onEditingCompletePwd() {
    FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
  }

  void onChangedPwd() {
    checkButtonEnable();
    passwordValidate.value = '';
  }

  void onEditingCompleteConfirmPwd() {
    FocusScope.of(context).unfocus();
    if (buttonEnable.value) {
      postRegister();
    }
  }

  void onChangedFullName() {
    checkButtonEnable();
    fullNameValidate.value = '';
  }

  void onEditingCompleteFullName() {
    FocusScope.of(context).requestFocus(emailFocusNode);
  }

  void onPressedRegister() {
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
    fullNameFocusNode.addListener(() {
      fullNameHasFocus.value = fullNameFocusNode.hasFocus;
    });
    confirmPasswordFocusNode.addListener(() {
      confirmPwdHasFocus.value = confirmPasswordFocusNode.hasFocus;
    });
  }
}
