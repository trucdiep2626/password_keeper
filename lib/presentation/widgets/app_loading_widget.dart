import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/theme_color.dart';

import 'app_image_widget.dart';

class AppLoadingWidget extends StatelessWidget {
  final double? width;

  const AppLoadingWidget({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppImageWidget(
        asset: Assets.images.svg.loading,
      ),
    );
  }
}

class AppLoadingPage extends StatelessWidget {
  const AppLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.grey400?.withOpacity(0.5)),
      child: Center(
        child: SizedBox(
          width: Get.width,
          child: AppImageWidget(
            asset: Assets.images.svg.loading,
            size: AppDimens.space_160,
          ),
        ),
      ),
    );
  }
}
