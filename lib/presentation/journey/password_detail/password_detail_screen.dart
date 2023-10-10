import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/password_detail/password_detail_controller.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/app_icon_widget.dart';
import 'package:password_keeper/presentation/widgets/confirm_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class PasswordDetailScreen extends GetView<PasswordDetailController> {
  const PasswordDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Listener(
      onPointerDown: Get.find<SettingsController>().handleUserInteraction,
      child: WillPopScope(
        onWillPop: () async {
          Get.back(result: controller.needRefreshList.value);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.background,
          appBar: AppBarWidget(
            showBackButton: true,
            onTapBack: () => Get.back(result: controller.needRefreshList.value),
            title: TranslationConstants.passwordDetail.tr,
          ),
          bottomNavigationBar: ConfirmWidget(
            firstOnTap: () => controller.goToEdit(),
            firstText: TranslationConstants.edit.tr,
            secondOnTap: () async => await controller.deleteItem(),
            secondText: TranslationConstants.delete.tr,
            activeFirst: true,
          ),
          body: Obx(
            () => controller.rxLoadedDetail.value == LoadedType.start
                ? const AppLoadingPage()
                : Padding(
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
                          _getSignInLocation(controller.password.value),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppDimens.space_12),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${TranslationConstants.passwordSecurity.tr}: ',
                                    style: ThemeText.bodyMedium.grey600Color,
                                  ),
                                  TextSpan(
                                    text: controller.password.value
                                        .passwordStrengthLevel?.value,
                                    style: ThemeText.bodySemibold.copyWith(
                                        color: controller.password.value
                                            .passwordStrengthLevel?.color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              // top: AppDimens.space_16,
                              bottom: AppDimens.space_12,
                            ),
                            child: Text(
                              TranslationConstants.accountInformation.tr,
                              style: ThemeText.bodyMedium.grey600Color,
                            ),
                          ),
                          _buildAccount()
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccount() {
    return Column(
      children: [
        AppTextField(
          readOnly: true,
          labelText: TranslationConstants.userId.tr,
          controller: controller.userIdController,
          borderColor: AppColors.white,
          borderRadius: AppDimens.radius_12,
        ),
        SizedBox(
          height: AppDimens.space_12,
        ),

        AppTextField(
          readOnly: true,
          suffixIcon: Row(
            children: [
              AppTouchable(
                onPressed: controller.onChangedShowPassword,
                child: AppImageWidget(
                  fit: BoxFit.scaleDown,
                  size: AppDimens.space_24,
                  asset: controller.showPassword.value
                      ? Assets.images.svg.icEyeSlash
                      : Assets.images.svg.icEye,
                  color: AppColors.grey,
                ),
              ),
              AppTouchable(
                onPressed: () async {
                  await copyText(
                      text: controller.password.value.password ?? '');
                },
                margin: EdgeInsets.only(left: AppDimens.space_8),
                child: AppImageWidget(
                  size: AppDimens.space_24,
                  asset: Assets.images.svg.icCopy,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          numSuffixIcon: 2,
          labelText: TranslationConstants.password.tr,
          controller: controller.passwordController,
          obscureText: !(controller.showPassword.value),
          borderColor: AppColors.white,
          borderRadius: AppDimens.radius_12,
        ),

        // PasswordStrengthChecker(
        //     passwordStrength: controller.password.value.passwordStrengthLevel ??
        //         PasswordStrengthLevel.weak),
        SizedBox(
          height: AppDimens.space_12,
        ),
        controller.noteController.text.isEmpty
            ? const SizedBox.shrink()
            : AppTextField(
                labelText: TranslationConstants.note.tr,
                controller: controller.noteController,
                borderColor: AppColors.white,
                borderRadius: AppDimens.radius_12,
              ),
      ],
    );
  }

  Widget _getSignInLocation(PasswordItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.space_4),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.radius_12)),
        child: ListTile(
          leading: AppIconWidget(
            item: item,
          ),
          title: Text(
            item.signInLocation ?? '',
            style: ThemeText.bodyMedium,
          ),
        ),
      ),
    );
  }
}
