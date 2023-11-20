import 'package:get/get.dart';
import 'package:password_keeper/common/injector/locators/app_locator.dart';
import 'package:password_keeper/presentation/journey/main/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<MainController>());
  }

}