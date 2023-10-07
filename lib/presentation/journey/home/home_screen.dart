import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_icon_widget.dart';
import 'package:password_keeper/presentation/widgets/app_refresh_widget.dart';
import 'package:password_keeper/presentation/widgets/empty_password_list.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

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
        body: AppRefreshWidget(
          onRefresh: () async => await controller.initData(),
          controller: controller.refreshController,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.space_16),
              child: Obx(
                () => controller.rxLoadedHome.value == LoadedType.start
                    ? _buildShimmerList()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.mediaQuery.viewPadding.top,
                          ),
                          _buildWelcome(),
                          Text(
                            TranslationConstants.recentUsed.tr,
                            style: ThemeText.bodySemibold.grey500Color,
                          ),
                          SizedBox(
                            height: AppDimens.space_16,
                          ),
                          if (controller.recentUsedPasswords.value.isEmpty)
                            const EmptyPasswordList(),
                          ...List.generate(
                            controller.recentUsedPasswords.length,
                            (index) => _buildItem(
                                controller.recentUsedPasswords[index]),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
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
    return Obx(
      () => Row(
        children: [
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
            ),
          ),
        ],
      ),
    );
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

  Widget _buildItem(PasswordItem item) {
    return AppTouchable(
      onPressed: () => controller.goToPasswordDetail(item),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.space_4),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.radius_12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListTile(
            leading: AppIconWidget(item: item),
            title: Text(
              item.signInLocation ?? '',
              style: ThemeText.bodyMedium,
            ),
            subtitle: Text(
              item.userId ?? '',
              style: ThemeText.bodyRegular.s12.grey600Color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.space_4),
      child: ListTile(
        title: AppShimmer(
          height: AppDimens.space_8,
          width: AppDimens.space_72,
        ),
        subtitle: AppShimmer(
          height: AppDimens.space_8,
          width: AppDimens.space_48,
        ),
        leading: AppShimmer(
          height: AppDimens.space_36,
          width: AppDimens.space_36,
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.mediaQuery.viewPadding.top,
        ),
        AppShimmer(
          borderRadius: BorderRadius.circular(AppDimens.radius_12),
          height: Get.height / 3,
          width: Get.width,
        ),
        SizedBox(
          height: AppDimens.space_16,
        ),
        AppShimmer(
          width: AppDimens.space_84,
        ),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
        _buildShimmerItem(),
      ],
    );
  }
}
