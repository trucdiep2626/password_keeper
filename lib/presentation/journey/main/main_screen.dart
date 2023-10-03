import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/home/home_screen.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_screen.dart';
import 'package:password_keeper/presentation/journey/password_list/password_list_screen.dart';
import 'package:password_keeper/presentation/journey/settings/settings_screen.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

import 'main_controller.dart';

class MainScreen extends GetView<MainController> {
  MainScreen({Key? key}) : super(key: key);

  final List<String> titles = [
    TranslationConstants.home.tr,
    TranslationConstants.passwords.tr,
    //  TranslationConstants.home.tr,
    TranslationConstants.generator.tr,
    TranslationConstants.settings.tr,
  ];

  final List<SvgGenImage> icons = [
    Assets.images.svg.icHome,
    Assets.images.svg.icPassword,
    // Assets.images.svg.icAdd,
    Assets.images.svg.icGenerator,
    Assets.images.svg.icSetting,
  ];

  Widget _buildBottomNavigationItemWidget(
    BuildContext context, {
    Function()? onPressed,
    SvgGenImage? asset,
    String? title,
    bool isSelected = false,
    bool isCart = false,
  }) {
    return AppTouchable(
        onPressed: onPressed,
        outlinedBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        // height: 70.sp,
        width: Get.width / 4,
        padding: EdgeInsets.only(
          top: AppDimens.space_12,
          bottom: MediaQuery.of(context).padding.bottom + AppDimens.space_12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImageWidget(
              asset: asset!,
              height: AppDimens.space_18,
              color: isCart
                  ? AppColors.white
                  : (isSelected ? AppColors.blue400 : AppColors.grey),
            ),
            SizedBox(
              height: AppDimens.height_8,
            ),
            Text(
              title!,
              style: ThemeText.bodySemibold.s10.copyWith(
                color: isCart
                    ? AppColors.white
                    : (isSelected ? AppColors.blue400 : AppColors.grey),
              ),
            )
          ],
        ));
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Obx(
      () {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildBottomNavigationItemWidget(context,
                title: titles[0],
                asset: icons[0],
                isSelected: controller.rxCurrentNavIndex.value == 0,
                onPressed: () => controller.onChangedNav(0)),
            _buildBottomNavigationItemWidget(context,
                title: titles[1],
                asset: icons[1],
                isSelected: controller.rxCurrentNavIndex.value == 1,
                onPressed: () => controller.onChangedNav(1)),
            // SizedBox(
            //   width: Get.width / 5,
            // ),
            _buildBottomNavigationItemWidget(context,
                title: titles[2],
                asset: icons[2],
                isSelected: controller.rxCurrentNavIndex.value == 2,
                onPressed: () => controller.onChangedNav(2)),
            _buildBottomNavigationItemWidget(context,
                title: titles[3],
                asset: icons[3],
                isSelected: controller.rxCurrentNavIndex.value == 3,
                onPressed: () => controller.onChangedNav(3))
          ],
        );
      },
    );
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const PasswordListScreen(),
    const PasswordGeneratorScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Obx(() => pages[controller.rxCurrentNavIndex.value]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 3,
        child: _buildBottomNavigationBar(context),
      ),
      floatingActionButton: Obx(() => Visibility(
            visible: Get.mediaQuery.viewInsets.bottom == 0 &&
                (controller.rxCurrentNavIndex.value == 0 ||
                    controller.rxCurrentNavIndex.value == 1),
            child: Container(
              width: Get.width / 7,
              decoration: BoxDecoration(
                color: AppColors.blue400,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.black.withOpacity(0.2),
                      offset: const Offset(0.5, 0.5),
                      blurRadius: 3,
                      spreadRadius: 1)
                ],
              ),
              child: AppTouchable(
                width: Get.width / 5,
                borderRadius:
                    BorderRadius.circular(Get.width / 5 - AppDimens.space_36),
                onPressed: () => Get.toNamed(AppRoutes.addEditPassword),
                child: AppImageWidget(
                  asset: Assets.images.svg.icAdd,
                  // height: AppDimens.space_20,
                  color: AppColors.white,
                  size: Get.width / 5 - AppDimens.space_36,
                  margin: EdgeInsets.only(
                    top: AppDimens.space_16,
                    bottom: MediaQuery.of(context).padding.bottom +
                        AppDimens.space_16,
                  ),
                ),
              ),
            ),
          )),
      //    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
