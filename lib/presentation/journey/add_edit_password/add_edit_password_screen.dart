import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/add_edit_password/add_edit_password_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class AddEditPasswordScreen extends GetView<AddEditPasswordController> {
  const AddEditPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.blue400,
        title: Text(
          TranslationConstants.addNewPassword.tr,
          style: ThemeText.bodySemibold.colorWhite.s16,
        ),
        actions: [
          GestureDetector(
            onTap: controller.handleSave,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.space_16),
              child: Center(
                  child: AppImageWidget(
                asset: Assets.images.svg.icAdd,
                color: AppColors.white,
                size: AppDimens.space_32,
              )
                  // Text(
                  //   TranslationConstants.save.tr,
                  //   style: ThemeText.bodyMedium.colorWhite,
                  // ),
                  ),
            ),
          )
        ],
      ),

      // bottomNavigationBar: ConfirmWidget(
      //   firstOnTap: controller.handleSave,
      //   firstText: TranslationConstants.save,
      // ),
      body: Padding(
        padding: EdgeInsets.all(AppDimens.space_16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  // left: AppDimens.space_16,
                  //  top: AppDimens.space_16,
                  bottom: AppDimens.space_12,
                ),
                child: Text(
                  TranslationConstants.signInLocationOrApp.tr,
                  style: ThemeText.bodyMedium.grey600Color,
                ),
              ),
              AppTouchable(
                alignment: Alignment.centerLeft,
                onPressed: () {},
                //controller.onPressPickLocationOrApp,
                backgroundColor: AppColors.white,
                width: Get.width,
                padding: EdgeInsets.all(AppDimens.space_16),
                child: Row(
                  children: [
                    Text(
                      TranslationConstants.set.tr,
                      style: ThemeText.bodyRegular,
                      textAlign: TextAlign.start,
                    ),
                    Spacer()
                  ],
                ),
              ),
              SizedBox(
                height: AppDimens.space_12,
              ),
              Obx(
                () => AppTextField(
                  // prefixIcon: AppImageWidget(
                  //   fit: BoxFit.scaleDown,
                  //   asset: Assets.images.svg.icMessage,
                  //   color: controller.userIdHasFocus.value
                  //       ? AppColors.blue400
                  //       : AppColors.grey,
                  // ),
                  labelText: TranslationConstants.userId.tr,
                  hintText: TranslationConstants.userId.tr,
                  controller: controller.userIdController,
                  keyboardType: TextInputType.name,
                  errorText: controller.userIdValidate.value,
                  onChangedText: (value) => controller.onChangedUserId(),
                  onTap: () => controller.onTapUserIdTextField(),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => controller.onEditingCompleteUserId(),
                  focusNode: controller.userIdFocusNode,
                  borderColor: AppColors.white,
                  borderRadius: AppDimens.space_12,
                ),
              ),
              SizedBox(
                height: AppDimens.space_12,
              ),
              Obx(
                () => AppTextField(
                  // prefixIcon: AppImageWidget(
                  //   fit: BoxFit.scaleDown,
                  //   asset: Assets.images.svg.icPassword,
                  //   color: controller.pwdHasFocus.value
                  //       ? AppColors.blue400
                  //       : AppColors.grey,
                  // ),
                  suffixIcon: AppTouchable(
                    onPressed: controller.onChangedShowPassword,
                    child: AppImageWidget(
                      fit: BoxFit.scaleDown,
                      asset: controller.showPassword.value
                          ? Assets.images.svg.icEyeSlash
                          : Assets.images.svg.icEye,
                      color:
                          // controller.pwdHasFocus.value
                          //     ? AppColors.blue400
                          //     :
                          AppColors.grey,
                    ),
                  ),
                  labelText: TranslationConstants.password.tr,
                  hintText: TranslationConstants.password.tr,
                  controller: controller.passwordController,
                  errorText: controller.passwordValidate.value,
                  obscureText: !(controller.showPassword.value),
                  onChangedText: (value) => controller.onChangedPwd(),
                  onTap: () => controller.onTapPwdTextField(),
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => controller.onEditingCompletePwd(),
                  focusNode: controller.passwordFocusNode,
                  borderColor: AppColors.white,
                  borderRadius: AppDimens.space_12,
                ),
              ),
              SizedBox(
                height: AppDimens.space_12,
              ),
              AppTextField(
                labelText: TranslationConstants.note.tr,
                hintText: TranslationConstants.noteOptional.tr,
                controller: controller.noteController,
                onTap: () => controller.onTapNoteTextField(),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onEditingComplete: () => controller.onEditingCompleteNote(),
                focusNode: controller.noteFocusNode,
                borderColor: AppColors.white,
                borderRadius: AppDimens.space_12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
