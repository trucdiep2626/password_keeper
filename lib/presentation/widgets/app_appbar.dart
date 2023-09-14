import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_image_widget.dart';
import 'package:password_keeper/presentation/widgets/app_touchable.dart';

class AppBarWidget extends GetView implements PreferredSizeWidget {
  final bool showBackButton;
  final String title;
  final List<Widget>? actions;
  final Function()? onTapBack;

  AppBarWidget({
    super.key,
    this.showBackButton = false,
    required this.title,
    this.actions,
    this.onTapBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blue400,
      automaticallyImplyLeading: showBackButton,
      leadingWidth: !showBackButton ? 0 : AppDimens.space_36,
      leading: showBackButton
          ? AppTouchable(
              margin: EdgeInsets.only(left: AppDimens.space_16),
              onPressed: onTapBack ?? () => Get.back(),
              child: AppImageWidget(
                asset: Assets.images.svg.icArrowLeft,
                color: AppColors.white,
              ),
            )
          : const SizedBox.shrink(),
      title: Text(
        title,
        style: ThemeText.bodySemibold.colorWhite.s16,
      ),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(AppDimens.height_60);
}
