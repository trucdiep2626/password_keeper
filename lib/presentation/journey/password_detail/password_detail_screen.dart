import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/password_detail/password_detail_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/confirm_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';
import 'package:password_keeper/presentation/widgets/password_strength_checker_widget.dart';

class PasswordDetailScreen extends GetView<PasswordDetailController> {
  const PasswordDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.grey50,
      appBar: AppBarWidget(
        showBackButton: true,
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
                        padding: EdgeInsets.only(
                          top: AppDimens.space_16,
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
          borderRadius: AppDimens.space_12,
        ),
        SizedBox(
          height: AppDimens.space_12,
        ),
        Row(
          children: [
            Expanded(
              child: AppTextField(
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
                        await Clipboard.setData(ClipboardData(
                            text: controller.password.value.password ?? ''));
                        // copied successfully
                        showTopSnackBar(
                          Get.context!,
                          message: TranslationConstants.copiedSuccessfully.tr,
                          type: SnackBarType.done,
                        );
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
                borderRadius: AppDimens.space_12,
              ),
            ),
          ],
        ),
        PasswordStrengthChecker(
            passwordStrength: controller.password.value.passwordStrengthLevel ??
                PasswordStrengthLevel.weak),
        SizedBox(
          height: AppDimens.space_12,
        ),
        controller.noteController.text.isEmpty
            ? SizedBox.shrink()
            : AppTextField(
                labelText: TranslationConstants.note.tr,
                controller: controller.noteController,
                borderColor: AppColors.white,
                borderRadius: AppDimens.space_12,
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
          leading: _buildAppIcon(item),
          title: Text(
            item.signInLocation ?? '',
            style: ThemeText.bodyMedium,
          ),
          subtitle: Text(
            item.userId ?? '',
            style: ThemeText.bodyRegular.s12.grey600Color,
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon(PasswordItem item) {
    if (item.appIcon != null) {
      return AppImageWidget(
        bytes: item.appIcon!,
        padding: EdgeInsets.all(AppDimens.space_2),
        backgroundColor: AppColors.white,
        size: AppDimens.space_36,
        margin: EdgeInsets.all(AppDimens.space_4),
        borderRadius: BorderRadius.circular(4),
      );
    }

    final firstLetter = (item.signInLocation ?? '').isURL
        ? (item.signInLocation ?? '').split('.').first[0]
        : (item.signInLocation ?? '')[0];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(AppDimens.space_2),
      margin: EdgeInsets.all(AppDimens.space_4),
      width: AppDimens.space_36,
      height: AppDimens.space_36,
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: ThemeText.bodyStrong.s24.blue400,
      ),
    );
  }
}
