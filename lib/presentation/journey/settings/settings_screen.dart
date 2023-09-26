import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/app_image_widget.dart';
import 'package:password_keeper/presentation/widgets/app_touchable.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: TranslationConstants.settings.tr,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.space_16),
          child: Column(
            children: [
              _buildItem(
                onPressed: () => Get.toNamed(AppRoutes.changeMasterPassword),
                icon: Assets.images.svg.icPasswordCheck,
                title: TranslationConstants.changeMasterPassword.tr,
              ),
              // _buildItem(
              //   onPressed: () {},
              //   icon: Assets.images.svg.icFingerScan,
              //   title: TranslationConstants.unlockWithBiometrics.tr,
              // ),
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
    );
  }

  Widget _buildItem({
    required Function() onPressed,
    required SvgGenImage icon,
    required String title,
  }) {
    return AppTouchable(
      onPressed: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimens.space_8),
        padding: EdgeInsets.all(AppDimens.space_16),
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
            )
          ],
        ),
      ),
    );
  }
}
