import 'package:get/get.dart';
import 'package:password_keeper/presentation/journey/main/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
  }

}