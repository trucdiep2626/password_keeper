import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/controllers/auto_fill_controller.dart';
import 'package:password_keeper/presentation/controllers/biometric_controller.dart';
import 'package:password_keeper/presentation/controllers/screen_capture_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/app_image_widget.dart';
import 'package:password_keeper/presentation/widgets/app_loading_widget.dart';
import 'package:password_keeper/presentation/widgets/app_touchable.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    final autofillController = Get.find<AutofillController>();
    final biometricController = Get.find<BiometricController>();
    final screenCaptureController = Get.find<ScreenCaptureController>();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBarWidget(
            title: TranslationConstants.settings.tr,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppDimens.space_16),
              child: Column(
                children: [
                  Obx(
                    () => _buildItem(
                      onPressed: () async =>
                          await autofillController.onChangedAutofillService(),
                      icon: Assets.images.svg.icPasswordCheck,
                      title: TranslationConstants.autoFillService.tr,
                      showSwitch: true,
                      switchValue:
                          autofillController.enableAutofillService.value,
                    ),
                  ),
                  _buildItem(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.changeMasterPassword),
                    icon: Assets.images.svg.icPasswordCheck,
                    title: TranslationConstants.changeMasterPassword.tr,
                  ),
                  Obx(
                    () => _buildItem(
                      onPressed: () async => await biometricController
                          .onChangedBiometricStorageStatus(),
                      icon: Assets.images.svg.icFingerScan,
                      title: TranslationConstants.unlockWithBiometrics.tr,
                      showSwitch: true,
                      switchValue:
                          biometricController.enableBiometricUnlock.value,
                    ),
                  ),
                  Obx(
                    () => _buildItem(
                      onPressed: () async => await screenCaptureController
                          .onChangedAllowScreenCapture(),
                      icon: Assets.images.svg.icCamera,
                      title: TranslationConstants.allowScreenCapture.tr,
                      showSwitch: true,
                      switchValue:
                          screenCaptureController.allowScreenCapture.value,
                    ),
                  ),
                  _buildItem(
                    onPressed: () async => await controller.onTapLock(),
                    icon: Assets.images.svg.icPassword,
                    title: TranslationConstants.lock.tr,
                  ),
                  _buildItem(
                    onPressed: () async => await controller.onTapLogout(),
                    icon: Assets.images.svg.icLogout,
                    title: TranslationConstants.logout.tr,
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => controller.rxLoadedSettings.value == LoadedType.start
            ? const AppLoadingPage()
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildItem({
    required Function() onPressed,
    required SvgGenImage icon,
    required String title,
    bool showSwitch = false,
    bool switchValue = false,
  }) {
    return AppTouchable(
      onPressed: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimens.space_8),
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.space_16,
            vertical: showSwitch ? AppDimens.space_4 : AppDimens.space_16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.02),
              offset: const Offset(0, 2),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.radius_12),
        ),
        child: Row(
          children: [
            AppImageWidget(
              asset: icon,
              color: AppColors.grey600,
            ),
            SizedBox(
              width: AppDimens.space_16,
            ),
            Text(
              title,
              style: ThemeText.bodyMedium.grey600Color,
            ),
            const Spacer(),
            showSwitch
                ? Switch(
                    value: switchValue,
                    onChanged: (value) => onPressed(),
                    activeColor: AppColors.blue400,
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
