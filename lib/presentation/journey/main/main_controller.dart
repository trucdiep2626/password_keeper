import 'package:get/get.dart';

import 'package:password_keeper/common/utils/status_bar_style/status_bar_style_type.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class MainController extends GetxController with MixinController {
  RxInt rxCurrentNavIndex = 0.obs;

  void onChangedNav(int index) {
    rxCurrentNavIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    setStatusBarStyle(statusBarStyleType: StatusBarStyleType.dark);
  }
}