import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/register/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<RegisterController>());
  }
}
