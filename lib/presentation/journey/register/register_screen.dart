import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/register/register_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/theme/theme_text.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      // appBar: AppBarWidget(
      //   onPressed: () => Get.back(),
      //   title: TransactionConstants.signUpTitle.tr,
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.mediaQuery.padding.top + AppDimens.space_48,
            ),
            Text(
              TransactionConstants.createAccount.tr,
              style: ThemeText.bodyMedium.s24,
            ),
            SizedBox(
              height: AppDimens.space_48,
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal:AppDimens.space_16),
                child: AppTextField(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: AppDimens.space_18,
                      right: AppDimens.space_12,
                    ),
                    child: SizedBox(
                      width: AppDimens.space_20,
                      height: AppDimens.space_20,
                      child: AppImageWidget(
                        fit: BoxFit.scaleDown,
                        asset: Assets.images.svg.icMessage,
                        color: controller.emailHasFocus.value
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                  ),
                  hintText: TransactionConstants.email.tr,
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
            ),
            // SizedBox(
            //   height: 10.sp,
            // ),
            // Obx(
            //   () => Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //     child: AppTextField(
            //       prefixIcon: Padding(
            //         padding: EdgeInsets.only(
            //           left: 18.sp,
            //           right: 12.sp,
            //         ),
            //         child: SizedBox(
            //           width: 20.sp,
            //           height: 20.sp,
            //           child: AppImageWidget(
            //             fit: BoxFit.scaleDown,
            //             asset: Assets.images.icPassword,
            //             color: controller.pwdHasFocus.value
            //                 ? AppColors.primary
            //                 : AppColors.grey,
            //           ),
            //         ),
            //       ),
            //       hintText: TransactionConstants.password.tr,
            //       controller: controller.passwordController,
            //       errorText: controller.passwordValidate.value,
            //       obscureText: true,
            //       onChangedText: (value) => controller.onChangedPwd(),
            //       onTap: () => controller.onTapPwdTextField(),
            //       textInputAction: TextInputAction.next,
            //       onEditingComplete: () => controller.onEditingCompletePwd(),
            //       focusNode: controller.passwordFocusNode,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10.sp,
            // ),
            // Obx(
            //   () => Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //     child: AppTextField(
            //       prefixIcon: Padding(
            //         padding: EdgeInsets.only(
            //           left: 18.sp,
            //           right: 12.sp,
            //         ),
            //         child: SizedBox(
            //           width: 20.sp,
            //           height: 20.sp,
            //           child: AppImageWidget(
            //             fit: BoxFit.scaleDown,
            //             asset: Assets.images.icPassword,
            //             color: controller.confirmPwdHasFocus.value
            //                 ? AppColors.primary
            //                 : AppColors.grey,
            //           ),
            //         ),
            //       ),
            //       hintText: 'Confirm password',
            //       controller: controller.confirmPasswordController,
            //       errorText: controller.confirmPasswordValidate.value,
            //       obscureText: true,
            //       onChangedText: (value) => controller.onChangedConfirmPwd(),
            //       onTap: () => controller.onTapConfirmPwdTextField(),
            //       textInputAction: TextInputAction.next,
            //       onEditingComplete: () =>
            //           controller.onEditingCompleteConfirmPwd(),
            //       focusNode: controller.confirmPasswordFocusNode,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10.sp,
            // ),
            // Obx(
            //   () => Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //     child: AppTextField(
            //       prefixIcon: Padding(
            //         padding: EdgeInsets.only(
            //           left: 18.sp,
            //           right: 12.sp,
            //         ),
            //         child: SizedBox(
            //           width: 20.sp,
            //           height: 20.sp,
            //           child: AppImageWidget(
            //             fit: BoxFit.scaleDown,
            //             asset: Assets.images.icUser,
            //             color: controller.firstNameHasFocus.value
            //                 ? AppColors.primary
            //                 : AppColors.grey,
            //           ),
            //         ),
            //       ),
            //       hintText: TransactionConstants.firstName.tr,
            //       controller: controller.firstNameController,
            //       keyboardType: TextInputType.name,
            //       errorText: controller.firstNameValidate.value,
            //       onChangedText: (value) => controller.onChangedFirstName(),
            //       onTap: () => controller.onTapFirstNameTextField(),
            //       textInputAction: TextInputAction.next,
            //       onEditingComplete: () =>
            //           controller.onEditingCompleteFirstName(),
            //       focusNode: controller.firstNameFocusNode,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10.sp,
            // ),
            // Obx(
            //   () => Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //     child: AppTextField(
            //       prefixIcon: Padding(
            //         padding: EdgeInsets.only(
            //           left: 18.sp,
            //           right: 12.sp,
            //         ),
            //         child: SizedBox(
            //           width: 20.sp,
            //           height: 20.sp,
            //           child: AppImageWidget(
            //             fit: BoxFit.scaleDown,
            //             asset: Assets.images.icUser,
            //             color: controller.lastNameHasFocus.value
            //                 ? AppColors.primary
            //                 : AppColors.grey,
            //           ),
            //         ),
            //       ),
            //       hintText: TransactionConstants.lastName.tr,
            //       controller: controller.lastNameController,
            //       errorText: controller.lastNameValidate.value,
            //       //  obscureText: true,
            //       onChangedText: (value) => controller.onChangedLastName(),
            //       onTap: () => controller.onTapLastNameTextField(),
            //       textInputAction: TextInputAction.done,
            //       onEditingComplete: () =>
            //           controller.onEditingCompleteLastName(),
            //       focusNode: controller.lastNameFocusNode,
            //     ),
            //   ),
            // ),
            // Obx(
            //   () => controller.errorText.value.isNotEmpty
            //       ? Container(
            //           margin: EdgeInsets.symmetric(
            //             horizontal: 16.sp,
            //             vertical: 4.sp,
            //           ),
            //           width: MediaQuery.of(context).size.width - 16.sp * 2,
            //           child: Text(
            //             controller.errorText.value,
            //             style: ThemeText.errorText,
            //           ),
            //         )
            //       : const SizedBox.shrink(),
            // ),
            // SizedBox(
            //   height: 48.sp,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //   child: Obx(
            //     () => AppButton(
            //       backgroundColor: AppColors.black,
            //       title: TransactionConstants.signupButton.tr,
            //       onPressed: () => controller.onPressedRegister(),
            //       loaded: controller.rxLoadedButton.value,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20.sp,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //   child: AppTouchable(
            //     backgroundColor: AppColors.white,
            //     onPressed: controller.onPressLogin,
            //     child: Text(
            //       TransactionConstants.loginButton.tr,
            //       style: ThemeText.bodySemibold,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 48.sp,
            // ),
          ],
        ),
      ),
    );
  }
}
