import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_image_widget.dart';
import 'package:password_keeper/presentation/widgets/app_loading_widget.dart';
import 'package:password_keeper/presentation/widgets/app_touchable.dart';

import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() => controller.rxLoadedHome.value == LoadedType.start
            ? const AppLoadingWidget()
            : SingleChildScrollView(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.space_16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.mediaQuery.viewPadding.top,
                        ),
                        //welcom text
                        _buildWelcome(),
                        //password health
                        //  _buildPasswordHealth(),
                      ],
                    )),
              )),
      ),
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.space_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.space_16),
            decoration: BoxDecoration(
              color: AppColors.blue400.withOpacity(0.9),
              borderRadius: BorderRadius.circular(AppDimens.radius_16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${TranslationConstants.hello.tr} ${controller.accountUsecase.user?.displayName ?? 'User'}!',
                  style: ThemeText.bodyStrong.s20.colorWhite,
                ),
                Text(TranslationConstants.welcome.tr,
                    style: ThemeText.bodySemibold
                        .copyWith(color: AppColors.white.withOpacity(0.7))),
                SizedBox(
                  height: AppDimens.space_16,
                ),
                _buildPasswordHealth()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPasswordHealth() {
    return Obx(() => Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordHealthItem(
                  title: TranslationConstants.total.tr,
                  value: controller.totalPasswords.value,
                  color: AppColors.green,
                  onPressed: () => controller.goToAllPasswords(),
                ),
                _buildPasswordHealthItem(
                  title: TranslationConstants.reused.tr,
                  value: controller.totalReusePasswords.value,
                  color: AppColors.orange,
                  onPressed: () async => await controller.goToReusedPasswords(),
                ),
              ],
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordHealthItem(
                title: TranslationConstants.weak.tr,
                value: controller.totalWeakPasswords.value,
                color: AppColors.red,
                onPressed: () async => await controller.goToWeakPasswords(),
              ),
              _buildPasswordHealthItem(
                title: TranslationConstants.safe.tr,
                value: controller.totalSafePasswords.value,
                color: AppColors.blue,
                onPressed: () async => await controller.goToSafePasswords(),
              ),
            ],
          )),
        ]));
  }

  Widget _buildPasswordHealthItem({
    required String title,
    required int value,
    required Color color,
    required Function() onPressed,
  }) {
    return AppTouchable(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              offset: const Offset(0, 0),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(AppDimens.radius_16),
        ),
        margin: EdgeInsets.symmetric(
          vertical: AppDimens.space_4,
          horizontal: AppDimens.space_4,
        ),
        padding: EdgeInsets.all(AppDimens.space_16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppDimens.space_32,
              height: AppDimens.space_32,
              padding: EdgeInsets.all(AppDimens.space_8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimens.space_32),
              ),
              child: AppImageWidget(
                asset: Assets.images.svg.icPassword,
                color: color,
              ),
            ),
            SizedBox(
              width: AppDimens.space_12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: ThemeText.bodySemibold.s24.blue500,
                ),
                // SizedBox(
                //   height: AppDimens.space_4,
                // ),
                Text(
                  title,
                  style: ThemeText.bodyMedium.s12
                      .copyWith(color: AppColors.blue500.withOpacity(0.4)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
