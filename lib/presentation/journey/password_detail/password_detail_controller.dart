import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/encrypted_string.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/journey/home/home_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class PasswordDetailController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedDetail = LoadedType.finish.obs;
  Rx<PasswordItem> password = PasswordItem().obs;
  RxBool showPassword = false.obs;

  PasswordUseCase passwordUseCase;
  AccountUseCase accountUseCase;

  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  final noteController = TextEditingController();
  RxBool needRefreshList = false.obs;

  final CryptoController _cryptoController = Get.find<CryptoController>();

  PasswordDetailController({
    required this.accountUseCase,
    required this.passwordUseCase,
  });

  User? get user => accountUseCase.user;

  void onChangedShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<void> decryptPassword() async {
    rxLoadedDetail.value == LoadedType.start;
    final encString =
        EncryptedString.fromString(encryptedString: password.value.password);
    final decrypted =
        await _cryptoController.decryptToUtf8(encString: encString);

    if (decrypted != null) {
      password.value = password.value.copyWith(password: decrypted);
    }

    rxLoadedDetail.value == LoadedType.finish;
  }

  Future<void> goToEdit() async {
    final updatedPassword =
        await Get.toNamed(AppRoutes.addEditPassword, arguments: password.value);
    if (!isNullEmpty(updatedPassword) && updatedPassword is PasswordItem) {
      password.value = updatedPassword;
      needRefreshList.value = true;
      await _handleDisplayItem();
    }
  }

  Future<void> deleteItem() async {
    await showAppDialog(
      context,
      TranslationConstants.deleteItem.tr,
      TranslationConstants.deleteConfirmMessage.tr,
      confirmButtonText: TranslationConstants.delete.tr,
      cancelButtonText: TranslationConstants.cancel.tr,
      messageTextAlign: TextAlign.start,
      confirmButtonCallback: () async => await handleDeleteItem(),
    );
  }

  Future<void> handleDeleteItem() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    rxLoadedDetail.value = LoadedType.start;

    try {
      final result = await passwordUseCase.deletePassword(
        userId: user?.uid ?? '',
        itemId: password.value.id ?? '',
      );

      if (result) {
        showTopSnackBar(
          Get.context!,
          message: TranslationConstants.deletedPasswordSuccessfully.tr,
        );
        needRefreshList.value = true;
        //close dialog
        Get.back();
        //back to password list screen
        Get.back(result: needRefreshList.value);
      }
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedDetail.value = LoadedType.finish;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    final pwd = Get.arguments;
    if (pwd is PasswordItem) {
      password.value = pwd;
      await _handleDisplayItem();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await updateRecentUsed();
    await Get.find<HomeController>().getRecentUsedPasswords();
  }

  Future<void> updateRecentUsed() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    rxLoadedDetail.value = LoadedType.start;

    try {
      await passwordUseCase.updateRecentUsedPassword(
        userId: user?.uid ?? '',
        password: password.value
            .copyWith(recentUsedAt: DateTime.now().millisecondsSinceEpoch),
      );
    } catch (e) {
      debugPrint(e.toString());
      showErrorMessage();
    } finally {
      rxLoadedDetail.value = LoadedType.finish;
    }
  }

  Future<void> _handleDisplayItem() async {
    await decryptPassword();

    userIdController.text = password.value.userId ?? '';
    passwordController.text = password.value.password ?? '';
    noteController.text = password.value.note ?? '';
  }
}
