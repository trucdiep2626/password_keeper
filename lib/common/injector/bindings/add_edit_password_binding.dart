import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/add_edit_password/add_edit_password_controller.dart';

class AddEditPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<AddEditPasswordController>());
  }
}
