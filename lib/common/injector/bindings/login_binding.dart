import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<LoginController>());
  }
}
