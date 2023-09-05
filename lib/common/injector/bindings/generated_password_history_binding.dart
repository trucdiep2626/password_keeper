import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/generated_password_history/generated_password_history_controller.dart';

class GeneratedPasswordHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<GeneratedPasswordHistoryController>());
  }
}
