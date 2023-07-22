import 'package:connectivity_plus/connectivity_plus.dart';
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

  AccountUseCase accountUsecase;

  RxBool showPassword = false.obs;

  LoginController({required this.accountUsecase});

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
    rxLoadedButton.value = LoadedType.start;
    hideKeyboard();
    errorText.value = '';
    // emailValidate.value = AppValidator.validateEmail(emailController);
    // passwordValidate.value = AppValidator.validatePassword(passwordController);

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.context != null) {
        showTopSnackBarError(
            Get.context!, TransactionConstants.noConnectionError.tr);
      }
      rxLoadedButton.value = LoadedType.finish;
      return;
    }

    // if (emailValidate.value.isEmpty && passwordValidate.value.isEmpty) {
    //   final result = await accountUsecase.login(
    //       username: emailController.text.trim(),
    //       password: passwordController.text.trim());
    //
    //   try {
    //     if (result != null) {
    //       debugPrint('đăng nhập thành công');
    //       await accountUsecase.saveToken(result);
    //       //   mainController.token.value = result;
    //       await accountUsecase.saveEmail(emailController.text.trim());
    //       await accountUsecase.savePass(passwordController.text.trim());
    //       final customerInfo = await accountUsecase.getCustomerInformation();
    //
    //       if (customerInfo != null) {
    //         await accountUsecase.saveCustomerInformation(customerInfo);
    //         //  mainController.rxCustomer.value = customerInfo;
    //         // mainController.updateLogin();
    //         //go to main screen
    Get.toNamed(AppRoutes.verifyMasterPassword);
    //         Get.offNamed(AppRoutes.main);
    //       } else {
    //         showTopSnackBarError(context, TransactionConstants.unknownError.tr);
    //       }
    //     } else {
    //       debugPrint('đăng nhập thất bại');
    //    //   errorText.value = TransactionConstants.loginError.tr;
    //     }
    //   } catch (e) {
    //     debugPrint(e.toString());
    //     showTopSnackBarError(context, TransactionConstants.unknownError.tr);
    //   }
    // }


    rxLoadedButton.value = LoadedType.finish;
  }

  void onChangedEmail() {
    checkButtonEnable();
    emailValidate.value = '';
  }

  void onTapEmailTextField() {
    pwdHasFocus.value = false;
    emailHasFocus.value = true;
  }

  void onEditingCompleteEmail() {
    emailHasFocus.value = false;
    pwdHasFocus.value = true;
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  void onChangedPwd() {
    checkButtonEnable();
    passwordValidate.value = '';
  }

  void onTapPwdTextField() {
    emailHasFocus.value = false;
    pwdHasFocus.value = true;
  }

  void onEditingCompletePwd() {
    pwdHasFocus.value = false;
    FocusScope.of(context).unfocus();
    if (buttonEnable.value) {
      postLogin();
    }
  }

  void onPressedLogIn() {
    pwdHasFocus.value = false;
    emailHasFocus.value = false;
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
