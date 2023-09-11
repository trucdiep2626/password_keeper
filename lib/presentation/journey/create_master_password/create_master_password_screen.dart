import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/create_master_password/create_master_password_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';
import 'package:password_keeper/presentation/widgets/password_strength_checker_widget.dart';

class CreateMasterPasswordScreen
    extends GetView<CreateMasterPasswordController> {
  const CreateMasterPasswordScreen({Key? key}) : super(key: key);

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
                TranslationConstants.createMasterPassword.tr,
                style: ThemeText.bodySemibold.s18.blue400,
              ),
              SizedBox(
                height: AppDimens.space_4,
              ),
              Text(
                TranslationConstants.masterPasswordDescription.tr,
                style: ThemeText.bodyMedium.s12.grey500Color,
                textAlign: TextAlign.center,
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
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => controller.onEditingCompletePwd(),
                  focusNode: controller.masterPwdFocusNode,
                ),
              ),
              Obx(
                () => controller.showPasswordStrengthChecker.value
                    ? PasswordStrengthChecker(
                        passwordStrength: controller.passwordStrength.value)
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                height: AppDimens.space_8,
              ),
              Obx(
                () => AppTextField(
                  prefixIcon: AppImageWidget(
                    fit: BoxFit.scaleDown,
                    asset: Assets.images.svg.icPasswordCheck,
                    color: controller.confirmMasterPwdHasFocus.value
                        ? AppColors.blue400
                        : AppColors.grey,
                  ),
                  suffixIcon: AppTouchable(
                    onPressed: controller.onChangedShowConfirmPwd,
                    child: AppImageWidget(
                      fit: BoxFit.scaleDown,
                      asset: controller.showConfirmMasterPwd.value
                          ? Assets.images.svg.icEyeSlash
                          : Assets.images.svg.icEye,
                      color: controller.confirmMasterPwdHasFocus.value
                          ? AppColors.blue400
                          : AppColors.grey,
                    ),
                  ),
                  hintText: TranslationConstants.confirmPassword.tr,
                  controller: controller.confirmMasterPwdController,
                  errorText: controller.confirmMasterPwdValidate.value,
                  obscureText: !(controller.showConfirmMasterPwd.value),
                  onChangedText: (value) => controller.onChangedConfirmPwd(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      controller.onEditingCompleteConfirmPwd(),
                  focusNode: controller.confirmMasterPwdFocusNode,
                ),
              ),
              SizedBox(
                height: AppDimens.space_8,
              ),
              AppTextField(
                hintText: TranslationConstants.masterPasswordHint.tr,
                controller: controller.masterPwdHintController,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onEditingComplete: () =>
                    controller.onEditingCompleteMasterPwdHint(),
                focusNode: controller.masterPwdHintFocusNode,
              ),
              SizedBox(
                height: AppDimens.space_4,
              ),
              Text(
                TranslationConstants.masterPasswordHintNote.tr,
                style: ThemeText.bodyRegular.s10.grey600Color,
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
                  title: TranslationConstants.save.tr,
                  onPressed: () => controller.onPressedRegister(),
                  loaded: controller.rxLoadedButton.value,
                ),
              ),
              SizedBox(
                height: AppDimens.space_12,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.space_4),
                child: Text(
                  TranslationConstants.masterPasswordNote.tr,
                  style: ThemeText.bodyRegular.s12.grey600Color,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
