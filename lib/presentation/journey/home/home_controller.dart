import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/domain/usecases/password_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class HomeController extends GetxController with MixinController {
  AccountUseCase accountUsecase;
  PasswordUseCase passwordUseCase;

  final _cryptoController = Get.find<CryptoController>();

  HomeController({
    required this.accountUsecase,
    required this.passwordUseCase,
  });

  User? get user => accountUsecase.user;

  RxInt totalPasswords = 0.obs;

  @override
  Future<void> onReady() async {
    super.onReady();
  }
}
