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

class CreateMasterPasswordController extends GetxController
    with MixinController {
  final masterPwdController = TextEditingController();
  final confirmMasterPwdController = TextEditingController();
  final masterPwdHintController = TextEditingController();

  final masterPwdFocusNode = FocusNode();
  final confirmMasterPwdFocusNode = FocusNode();
  final masterPwdHintFocusNode = FocusNode();

  RxString errorText = ''.obs;

  RxString masterPwdValidate = ''.obs;
  RxString confirmMasterPwdValidate = ''.obs;
  RxString masterPwdHintValidate = ''.obs;

  RxBool masterPwdHasFocus = false.obs;
  RxBool confirmMasterPwdHasFocus = false.obs;
  RxBool masterPwdHintHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;
  AccountUseCase accountUsecase;

  RxBool showMasterPwd = false.obs;
  RxBool showConfirmMasterPwd = false.obs;

  CreateMasterPasswordController({required this.accountUsecase});

  void checkButtonEnable() {
    if (masterPwdController.text.isNotEmpty &&
        confirmMasterPwdController.text.isNotEmpty &&
        masterPwdHintController.text.trim().isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  void onChangedShowMasterPwd() {
    showMasterPwd.value = !(showMasterPwd.value);
  }

  void onChangedShowConfirmPwd() {
    showConfirmMasterPwd.value = !(showConfirmMasterPwd.value);
  }

  void postRegister() async {
    rxLoadedButton.value = LoadedType.start;
    hideKeyboard();
    masterPwdValidate.value =
        AppValidator.validatePassword(masterPwdController);

    confirmMasterPwdValidate.value = AppValidator.validateConfirmPassword(
        masterPwdController, confirmMasterPwdController);

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.context != null) {
        showTopSnackBarError(
            Get.context!, TransactionConstants.noConnectionError.tr);
      }
      rxLoadedButton.value = LoadedType.finish;
      return;
    }

    // if (emailValidate.value.isEmpty &&
    //     masterPwdValidate.value.isEmpty &&
    //     masterPwdHintValidate.value.isEmpty &&
    //     confirmMasterPwdValidate.value.isEmpty &&
    //     lastNameValidate.value.isEmpty) {
    //   final result = await accountUsecase.register(
    //     username: emailController.text.trim(),
    //     masterPwd: masterPwdController.text.trim(),
    //     masterPwdHint: masterPwdHintController.text.trim(),
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

  void onTapPwdTextField() {
    confirmMasterPwdHasFocus.value = false;
    masterPwdHasFocus.value = true;
    masterPwdHintHasFocus.value = false;
  }

  void onEditingCompletePwd() {
    confirmMasterPwdHasFocus.value = true;
    masterPwdHasFocus.value = false;
    FocusScope.of(context).requestFocus(confirmMasterPwdFocusNode);
  }

  void onChangedPwd() {
    checkButtonEnable();
    masterPwdValidate.value = '';
  }

  void onChangedConfirmPwd() {
    checkButtonEnable();
    confirmMasterPwdValidate.value = '';
  }

  void onTapConfirmPwdTextField() {
    masterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = false;
    confirmMasterPwdHasFocus.value = true;
  }

  void onEditingCompleteConfirmPwd() {
    confirmMasterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = true;
    FocusScope.of(context).requestFocus(masterPwdHintFocusNode);
  }

  void onEditingCompleteMasterPwdHint() {
    masterPwdHintHasFocus.value = false;
    FocusScope.of(context).unfocus();
  }

  void onTapMasterPwdHintTextField() {
    masterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = true;
    confirmMasterPwdHasFocus.value = false;
  }



  void onPressedRegister() {
    masterPwdHasFocus.value = false;
    masterPwdHintHasFocus.value = false;
    confirmMasterPwdHasFocus.value = false;
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
    masterPwdFocusNode.addListener(() {
      masterPwdHasFocus.value = masterPwdFocusNode.hasFocus;
    });
    masterPwdHintFocusNode.addListener(() {
      masterPwdHintHasFocus.value = masterPwdHintFocusNode.hasFocus;
    });
    confirmMasterPwdFocusNode.addListener(() {
      confirmMasterPwdHasFocus.value = confirmMasterPwdFocusNode.hasFocus;
    });
  }
}
