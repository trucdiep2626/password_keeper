import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/password_list/password_list_controller.dart';

class PasswordListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<PasswordListController>());
  }
}
