import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/verify_master_password/verify_master_password_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class VerifyMasterPasswordScreen
    extends GetView<VerifyMasterPasswordController> {
  const VerifyMasterPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.blue100,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.space_16),
        child: SingleChildScrollView(
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
                TranslationConstants.welcomeBack.tr,
                style: ThemeText.bodySemibold.s24.blue400,
              ),
              SizedBox(
                height: AppDimens.space_8,
              ),
              Text(
                TranslationConstants.enterMasterPassword.tr,
                style: ThemeText.bodyMedium.s14.grey500Color,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppDimens.space_24,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: AppDimens.space_4,
                    horizontal: AppDimens.space_12),
                decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(AppDimens.radius_12)),
                child: Text(
                  controller.user?.email ?? '',
                  style: ThemeText.bodyMedium,
                ),
              ),
              SizedBox(
                height: AppDimens.space_36,
              ),
              Obx(
                () => AppTextField(
                  prefixIcon: AppImageWidget(
                    fit: BoxFit.scaleDown,
                    asset: Assets.images.svg.icPassword,
                    color: controller.masterPwdHasFocus.value
                        ? AppColors.blue400
                        : AppColors.grey,
                  ),
                  suffixIcon: AppTouchable(
                    onPressed: controller.onChangedShowMasterPwd,
                    child: AppImageWidget(
                      fit: BoxFit.scaleDown,
                      asset: controller.showMasterPwd.value
                          ? Assets.images.svg.icEyeSlash
                          : Assets.images.svg.icEye,
                      color: controller.masterPwdHasFocus.value
                          ? AppColors.blue400
                          : AppColors.grey,
                    ),
                  ),
                  hintText: TranslationConstants.masterPassword.tr,
                  controller: controller.masterPwdController,
                  errorText: controller.masterPwdValidate.value,
                  obscureText: !(controller.showMasterPwd.value),
                  onChangedText: (value) => controller.onChangedPwd(),
                  onTap: () => controller.onTapPwdTextField(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => controller.onPressedVerify(),
                  focusNode: controller.masterPwdFocusNode,
                ),
              ),
              SizedBox(
                height: AppDimens.space_8,
              ),
              Obx(
                () => controller.errorText.value.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppDimens.space_16,
                          vertical: AppDimens.space_4,
                        ),
                        width: MediaQuery.of(context).size.width -
                            AppDimens.space_16 * 2,
                        child: Text(
                          controller.errorText.value,
                          style: ThemeText.errorText,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                height: AppDimens.space_20,
              ),
              Obx(
                () => AppButton(
                  enable: controller.buttonEnable.value,
                  title: TranslationConstants.unlock.tr,
                  onPressed: () => controller.onPressedVerify(),
                  loaded: controller.rxLoadedButton.value,
                ),
              ),
              SizedBox(
                height: AppDimens.space_24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.space_4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImageWidget(
                      asset: Assets.images.svg.icFingerScan,
                      size: AppDimens.space_24,
                    ),
                    SizedBox(
                      width: AppDimens.space_4,
                    ),
                    Flexible(
                      child: Text(
                        TranslationConstants.unlockBiometric.tr,
                        style: ThemeText.bodyRegular.s16,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              //  Spacer(),
              SizedBox(
                height: AppDimens.space_36,
              ),
              Text(
                TranslationConstants.getMasterPasswordHint.tr,
                style: ThemeText.bodyMedium.blue300,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppDimens.space_36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
