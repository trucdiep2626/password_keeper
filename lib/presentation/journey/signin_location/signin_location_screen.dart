import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/journey/signin_location/signin_location_controller.dart';
import 'package:password_keeper/presentation/theme/theme_color.dart';
import 'package:password_keeper/presentation/theme/theme_text.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class SignInLocationScreen extends GetView<SignInLocationController> {
  const SignInLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.blue400,
        title: Text(
          TranslationConstants.signInLocationOrApp.tr,
          style: ThemeText.bodySemibold.colorWhite.s16,
        ),
      ),
      body: SizedBox(
        height: Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSignInLocation(),
            Expanded(child: _buildApps()),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppDimens.space_16,
            top: AppDimens.space_16,
            bottom: AppDimens.space_16,
          ),
          child: Text(
            TranslationConstants.signInLocation.tr,
            style: ThemeText.bodyMedium.grey600Color,
          ),
        ),
        AppTextField(
          backgroundColor: AppColors.white,
          hintText: TranslationConstants.enterWebAddr.tr,
          controller: controller.webAddrController,
          keyboardType: TextInputType.url,
          borderColor: AppColors.white,
          //   errorText: controller.emailValidate.value,
          //   onChangedText: (value) => controller.onChangedEmail(),
          //    onTap: () => controller.onTapEmailTextField(),
          textInputAction: TextInputAction.done,
          onEditingComplete: () => controller.onEditingCompleteWebAddr(),
          //  focusNode: controller.emailFocusNode,
        ),
      ],
    );
  }

  Widget _buildApps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppDimens.space_16,
            top: AppDimens.space_16,
            bottom: AppDimens.space_16,
          ),
          child: Text(
            TranslationConstants.apps.tr,
            style: ThemeText.bodyMedium.grey600Color,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(AppDimens.space_16),
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Obx(
              () => Scrollbar(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final app = controller.apps[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppImageWidget(
                          bytes: app.icon!,
                          padding: EdgeInsets.all(AppDimens.space_2),
                          backgroundColor: AppColors.white,
                          size: AppDimens.space_36,
                          //  border: Border.all(color: AppColors.blue200),
                          margin: EdgeInsets.all(AppDimens.space_4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        SizedBox(
                          width: AppDimens.space_16,
                        ),
                        Expanded(
                          child: Text(
                            app.name ?? '',
                            style: ThemeText.bodyRegular,
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.blue200,
                  ),
                  itemCount: controller.apps.length,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
