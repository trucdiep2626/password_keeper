import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/create_master_password/create_master_password_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

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
                TransactionConstants.createMasterPassword.tr,
                style: ThemeText.bodySemibold.s18.blue400,
              ),
              SizedBox(
                height: AppDimens.space_4,
              ),
              Text(
                TransactionConstants.masterPasswordDescription.tr,
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
                  hintText: TransactionConstants.masterPassword.tr,
                  controller: controller.masterPwdController,
                  errorText: controller.masterPwdValidate.value,
                  obscureText: !(controller.showMasterPwd.value),
                  onChangedText: (value) => controller.onChangedPwd(),
                  onTap: () => controller.onTapPwdTextField(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => controller.onEditingCompletePwd(),
                  focusNode: controller.masterPwdFocusNode,
                ),
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
                  hintText: TransactionConstants.confirmPassword.tr,
                  controller: controller.confirmMasterPwdController,
                  errorText: controller.confirmMasterPwdValidate.value,
                  obscureText: !(controller.showConfirmMasterPwd.value),
                  onChangedText: (value) => controller.onChangedConfirmPwd(),
                  onTap: () => controller.onTapConfirmPwdTextField(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      controller.onEditingCompleteConfirmPwd(),
                  focusNode: controller.confirmMasterPwdFocusNode,
                ),
              ),
              SizedBox(
                height: AppDimens.space_8,
              ),
              //Obx(() =>
              AppTextField(
                hintText: TransactionConstants.masterPasswordHint.tr,
                controller: controller.masterPwdHintController,
                onTap: () => controller.onTapMasterPwdHintTextField(),
                textInputAction: TextInputAction.done,
                onEditingComplete: () =>
                    controller.onEditingCompleteMasterPwdHint(),
                focusNode: controller.masterPwdHintFocusNode,
                maxLines: 7,
              ),
              //  ),
              SizedBox(
                height: AppDimens.space_4,
              ),
              Text(
                TransactionConstants.masterPasswordHintNote.tr,
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
                  title: TransactionConstants.save.tr,
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
                  TransactionConstants.masterPasswordNote.tr,
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
