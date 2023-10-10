import 'package:get/get.dart';
import 'package:password_keeper/common/utils/status_bar_style/status_bar_style_type.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_controller.dart';

class MainController extends GetxController with MixinController {
  RxInt rxCurrentNavIndex = 0.obs;

  void onChangedNav(int index) {
    rxCurrentNavIndex.value = index;

    if (index == 2) {
      final passwordGeneratorController =
          Get.find<PasswordGeneratorController>();
      if (passwordGeneratorController.fromAddPassword.value) {
        passwordGeneratorController.setFromAddEditPwd();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    setStatusBarStyle(statusBarStyleType: StatusBarStyleType.dark);
  }

  @override
  void onReady() async {
    super.onReady();
  }
}
