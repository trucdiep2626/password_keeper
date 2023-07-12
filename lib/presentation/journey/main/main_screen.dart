import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/login/login_screen.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';
import 'main_controller.dart';

class MainScreen extends GetView<MainController> {
  MainScreen({Key? key}) : super(key: key);

  final List<String> titles = [
    TransactionConstants.home.tr,
    TransactionConstants.account.tr,
  ];

  final List<SvgGenImage> icons = [
    // Assets.images.icHome,
    // Assets.images.icCategory,
    // Assets.images.icShoppingCart,
    // Assets.images.icChat,
    // Assets.images.icUser,
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
        outlinedBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        // height: 70.sp,
        width: Get.width / 5,
        padding: EdgeInsets.only(
          top: AppDimens.space_12,
          bottom: MediaQuery.of(context).padding.bottom + AppDimens.space_12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImageWidget(
              asset: asset!,
              height: AppDimens.space_20,
              color: isCart
                  ? AppColors.white
                  : (isSelected ? AppColors.black : AppColors.grey),
            ),
            SizedBox(
              height: AppDimens.height_8,
            ),
            Text(
              title!,
              style: ThemeText.bodyMedium.copyWith(
                color: isCart
                    ? AppColors.white
                    : (isSelected ? AppColors.black : AppColors.grey),
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
            SizedBox(
              width: Get.width / 5,
            ),
            _buildBottomNavigationItemWidget(context,
                title: titles[3],
                asset: icons[3],
                isSelected: controller.rxCurrentNavIndex.value == 3,
                onPressed: () => controller.onChangedNav(3)),
            _buildBottomNavigationItemWidget(context,
                title: titles[4],
                asset: icons[4],
                isSelected: controller.rxCurrentNavIndex.value == 4,
                onPressed: () => controller.onChangedNav(4))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LogInScreen()
      // HomePage(),
      // CategoryScreen(),
      // const CartScreen(),
      // MessageScreen(),
      // const AccountScreen()
    ];

    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Obx(() => pages[controller.rxCurrentNavIndex.value]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: _buildBottomNavigationBar(context),
      ),
      floatingActionButton: Visibility(
        visible: Get.mediaQuery.viewInsets.bottom == 0,
        child: Container(
          width: Get.width / 5,
          decoration: BoxDecoration(
              color: AppColors.blue300,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    offset: const Offset(0.5, 0.5),
                    blurRadius: 3,
                    spreadRadius: 1)
              ]),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(),
                child: AppTouchable(
                  onPressed: () => controller.onChangedNav(2),
                  child: AppImageWidget(
                    asset: icons[2],
                    // height: AppDimens.space_20,
                    color: AppColors.white,
                    size: Get.width / 5 - AppDimens.space_36,
                    margin: EdgeInsets.only(
                        top: AppDimens.space_16,
                        bottom: MediaQuery.of(context).padding.bottom + AppDimens.space_16,
                        left: AppDimens.space_18),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
