import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/injector/locators/app_locator.dart';
import 'package:password_keeper/domain/models/encrypted_string.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/controllers/password_generation_controller.dart';

class PasswordDetailController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedDetail = LoadedType.finish.obs;
  Rx<PasswordItem> password = PasswordItem().obs;
  RxBool showPassword = false.obs;

  PasswordUseCase passwordUseCase;
  AccountUseCase accountUseCase;

  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  final noteController = TextEditingController();


  final CryptoController _cryptoController = Get.find<CryptoController>();

  PasswordDetailController({
    required this.accountUseCase,
    required this.passwordUseCase,
  });

  void onChangedShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<void> decryptPassword() async {
    rxLoadedDetail.value == LoadedType.start;
    final decrypted = await _cryptoController.decryptToUtf8(
        encString: EncryptedString.fromString(
            encryptedString: password.value.password));

    if (decrypted != null) {
      password.value = password.value.copyWith(password: decrypted);
    }

    rxLoadedDetail.value == LoadedType.finish;
  }

  goToEdit(){

  }

  Future<void> deleteItem() async{

  }



  @override
  void onInit() async{
    super.onInit();
    final pwd = Get.arguments;
    if (pwd is PasswordItem) {
      password.value = pwd;
    await decryptPassword();

    userIdController.text = password.value.userId ?? '';
    passwordController.text = password.value.password ?? '';
    noteController.text = password.value.note ?? '';
    }
  }
}
