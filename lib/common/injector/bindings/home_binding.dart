import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<HomeController>());
  }
}
