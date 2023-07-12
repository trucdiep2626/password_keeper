import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/journey/login/login_controller.dart';
import 'package:password_keeper/presentation/theme/theme_text.dart';

class LogInScreen extends GetView<LoginController> {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      // appBar: AppBarWidget(
      //   onPressed: () => Get.back(),
      //   title: TransactionConstants.accountTitle.tr,
      // ),
      body: SizedBox(
        height: Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: Get.mediaQuery.padding.top + 68.sp,
            // ),
            Text('',
             // TransactionConstants.loginToYourAccount.tr,
              style: ThemeText.bodyMedium.s24,
            ),
            // SizedBox(
            //   height: 68.sp,
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
            //             asset: Assets.images.icMessage,
            //             color: controller.emailHasFocus.value
            //                 ? AppColors.primary
            //                 : AppColors.grey,
            //           ),
            //         ),
            //       ),
            //       hintText: TransactionConstants.email.tr,
            //       controller: controller.emailController,
            //       keyboardType: TextInputType.emailAddress,
            //       errorText: controller.emailValidate.value,
            //       onChangedText: (value) => controller.onChangedEmail(),
            //       onTap: () => controller.onTapEmailTextField(),
            //       textInputAction: TextInputAction.next,
            //       onEditingComplete: () => controller.onEditingCompleteEmail(),
            //       focusNode: controller.emailFocusNode,
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
            //       textInputAction: TextInputAction.done,
            //       onEditingComplete: () => controller.onEditingCompletePwd(),
            //       focusNode: controller.passwordFocusNode,
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
            // AppTouchable(
            //   onPressed: () => controller.onPressForgotPassword(),
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
            //     width: MediaQuery.of(context).size.width - 16.sp * 2,
            //     child: Text(
            //       TransactionConstants.forgetPassword.tr,
            //       style: ThemeText.bodySemibold.s12.copyWith(
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20.sp,
            // ),
            // Obx(
            //   () => Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //     child: AppButton(
            //       backgroundColor: AppColors.black,
            //       title: TransactionConstants.loginButton.tr,
            //       onPressed: () => controller.onPressedLogIn(),
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
            //     onPressed: controller.onPressRegister,
            //     child: Text(
            //       TransactionConstants.signupButton.tr,
            //       style: ThemeText.bodySemibold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
