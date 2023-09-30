import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/status_bar_style/status_bar_style_type.dart';
import 'package:password_keeper/domain/usecases/account_usecase.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';

class SplashController extends GetxController with MixinController {
  AccountUseCase accountUseCase;
  SplashController({required this.accountUseCase});

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
      await signInWithCredential();
    });
  }

  Future<void> signInWithCredential() async {
    //check internet connection
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      return;
    }

    accountUseCase.authState.listen((User? user) async {
      if (user != null) {
        if (!user.emailVerified) {
          Get.offAndToNamed(AppRoutes.verifyEmail);
        } else {
          final profile = await accountUseCase.getProfile(userId: user.uid);
          if (profile != null) {
            if (Get.currentRoute == AppRoutes.splash) {
              Get.offAndToNamed(AppRoutes.verifyMasterPassword);
            }
          } else {
            Get.offAndToNamed(AppRoutes.createMasterPassword);
          }
        }
      } else {
        Get.offAndToNamed(AppRoutes.login);
      }
    });

    rxLoadedType.value = LoadedType.finish;
  }
}
