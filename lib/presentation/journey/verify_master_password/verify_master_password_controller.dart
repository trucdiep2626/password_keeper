import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/app_validator.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/account.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/local_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class VerifyMasterPasswordController extends GetxController
    with MixinController {
  final masterPwdController = TextEditingController();

  final masterPwdFocusNode = FocusNode();

  RxString errorText = ''.obs;

  RxString masterPwdValidate = ''.obs;

  RxBool masterPwdHasFocus = false.obs;

  RxBool buttonEnable = false.obs;

  Rx<LoadedType> rxLoadedButton = LoadedType.finish.obs;
  AccountUseCase accountUseCase;
  LocalUseCase localUseCase;

  final CryptoController _cryptoController = Get.find<CryptoController>();

  RxBool showMasterPwd = false.obs;
  RxBool showConfirmMasterPwd = false.obs;

  VerifyMasterPasswordController({
    required this.accountUseCase,
    required this.localUseCase,
  });

  void checkButtonEnable() {
    if (masterPwdController.text.isNotEmpty) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  User? get user => accountUseCase.user;

  void onChangedShowMasterPwd() {
    showMasterPwd.value = !(showMasterPwd.value);
  }

  void onChangedShowConfirmPwd() {
    showConfirmMasterPwd.value = !(showConfirmMasterPwd.value);
  }

  Future<void> handleVerify() async {
    hideKeyboard();
    masterPwdValidate.value =
        AppValidator.validatePassword(masterPwdController);

    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    if (masterPwdValidate.value.isEmpty) {
      rxLoadedButton.value = LoadedType.start;
      final masterPassword = masterPwdController.text;
      final email = (user?.email ?? '').trim().toLowerCase();
      bool passwordValid = false;

      //make master key
      var key = await _cryptoController.makeKey(
        password: masterPassword,
        salt: email,
      );

      var storedHashedPassword = await _cryptoController.getKeyHash();

      if (!isNullEmpty(storedHashedPassword)) {
        passwordValid = await _cryptoController.compareKeyHash(
          masterPassword: masterPassword,
          key: key,
        );
      } else {
        var keyHash = await _cryptoController.hashPassword(
          password: masterPassword,
          key: key,
        );

        final profile =
            await accountUseCase.getProfile(userId: user?.uid ?? '');

        if (profile?.hashedMasterPassword != null &&
            profile?.hashedMasterPassword!.compareTo(keyHash) == 0) {
          passwordValid = true;
          await _cryptoController.setKeyHash(keyHash);
          await accountUseCase.setAccount(
              account: Account(
            profile: profile,
          ));
        }
      }

      if (passwordValid) {
        var hasKey = await _cryptoController.haskey();
        if (!hasKey) {
          await _cryptoController.setKey(key);
        }
        //    _cryptoController.setBiometricLocked();

        debugPrint('đăng ký thành công');
        // showTopSnackBar(context,
        //     message: TranslationConstants..tr,
        //     type: SnackBarType.done);
        Get.offAllNamed(AppRoutes.main);
      } else {
        // if (Get.context != null) {
        //   showTopSnackBarError(
        //       Get.context!, TranslationConstants.loginError.tr);
        // }
        //
        // } else {
        //   debugPrint('đăng nhập thất bại');
        errorText.value = TranslationConstants.wrongMasterPassword.tr;
      }

      //    }
    } else {
      // if (Get.context != null) {
      //   showTopSnackBarError(Get.context!, TranslationConstants.loginError.tr);
      // }
      //
      // } else {
      //   debugPrint('đăng nhập thất bại');
      errorText.value = TranslationConstants.loginError.tr;
    }

    rxLoadedButton.value = LoadedType.finish;
  }

  // Future<SymmetricCryptoKey?> makePreLoginKey() async {
  //   final masterPassword = masterPwdController.text;
  //   final email = (user.email ?? '').trim().toLowerCase();
  //
  //   if (email.isEmpty || masterPwdController.text.isEmpty) {
  //     return null;
  //   }
  //
  //   return await _cryptoController.makeKey(
  //     password: masterPassword,
  //     salt: email,
  //   );
  // }

  String? getUserId() {
    return accountUseCase.getAccount?.profile?.userId;
  }

  void onChangedPwd() {
    checkButtonEnable();
    masterPwdValidate.value = '';
  }

  Future<void> onPressedVerify() async {
    masterPwdHasFocus.value = false;
    FocusScope.of(context).unfocus();
    if (buttonEnable.value) {
      await handleVerify();
    }
  }

  Future<void> getMasterPasswordHint() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    try {
      await accountUseCase.sendPasswordHint(
          email: user?.email ?? '', userId: user?.uid ?? '');

      if (Get.context != null) {
        showTopSnackBar(
          Get.context!,
          message: TranslationConstants.masterPwdSentSuccessfully,
          type: SnackBarType.done,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      if (Get.context != null) {
        showTopSnackBarError(Get.context!, e.toString());
      }
    }
  }

  Future<void> onTapLogout() async {
    try {
      //check internet connection
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return;
      }

      await accountUseCase.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    masterPwdFocusNode.addListener(() {
      masterPwdHasFocus.value = masterPwdFocusNode.hasFocus;
    });
  }
}
