import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/controllers/app_controller.dart';
import 'package:password_keeper/presentation/controllers/crypto_controller.dart';
import 'package:password_keeper/presentation/controllers/password_generation_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<AppController>());
//    Get.put(getIt<StateController>());
    Get.put(getIt<PasswordGenerationController>);
    Get.put(getIt<CryptoController>());
  }
}
