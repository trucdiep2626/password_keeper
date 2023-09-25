import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/change_master_password/change_master_password_controller.dart';

class ChangeMasterPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<ChangeMasterPasswordController>());
  }
}
