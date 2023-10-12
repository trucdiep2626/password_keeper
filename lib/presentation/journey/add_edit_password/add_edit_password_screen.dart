import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/controllers/auto_fill_controller.dart';
import 'package:password_keeper/presentation/journey/add_edit_password/add_edit_password_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/confirm_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';
import 'package:password_keeper/presentation/widgets/password_strength_checker_widget.dart';

class AddEditPasswordScreen extends GetView<AddEditPasswordController> {
  const AddEditPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Listener(
      onPointerDown: Get.find<AutofillController>().autofillState.value ==
              AutofillState.saving
          ? null
          : Get.find<SettingsController>().handleUserInteraction,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.background,
            appBar: AppBarWidget(
              showBackButton: true,
              title: controller.oldPassword == null
                  ? TranslationConstants.addNewPassword.tr
                  : TranslationConstants.editPassword.tr,
            ),
            bottomNavigationBar: Obx(
              () => ConfirmWidget(
                firstOnTap: () async => await controller.handleSave(),
                firstText: TranslationConstants.save.tr,
                secondOnTap: () => Get.back(),
                secondText: TranslationConstants.cancel.tr,
                activeFirst: controller.buttonEnable.value,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(AppDimens.space_16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: AppDimens.space_12,
                      ),
                      child: Text(
                        TranslationConstants.signInLocationOrApp.tr,
                        style: ThemeText.bodyMedium.grey600Color,
                      ),
                    ),
                    Obx(
                      () => AppTouchable(
                        alignment: Alignment.centerLeft,
                        onPressed: () async =>
                            await controller.onPressPickLocationOrApp(),
                        backgroundColor: AppColors.white,
                        width: Get.width,
                        padding: EdgeInsets.all(AppDimens.space_16),
                        child: Row(
                          children: _getSignInLocation(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: AppDimens.space_16,
                        bottom: AppDimens.space_12,
                      ),
                      child: Text(
                        TranslationConstants.accountInformation.tr,
                        style: ThemeText.bodyMedium.grey600Color,
                      ),
                    ),
                    _buildAccount(),
                    SizedBox(
                      height: Get.height / 2,
                    )
                  ],
                ),
              ),
            ),
          ),
          Obx(() => controller.rxLoadedButton.value == LoadedType.start
              ? const AppLoadingPage()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildAccount() {
    return Column(
      children: [
        Obx(
          () => AppTextField(
            labelText: TranslationConstants.userId.tr,
            hintText: TranslationConstants.userId.tr,
            controller: controller.userIdController,
            keyboardType: TextInputType.name,
            errorText: controller.userIdValidate.value,
            onChangedText: (value) => controller.onChangedUserId(),
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(controller.context)
                .requestFocus(controller.passwordFocusNode),
            focusNode: controller.userIdFocusNode,
            borderColor: AppColors.white,
            borderRadius: AppDimens.radius_12,
          ),
        ),
        SizedBox(
          height: AppDimens.space_12,
        ),
        Obx(
          () => AppTextField(
            suffixIcon: Row(
              children: [
                AppTouchable(
                  onPressed: controller.onChangedShowPassword,
                  child: AppImageWidget(
                    size: AppDimens.space_20,
                    asset: controller.showPassword.value
                        ? Assets.images.svg.icEyeSlash
                        : Assets.images.svg.icEye,
                    color: AppColors.grey,
                  ),
                ),
                AppTouchable(
                  margin: EdgeInsets.only(left: AppDimens.space_16),
                  onPressed: () async =>
                      await controller.onPressedGeneratePassword(),
                  child: AppImageWidget(
                    size: AppDimens.space_20,
                    asset: Assets.images.svg.icGenerator,
                    color: AppColors.grey,
                  ),
                )
              ],
            ),
            numSuffixIcon: 2,
            labelText: TranslationConstants.password.tr,
            hintText: TranslationConstants.password.tr,
            controller: controller.passwordController,
            errorText: controller.passwordValidate.value,
            obscureText: !(controller.showPassword.value),
            onChangedText: (value) => controller.onChangedPwd(),
            textInputAction: TextInputAction.done,
            onEditingComplete: () =>
                FocusScope.of(controller.context).unfocus(),
            focusNode: controller.passwordFocusNode,
            borderColor: AppColors.white,
            borderRadius: AppDimens.radius_12,
          ),
        ),
        Obx(
          () => controller.showPasswordStrengthChecker.value
              ? PasswordStrengthChecker(
                  passwordStrength: controller.passwordStrength.value)
              : const SizedBox.shrink(),
        ),
        SizedBox(
          height: AppDimens.space_12,
        ),
        AppTextField(
          labelText: TranslationConstants.note.tr,
          hintText: TranslationConstants.noteOptional.tr,
          controller: controller.noteController,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          onEditingComplete: () => FocusScope.of(controller.context).unfocus(),
          focusNode: controller.noteFocusNode,
          borderColor: AppColors.white,
          borderRadius: AppDimens.radius_12,
        ),
      ],
    );
  }

  List<Widget> _getSignInLocation() {
    List<Widget> item = [];
    if (!isNullEmpty(controller.selectedApp.value)) {
      item.addAll(
        [
          AppImageWidget(
            bytes: controller.selectedApp.value!.icon!,
            padding: EdgeInsets.all(AppDimens.space_2),
            backgroundColor: AppColors.white,
            size: AppDimens.space_36,
            margin: EdgeInsets.all(AppDimens.space_4),
            borderRadius: BorderRadius.circular(AppDimens.radius_4),
          ),
          SizedBox(
            width: AppDimens.space_16,
          ),
          Expanded(
            child: Text(
              controller.selectedApp.value?.name ?? '',
              style: ThemeText.bodyRegular,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );
    } else if (!isNullEmpty(controller.selectedUrl.value)) {
      item.addAll([
        Text(
          controller.selectedUrl.value,
          style: ThemeText.bodyRegular,
          textAlign: TextAlign.start,
        ),
        const Spacer(),
      ]);
    } else {
      item.addAll([
        Text(
          TranslationConstants.set.tr,
          style: ThemeText.bodyRegular,
          textAlign: TextAlign.start,
        ),
        const Spacer(),
      ]);
    }
    return item;
  }
}
