import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/password_detail/password_detail_controller.dart';

class PasswordDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<PasswordDetailController>());
  }
}
