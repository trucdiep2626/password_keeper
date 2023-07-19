import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/status_bar_style/status_bar_style_type.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class SplashController extends GetxController with MixinController {
  SplashController();

  @override
  void onInit() {
    super.onInit();
    setStatusBarStyle(statusBarStyleType: StatusBarStyleType.light);
  }

  @override
  void onReady() {
    super.onReady();
    rxLoadedType.value = LoadedType.start;
    Future.delayed(const Duration(seconds: 3)).then((_) async {
      rxLoadedType.value = LoadedType.finish;
      Get.offAndToNamed(AppRoutes.login);
    });
  }
}
