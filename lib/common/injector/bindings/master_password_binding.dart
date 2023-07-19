import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/master_password/master_password_controller.dart';

class MasterPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<MasterPasswordController>());
  }
}
