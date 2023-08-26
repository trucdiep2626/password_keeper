import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/register/register_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_login_social_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.blue100,
      body: Stack(
        children: [
          _buildBody(),
          Obx(() => controller.rxLoadedGoogleButton.value == LoadedType.start
              ? const AppLoadingPage()
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
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
              TransactionConstants.createAccount.tr,
              style: ThemeText.bodySemibold.s18.blue400,
            ),
            SizedBox(
              height: AppDimens.space_4,
            ),
            Text(
              TransactionConstants.setupNewAccount.tr,
              style: ThemeText.bodyMedium.s14.grey600Color,
            ),
            SizedBox(
              height: AppDimens.space_48,
            ),
            Obx(
              () => AppTextField(
                prefixIcon: AppImageWidget(
                  fit: BoxFit.scaleDown,
                  asset: Assets.images.svg.icUser,
                  color: controller.fullNameHasFocus.value
                      ? AppColors.blue400
                      : AppColors.grey,
                ),
                hintText: TransactionConstants.fullname.tr,
                controller: controller.fullNameController,
                keyboardType: TextInputType.name,
                errorText: controller.fullNameValidate.value,
                onChangedText: (value) => controller.onChangedFullName(),
                onTap: () => controller.onTapFullNameTextField(),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => controller.onEditingCompleteFullName(),
                focusNode: controller.fullNameFocusNode,
              ),
            ),
            SizedBox(
              height: AppDimens.space_12,
            ),
            Obx(
              () => AppTextField(
                hintText: TransactionConstants.email.tr,
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
                onTap: () => controller.onTapEmailTextField(),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => controller.onEditingCompleteEmail(),
                focusNode: controller.emailFocusNode,
              ),
            ),
            SizedBox(
              height: AppDimens.space_12,
            ),
            Obx(
              () => AppTextField(
                prefixIcon: AppImageWidget(
                  fit: BoxFit.scaleDown,
                  asset: Assets.images.svg.icPassword,
                  color: controller.pwdHasFocus.value
                      ? AppColors.blue400
                      : AppColors.grey,
                ),
                suffixIcon: AppTouchable(
                  onPressed: controller.onChangedShowPassword,
                  child: AppImageWidget(
                    fit: BoxFit.scaleDown,
                    asset: controller.showPassword.value
                        ? Assets.images.svg.icEyeSlash
                        : Assets.images.svg.icEye,
                    color: controller.pwdHasFocus.value
                        ? AppColors.blue400
                        : AppColors.grey,
                  ),
                ),
                hintText: TransactionConstants.password.tr,
                controller: controller.passwordController,
                errorText: controller.passwordValidate.value,
                obscureText: !(controller.showPassword.value),
                onChangedText: (value) => controller.onChangedPwd(),
                onTap: () => controller.onTapPwdTextField(),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => controller.onEditingCompletePwd(),
                focusNode: controller.passwordFocusNode,
              ),
            ),
            SizedBox(
              height: AppDimens.space_12,
            ),
            Obx(
              () => AppTextField(
                prefixIcon: AppImageWidget(
                  fit: BoxFit.scaleDown,
                  asset: Assets.images.svg.icPasswordCheck,
                  color: controller.confirmPwdHasFocus.value
                      ? AppColors.blue400
                      : AppColors.grey,
                ),
                suffixIcon: AppTouchable(
                  onPressed: controller.onChangedShowConfirmPwd,
                  child: AppImageWidget(
                    fit: BoxFit.scaleDown,
                    asset: controller.showConfirmPassword.value
                        ? Assets.images.svg.icEyeSlash
                        : Assets.images.svg.icEye,
                    color: controller.confirmPwdHasFocus.value
                        ? AppColors.blue400
                        : AppColors.grey,
                  ),
                ),
                hintText: TransactionConstants.confirmPassword.tr,
                controller: controller.confirmPasswordController,
                errorText: controller.confirmPasswordValidate.value,
                obscureText: !(controller.showConfirmPassword.value),
                onChangedText: (value) => controller.onChangedConfirmPwd(),
                onTap: () => controller.onTapConfirmPwdTextField(),
                textInputAction: TextInputAction.next,
                onEditingComplete: () =>
                    controller.onEditingCompleteConfirmPwd(),
                focusNode: controller.confirmPasswordFocusNode,
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
              height: AppDimens.space_20,
            ),
            Obx(
              () => AppButton(
                enable: controller.buttonEnable.value,
                title: TransactionConstants.signUp.tr,
                onPressed: () => controller.onPressedRegister(),
                loaded: controller.rxLoadedButton.value,
              ),
            ),
            SizedBox(
              height: AppDimens.space_20,
            ),
            Text(
              TransactionConstants.orSignInWith.tr,
              style: ThemeText.bodyMedium.s16,
            ),
            SizedBox(
              height: AppDimens.space_12,
            ),
            AppLoginSocialWidget(
              icon: Assets.images.svg.icGoogle,
              onTap: () async => await controller.onTapGoogleSignIn(),
            ),

            //  const Spacer(),
            SizedBox(
              height: AppDimens.space_48,
            ),
            RichText(
              text: TextSpan(
                text: TransactionConstants.alreadyHaveAnAccount.tr,
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
                        TransactionConstants.signIn.tr,
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
    );
  }
}
