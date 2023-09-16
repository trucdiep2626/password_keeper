import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/password_helper.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/encrypted_string.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_controller.dart';
import 'package:password_keeper/presentation/journey/password_list/password_list_controller.dart';
import 'package:password_keeper/presentation/widgets/app_dialog.dart';
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

  Rx<AppInfo?> selectedApp = (null as AppInfo?).obs;
  RxString selectedUrl = ''.obs;

  RxBool showBottomBarAboveKeyBoard = false.obs;
  RxBool showPasswordStrengthChecker = false.obs;
  RxBool showPassword = false.obs;

  Rx<PasswordStrengthLevel> passwordStrength =
      PasswordStrengthLevel.veryWeak.obs;

  AccountUseCase accountUseCase;
  PasswordUseCase passwordUseCase;

  RxDouble bottomPadding = 0.0.obs;

  RxBool ignoreWeakPassword = false.obs;

  final _cryptoController = Get.find<CryptoController>();

  AddEditPasswordController({
    required this.accountUseCase,
    required this.passwordUseCase,
  });

  User? get user => accountUseCase.user;

  PasswordItem? oldPassword;

  void onChangedShowPassword() {
    showPassword.value = !showPassword.value;
  }

  void checkButtonEnable() {
    if (userIdController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        (!isNullEmpty(selectedApp.value) || !isNullEmpty(selectedUrl.value))) {
      buttonEnable.value = true;
    } else {
      buttonEnable.value = false;
    }
  }

  Future<void> handleShowWeakPasswordWarning() async {
    if (Get.context != null) {
      await showAppDialog(
        Get.context!,
        TranslationConstants.weakPasswordWarning.tr,
        TranslationConstants.weakPasswordWarningMessage.tr,
        confirmButtonText: TranslationConstants.continueAnyway.tr,
        messageTextAlign: TextAlign.start,
        dismissAble: true,
        confirmButtonCallback: () {
          ignoreWeakPassword.value = true;
          Get.back(result: true);
        },
        cancelButtonText: TranslationConstants.tryAgain.tr,
        cancelButtonCallback: () {
          ignoreWeakPassword.value = false;
          Get.back(result: false);
        },
      );
    }
  }

  Future<void> handleAddPassword(EncryptedString encPassword) async {
    final passwordItem = PasswordItem(
      passwordStrengthLevel: passwordStrength.value,
      isApp: !isNullEmpty(selectedApp.value?.name),
      appIcon: selectedApp.value?.icon,
      signInLocation: (selectedApp.value?.name ?? selectedUrl.value).capitalize,
      password: encPassword.encryptedString,
      userId: userIdController.text,
      note: noteController.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await passwordUseCase.addPasswordItem(
      userId: user?.uid ?? '',
      passwordItem: passwordItem,
    );

    showTopSnackBar(
      Get.context!,
      message: TranslationConstants.addPasswordSuccessful.tr,
      type: SnackBarType.done,
    );
    clearData();

    //refresh password list
    await Get.find<PasswordListController>().onRefresh();
    Get.back();
  }

  Future<void> handleEditPassword(EncryptedString encPassword) async {
    final passwordItem = PasswordItem(
      id: oldPassword?.id,
      passwordStrengthLevel: passwordStrength.value,
      isApp: !isNullEmpty(selectedApp.value?.name),
      appIcon: selectedApp.value?.icon,
      signInLocation: (selectedApp.value?.name ?? selectedUrl.value).capitalize,
      password: encPassword.encryptedString,
      userId: userIdController.text,
      note: noteController.text,
      createdAt:
          oldPassword?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await passwordUseCase.editPasswordItem(
      userId: user?.uid ?? '',
      passwordItem: passwordItem,
    );

    showTopSnackBar(
      Get.context!,
      message: TranslationConstants.updatedPasswordSuccessfully.tr,
      type: SnackBarType.done,
    );
    clearData();

    Get.back(result: passwordItem);
  }

  Future<void> handleSave() async {
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
    //show weak password warning
    if ((passwordStrength.value == PasswordStrengthLevel.weak ||
        passwordStrength.value == PasswordStrengthLevel.veryWeak)) {
      await handleShowWeakPasswordWarning();

      if (!ignoreWeakPassword.value) {
        return;
      }
    }

    rxLoadedButton.value = LoadedType.start;

    try {
      final encPassword = await _cryptoController.encryptString(
          plainValue: passwordController.text);

      if (encPassword == null) {
        return;
      }

      if (isNullEmpty(oldPassword)) {
        await handleAddPassword(encPassword);
      } else {
        await handleEditPassword(encPassword);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (Get.context != null) {
        showTopSnackBarError(
          Get.context!,
          TranslationConstants.unknownError.tr,
        );
      }
    } finally {
      rxLoadedButton.value = LoadedType.finish;
    }
  }

  void onChangedUserId() {
    checkButtonEnable();
    userIdValidate.value = '';
  }

  void clearData() {
    selectedApp.value = null;
    selectedUrl.value = '';
    userIdController.clear();
    passwordController.clear();
    noteController.clear();
    showPassword.value = false;
    passwordStrength.value = PasswordStrengthLevel.veryWeak;
    showPasswordStrengthChecker.value = false;
  }

  void onChangedPwd() {
    checkPasswordStrength();
    checkButtonEnable();
    passwordValidate.value = '';
  }

  void checkPasswordStrength() {
    if (passwordController.text.isNotEmpty) {
      passwordStrength.value =
          PasswordHelper.checkPasswordStrength(passwordController.text);
      showPasswordStrengthChecker.value = true;
    } else {
      showPasswordStrengthChecker.value = false;
    }
  }

  Future<void> onPressPickLocationOrApp() async {
    final result = await Get.toNamed(AppRoutes.signInLocation);
    if (result != null && result is Map) {
      selectedApp.value = result['app'];
      selectedUrl.value = result['url'] ?? '';
      checkButtonEnable();
    }
  }

  Future<void> onPressedGeneratePassword() async {
    Get.find<PasswordGeneratorController>().setFromAddEditPwd();
    final result = await Get.toNamed(
      AppRoutes.passwordGenerator,
    );
    if (result != null && result is String) {
      passwordController.text = result;
      checkButtonEnable();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    passwordFocusNode.addListener(() {
      checkPasswordStrength();
    });
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (!isNullEmpty(args) && args is PasswordItem) {
      oldPassword = args;
      userIdController.text = oldPassword?.userId ?? '';
      passwordController.text = oldPassword?.password ?? '';
      noteController.text = oldPassword?.note ?? '';
      showPasswordStrengthChecker.value = true;
      passwordStrength.value =
          oldPassword?.passwordStrengthLevel ?? PasswordStrengthLevel.weak;
      if (!isNullEmpty(oldPassword?.appIcon)) {
        selectedApp.value = AppInfo(
            oldPassword?.signInLocation ?? '', oldPassword?.appIcon, '', '', 0);
      } else {
        selectedUrl.value = oldPassword?.signInLocation ?? '';
      }
    }
  }
}
