import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/presentation/journey/home/home_page.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

import 'main_controller.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({Key? key}) : super(key: key);

  Widget _buildBottomNavigationItemWidget(
    BuildContext context, {
    Function()? onPressed,
    String? path,
    String? title,
    bool isSelected = false,
  }) {
    return Expanded(
      child: AppTouchable(
          onPressed: onPressed,
          outlinedBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          padding: EdgeInsets.only(
            top: AppDimens.space_12,
            bottom: MediaQuery.of(context).padding.bottom + AppDimens.space_12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImageWidget(
                path: path!,
                height: AppDimens.space_20,
                color: isSelected ? AppColors.primary : AppColors.grey,
              ),
              SizedBox(
                height: AppDimens.height_8,
              ),
              Text(
                title!,
                style: ThemeText.caption.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.grey,
                    ),
              )
            ],
          )),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Obx(
        () => Row(
          children: [
            // _buildBottomNavigationItemWidget(context,
            //     title: StringConstants.home.tr,
            //     path: ImageConstants.icNavHome,
            //     isSelected: controller.rxCurrentNavIndex.value == 0,
            //     onPressed: () => controller.onChangedNav(0)),
            // _buildBottomNavigationItemWidget(context,
            //     title: StringConstants.finance.tr,
            //     path: ImageConstants.icNavFinance,
            //     isSelected: controller.rxCurrentNavIndex.value == 1,
            //     onPressed: () => controller.onChangedNav(1)),
            // _buildBottomNavigationItemWidget(context,
            //     title: StringConstants.workflow.tr,
            //     path: ImageConstants.icNavWorkflow,
            //     isSelected: controller.rxCurrentNavIndex.value == 2,
            //     onPressed: () => controller.onChangedNav(2)),
            // _buildBottomNavigationItemWidget(context,
            //     title: StringConstants.love.tr,
            //     path: ImageConstants.icNavLove,
            //     isSelected: controller.rxCurrentNavIndex.value == 3,
            //     onPressed: () => controller.onChangedNav(3)),
            // _buildBottomNavigationItemWidget(context,
            //     title: StringConstants.account.tr,
            //     path: ImageConstants.icNavAccount,
            //     isSelected: controller.rxCurrentNavIndex.value == 4,
            //     onPressed: () => controller.onChangedNav(4)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      // Center(
      //   child: Text(StringConstants.finance.tr),
      // ),
      // Center(
      //   child: Text(StringConstants.workflow.tr),
      // ),
      // Center(
      //   child: Text(StringConstants.love.tr),
      // ),
      // Center(
      //   child: Text(StringConstants.account.tr),
      // ),
    ];

    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Obx(() => pages[controller.rxCurrentNavIndex.value]),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
}
