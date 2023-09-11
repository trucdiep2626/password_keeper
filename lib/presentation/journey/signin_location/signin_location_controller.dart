import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class SignInLocationController extends GetxController with MixinController {
  Rx<LoadedType> rxLoadedLocation = LoadedType.finish.obs;
  RxList<AppInfo> apps = <AppInfo>[].obs;

  TextEditingController webAddrController = TextEditingController();

  Future<void> getAllInstalledApps() async {
    rxLoadedLocation.value = LoadedType.start;
    try {
      List<AppInfo> installedApps =
          await InstalledApps.getInstalledApps(true, true);
      apps.value = [...installedApps];
    } catch (e) {
      showTopSnackBarError(context, TranslationConstants.unknownError);
    } finally {
      rxLoadedLocation.value = LoadedType.finish;
    }
  }

  void saveSignInLocation({AppInfo? appInfo, String? url}) {
    Get.back(result: {
      'app': appInfo,
      'url': url,
    });
  }

  @override
  void onReady() async {
    await getAllInstalledApps();
  }
}
