import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/create_master_password/create_master_password_controller.dart';

class CreateMasterPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<CreateMasterPasswordController>());
  }
}
