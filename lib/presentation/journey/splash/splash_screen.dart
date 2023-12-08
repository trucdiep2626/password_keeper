import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blue200,
      child: Stack(
        children: [
          Center(
            child: AppImageWidget(
              asset: Assets.images.lotties.splash,
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: AppDimens.paddingBottom),
          //     child: Obx(
          //       () {
          //         if (controller.rxLoadedType.value == LoadedType.start) {
          //           return AppLoadingWidget(
          //             width: Get.width * 0.6,
          //           );
          //         }
          //         return const SizedBox.shrink();
          //       },
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
