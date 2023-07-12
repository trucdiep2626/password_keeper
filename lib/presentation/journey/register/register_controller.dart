import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();

  //RxString errorText = ''.obs;

  RxString emailValidate = ''.obs;
  RxString passwordValidate = ''.obs;
  RxString confirmPasswordValidate = ''.obs;
  RxString firstNameValidate = ''.obs;
  RxString lastNameValidate = ''.obs;

  RxBool emailHasFocus = false.obs;
  RxBool pwdHasFocus = false.obs;
  RxBool confirmPwdHasFocus = false.obs;
  RxBool firstNameHasFocus = false.obs;
  RxBool lastNameHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;
  AccountUseCase accountUsecase;

  //final mainController = Get.find<MainController>();

  RegisterController({required this.accountUsecase});

  void checkButtonEnable() {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        firstNameController.text.trim().isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void postRegister() async {
    rxLoadedButton.value = LoadedType.start;
    hideKeyboard();
    // errorText.value = '';
    emailValidate.value = AppValidator.validateEmail(emailController);
    passwordValidate.value = AppValidator.validatePassword(passwordController);
    if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordValidate.value = 'Your confirm password is incorrect';
    } else {
      confirmPasswordValidate.value = '';
    }
    // firstNameValidate.value = AppValidator.validateName(
    //   TransactionConstants.firstName.tr,
    //   firstNameController,
    // );
    // lastNameValidate.value = AppValidator.validateName(
    //   TransactionConstants.lastName.tr,
    //   lastNameController,
    // );

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showTopSnackBarError(context, TransactionConstants.noConnectionError.tr);
      rxLoadedButton.value = LoadedType.finish;
      return;
    }

    // if (emailValidate.value.isEmpty &&
    //     passwordValidate.value.isEmpty &&
    //     firstNameValidate.value.isEmpty &&
    //     confirmPasswordValidate.value.isEmpty &&
    //     lastNameValidate.value.isEmpty) {
    //   final result = await accountUsecase.register(
    //     username: emailController.text.trim(),
    //     password: passwordController.text.trim(),
    //     firstName: firstNameController.text.trim(),
    //     lastName: lastNameController.text.trim(),
    //   );
    //
    //   if (result) {
    //     debugPrint('đăng ký thành công');
    //     showTopSnackBar(context,
    //         message: TransactionConstants.successfully.tr,
    //         type: SnackBarType.done);
    //     Get.back();
    //   }
    //   // else {
    //   //   showTopSnackBarError(context, TransactionConstants.unknownError.tr);
    //   //   //
    //   //   // } else {
    //   //   //   debugPrint('đăng nhập thất bại');
    //   //   //   errorText.value = TransactionConstants.loginError.tr;
    //   // }
    // }

    rxLoadedButton.value = LoadedType.finish;
  }

  void onChangedEmail() {
    checkButtonEnable();
    emailValidate.value = '';
  }

  void onTapEmailTextField() {
    pwdHasFocus.value = false;
    lastNameHasFocus.value = false;
    firstNameHasFocus.value = false;
    emailHasFocus.value = true;
    confirmPwdHasFocus.value = false;
  }

  void onEditingCompleteEmail() {
    pwdHasFocus.value = true;
    emailHasFocus.value = false;
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  void onChangedPwd() {
    checkButtonEnable();
    confirmPasswordValidate.value = '';
  }

  void onTapPwdTextField() {
    confirmPwdHasFocus.value = false;
    pwdHasFocus.value = true;
    lastNameHasFocus.value = false;
    firstNameHasFocus.value = false;
    emailHasFocus.value = false;
  }

  void onEditingCompletePwd() {
    confirmPwdHasFocus.value = true;
    pwdHasFocus.value = false;
    FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
  }

  void onChangedConfirmPwd() {
    checkButtonEnable();
    passwordValidate.value = '';
  }

  void onTapConfirmPwdTextField() {
    pwdHasFocus.value = false;
    lastNameHasFocus.value = false;
    firstNameHasFocus.value = false;
    emailHasFocus.value = false;
    confirmPwdHasFocus.value = true;
  }

  void onEditingCompleteConfirmPwd() {
    confirmPwdHasFocus.value = false;
    firstNameHasFocus.value = true;
    FocusScope.of(context).requestFocus(firstNameFocusNode);
  }

  void onChangedFirstName() {
    checkButtonEnable();
    firstNameValidate.value = '';
  }

  void onTapFirstNameTextField() {
    pwdHasFocus.value = false;
    lastNameHasFocus.value = false;
    firstNameHasFocus.value = true;
    emailHasFocus.value = false;
    confirmPwdHasFocus.value = false;
  }

  void onEditingCompleteFirstName() {
    firstNameHasFocus.value = false;
    lastNameHasFocus.value = true;
    FocusScope.of(context).requestFocus(lastNameFocusNode);
  }

  void onChangedLastName() {
    checkButtonEnable();
    lastNameValidate.value = '';
  }

  void onTapLastNameTextField() {
    pwdHasFocus.value = false;
    lastNameHasFocus.value = true;
    firstNameHasFocus.value = false;
    emailHasFocus.value = false;
    confirmPwdHasFocus.value = false;
  }

  void onEditingCompleteLastName() {
    lastNameHasFocus.value = false;
    FocusScope.of(context).unfocus();
    if (buttonEnable.value) {
      postRegister();
    }
  }

  void onPressedRegister() {
    pwdHasFocus.value = false;
    lastNameHasFocus.value = false;
    firstNameHasFocus.value = false;
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
  }
}
