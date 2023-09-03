import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/login/login_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_login_social_widget.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class LogInScreen extends GetView<LoginController> {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Obx(() => controller.rxLoadedGoogleButton.value == LoadedType.start
              ? const AppLoadingPage()
              : const SizedBox.shrink()),
        ],
      ),
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
                height: Get.mediaQuery.padding.top + AppDimens.height_36,
              ),
              AppImageWidget(
                asset: Assets.images.svg.authenticationBackground,
                size: AppDimens.space_160,
              ),
              SizedBox(
                height: AppDimens.space_8,
              ),
              Text(
                TranslationConstants.signIn.tr,
                style: ThemeText.bodySemibold.s18.blue400,
              ),
              SizedBox(
                height: AppDimens.space_4,
              ),
              Text(
                TranslationConstants.setupNewAccount.tr,
                style: ThemeText.bodyMedium.s14.grey600Color,
              ),
              SizedBox(
                height: AppDimens.space_48,
              ),
              Obx(
                () => AppTextField(
                  prefixIcon: AppImageWidget(
                    fit: BoxFit.scaleDown,
                    asset: Assets.images.svg.icMessage,
                    color: controller.emailHasFocus.value
                        ? AppColors.blue400
                        : AppColors.grey,
                  ),
                  hintText: TranslationConstants.email.tr,
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
                  hintText: TranslationConstants.password.tr,
                  controller: controller.passwordController,
                  errorText: controller.passwordValidate.value,
                  obscureText: !(controller.showPassword.value),
                  onChangedText: (value) => controller.onChangedPwd(),
                  onTap: () => controller.onTapPwdTextField(),
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => controller.onEditingCompletePwd(),
                  focusNode: controller.passwordFocusNode,
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
                  title: TranslationConstants.signIn.tr,
                  onPressed: () => controller.onPressedLogIn(),
                  loaded: controller.rxLoadedButton.value,
                ),
              ),
              SizedBox(
                height: AppDimens.space_20,
              ),
              Text(
                TranslationConstants.orSignInWith.tr,
                style: ThemeText.bodyMedium.s16,
              ),
              SizedBox(
                height: AppDimens.space_12,
              ),
              AppLoginSocialWidget(
                  icon: Assets.images.svg.icGoogle,
                  onTap: () async => await controller.onTapGoogleSignIn()),
              const Spacer(),
              AppTouchable(
                  onPressed: () => controller.onPressForgotPassword(),
                  child: Text(
                    TranslationConstants.forgetPassword.tr,
                    style: ThemeText.bodySemibold.blue400,
                  )),
              SizedBox(
                height: AppDimens.height_8,
              ),
              RichText(
                text: TextSpan(
                  text: TranslationConstants.dontHaveAnAccount.tr,
                  style: ThemeText.bodyMedium,
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: AppTouchable(
                        onPressed: () {
                          controller.onPressRegister();
                        },
                        padding: EdgeInsets.only(left: AppDimens.space_4),
                        child: Text(
                          TranslationConstants.signUp.tr,
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
