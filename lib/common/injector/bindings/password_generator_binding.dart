import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_controller.dart';

class PasswordGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<PasswordGeneratorController>());
  }
}
