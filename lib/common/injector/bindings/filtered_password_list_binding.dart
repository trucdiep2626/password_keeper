import 'package:get/get.dart';
import 'package:password_keeper/common/injector/injector.dart';
import 'package:password_keeper/presentation/journey/filtered_password_list/filtered_password_list_controller.dart';

class FilteredPasswordListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(getIt<FilteredPasswordListController>());
  }
}
