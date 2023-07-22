import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/verify_master_password/verify_master_password_controller.dart';

class VerifyMasterPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<VerifyMasterPasswordController>());
  }
}
