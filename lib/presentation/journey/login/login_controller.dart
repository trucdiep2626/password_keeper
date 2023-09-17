import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class LoginController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  RxString errorText = ''.obs;

  RxString emailValidate = ''.obs;
  RxString passwordValidate = ''.obs;

  RxBool buttonEnable = false.obs;
  RxBool emailHasFocus = false.obs;
  RxBool pwdHasFocus = false.obs;
  Rx<LoadedType> rxLoadedGoogleButton = LoadedType.finish.obs;

  AccountUseCase accountUsecase;

  RxBool showPassword = false.obs;

  LoginController({required this.accountUsecase});

  User? get user => accountUsecase.user;

  void onChangedShowPassword() {
    showPassword.value = !showPassword.value;
  }

  void checkButtonEnable() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void postLogin() async {
    hideKeyboard();
    errorText.value = '';

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    if (emailValidate.value.isEmpty && passwordValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;

      try {
        final result = await accountUsecase.loginWithEmail(
            email: emailController.text.trim(),
            password: passwordController.text.trim());

        //  if (result != null) {
        debugPrint('đăng nhập thành công');
        //   await accountUsecase.setUserCredential(authCredential: result);

        if (user?.emailVerified ?? false) {
          final profile =
              await accountUsecase.getProfile(userId: user?.uid ?? '');

          if (profile != null) {
            Get.toNamed(AppRoutes.verifyMasterPassword);
          } else {
            Get.toNamed(AppRoutes.createMasterPassword);
          }
        } else {
          Get.toNamed(AppRoutes.verifyEmail);
        }
        //  }
      } on FirebaseAuthException catch (e) {
        handleFirebaseException(
          code: e.code,
          isSignIn: true,
        );
      } finally {
        rxLoadedButton.value = LoadedType.finish;
      }
    }
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

        final profile =
            await accountUsecase.getProfile(userId: user?.uid ?? '');

        if (profile != null) {
          Get.toNamed(AppRoutes.verifyMasterPassword);
        } else {
          Get.toNamed(AppRoutes.createMasterPassword);
        }
      } else {
        if (Get.context != null) {
          showTopSnackBarError(
              Get.context!, TranslationConstants.unknownError.tr);
        }
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseException(
        code: e.code,
        isSignIn: true,
      );
    } finally {
      rxLoadedGoogleButton.value = LoadedType.finish;
    }
  }

  void onChangedEmail() {
    checkButtonEnable();
  }

  void onEditingCompleteEmail() {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  void onChangedPwd() {
    checkButtonEnable();
  }

  void onEditingCompletePwd() {
    FocusScope.of(context).unfocus();
    if (buttonEnable.value) {
      postLogin();
    }
  }

  void onPressedLogIn() {
    if (buttonEnable.value) {
      postLogin();
    }
  }

  onPressForgotPassword() {
    //  Get.toNamed(AppRoutes.forgotPassword);
  }

  onPressRegister() {
    Get.toNamed(AppRoutes.register);
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
  }
}
