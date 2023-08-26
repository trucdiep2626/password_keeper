import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/verify_email/verify_email_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class VerifyEmailScreen extends GetView<VerifyEmailController> {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.space_16),
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.mediaQuery.padding.top,
                ),
                AppImageWidget(
                  asset: Assets.images.svg.icEnvelop,
                  size: AppDimens.space_84,
                ),
                SizedBox(
                  height: AppDimens.space_36,
                ),
                Text(
                  TranslationConstants.verifyEmail.tr,
                  style: ThemeText.bodySemibold.s24.blue400,
                ),
                SizedBox(
                  height: AppDimens.space_16,
                ),
                Text(
                  TranslationConstants.verifyEmailDescription.tr,
                  style: ThemeText.bodyMedium.s14.grey600Color,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: AppDimens.space_36,
                ),
                Obx(
                  () => AppButton(
                    title: TranslationConstants.continueButton.tr,
                    onPressed: () => controller.onPressedContinueButton(),
                    loaded: controller.rxLoadedButton.value,
                  ),
                ),
                SizedBox(
                  height: AppDimens.space_20,
                ),
                GestureDetector(
                  onTap: controller.sendVerifyEmail,
                  child: Text(
                    TranslationConstants.resendEmailLink.tr,
                    style: ThemeText.bodySemibold.s16.blue300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
