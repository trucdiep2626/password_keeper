import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/change_master_password/change_master_password_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/export.dart';
import 'package:password_keeper/presentation/widgets/password_strength_checker_widget.dart';

class ChangeMasterPasswordScreen
    extends GetView<ChangeMasterPasswordController> {
  const ChangeMasterPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
          showBackButton: true,
          title: TranslationConstants.changeMasterPassword.tr),
      body: Padding(
        padding: EdgeInsets.all(AppDimens.space_16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text(
              //   TranslationConstants.masterPasswordDescription.tr,
              //   style: ThemeText.bodyMedium.s12.grey500Color,
              //   textAlign: TextAlign.start,
              // ),
              Obx(
                () => AppTextField(
                  prefixIcon: AppImageWidget(
                    fit: BoxFit.scaleDown,
                    asset: Assets.images.svg.icPassword,
                    color: controller.currentMasterPwdHasFocus.value
                        ? AppColors.blue400
                        : AppColors.grey,
                  ),
                  suffixIcon: AppTouchable(
                    onPressed: controller.onChangedShowCurrentMasterPwd,
                    child: AppImageWidget(
                      fit: BoxFit.scaleDown,
                      asset: controller.showCurrentMasterPwd.value
                          ? Assets.images.svg.icEyeSlash
                          : Assets.images.svg.icEye,
                      color: controller.currentMasterPwdHasFocus.value
                          ? AppColors.blue400
                          : AppColors.grey,
                    ),
                  ),
                  hintText: TranslationConstants.currentMasterPassword.tr,
                  controller: controller.currentMasterPwdController,
                  errorText: controller.currentMasterPwdValidate.value,
                  obscureText: !(controller.showCurrentMasterPwd.value),
                  onChangedText: (value) =>
                      controller.onChangedCurrentMasterPwd(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      controller.onEditingCompleteCurrentMasterPwd(),
                  focusNode: controller.currentMasterPwdFocusNode,
                ),
              ),
              SizedBox(
                height: AppDimens.space_8,
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
                  hintText: TranslationConstants.newMasterPassword.tr,
                  controller: controller.masterPwdController,
                  errorText: controller.masterPwdValidate.value,
                  obscureText: !(controller.showMasterPwd.value),
                  onChangedText: (value) => controller.onChangedMasterPwd(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      controller.onEditingCompleteMasterPwd(),
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
                  hintText: TranslationConstants.confirmNewMasterPassword.tr,
                  controller: controller.confirmMasterPwdController,
                  errorText: controller.confirmMasterPwdValidate.value,
                  obscureText: !(controller.showConfirmMasterPwd.value),
                  onChangedText: (value) =>
                      controller.onChangedConfirmMasterPwd(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      controller.onEditingCompleteConfirmMasterPwd(),
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
              // Text(
              //   TranslationConstants.masterPasswordHintNote.tr,
              //   style: ThemeText.bodyRegular.s10.grey600Color,
              // ),
              // SizedBox(
              //   height: AppDimens.space_12,
              // ),
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
              // SizedBox(
              //   height: AppDimens.space_12,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: AppDimens.space_4),
              //   child: Text(
              //     TranslationConstants.masterPasswordNote.tr,
              //     style: ThemeText.bodyRegular.s12.grey600Color,
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: EdgeInsets.all(AppDimens.space_16),
          child: AppButton(
            enable: controller.buttonEnable.value,
            title: TranslationConstants.save.tr,
            onPressed: () => controller.onPressedChange(),
            loaded: controller.rxLoadedButton.value,
          ),
        ),
      ),
    );
  }
}
