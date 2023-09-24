import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/reset_password/reset_password_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.space_16),
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.mediaQuery.padding.top + AppDimens.space_36,
              ),
              AppImageWidget(
                asset: Assets.images.svg.authenticationBackground,
                size: AppDimens.space_160,
              ),
              SizedBox(
                height: AppDimens.space_8,
              ),
              Text(
                TranslationConstants.resetPassword.tr,
                style: ThemeText.bodySemibold.s18.blue400,
              ),
              SizedBox(
                height: AppDimens.space_4,
              ),
              Text(
                TranslationConstants.resetPasswordDetail.tr,
                style: ThemeText.bodyMedium.s14.grey600Color,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppDimens.space_20,
              ),
              Obx(
                () => AppTextField(
                  hintText: TranslationConstants.email.tr,
                  prefixIcon: AppImageWidget(
                    fit: BoxFit.scaleDown,
                    asset: Assets.images.svg.icMessage,
                    color: controller.emailHasFocus.value
                        ? AppColors.blue400
                        : AppColors.grey,
                  ),
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: controller.emailValidate.value,
                  onChangedText: (value) => controller.onChangedEmail(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () async =>
                      await controller.onPressedReset(),
                  focusNode: controller.emailFocusNode,
                ),
              ),
              SizedBox(
                height: AppDimens.space_12,
              ),
              Obx(
                () => controller.errorText.value.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppDimens.space_16,
                          vertical: AppDimens.space_4,
                        ),
                        width: Get.width - AppDimens.space_16 * 2,
                        child: Text(
                          controller.errorText.value,
                          style: ThemeText.errorText,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                height: AppDimens.space_12,
              ),
              Obx(
                () => AppButton(
                  enable: controller.buttonEnable.value,
                  title: TranslationConstants.requestPasswordReset.tr,
                  onPressed: () async => await controller.onPressedReset(),
                  loaded: controller.rxLoadedButton.value,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: AppDimens.space_48,
              ),
              RichText(
                text: TextSpan(
                  text: TranslationConstants.rememberPassword.tr,
                  style: ThemeText.bodyMedium,
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: AppTouchable(
                        onPressed: () {
                          controller.onPressLogin();
                        },
                        padding: EdgeInsets.only(left: AppDimens.space_4),
                        child: Text(
                          TranslationConstants.signIn.tr,
                          style: ThemeText.bodySemibold.blue400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppDimens.height_36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
