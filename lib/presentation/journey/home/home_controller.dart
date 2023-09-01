import 'package:get/get.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class HomeController extends GetxController with MixinController {
  AccountUseCase accountUsecase;
  final _cryptoController = Get.find<CryptoController>();
  HomeController({required this.accountUsecase});

  @override
  Future<void> onReady() async {
    super.onReady();
  }
}
