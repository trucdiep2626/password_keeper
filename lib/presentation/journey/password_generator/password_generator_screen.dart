import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class PasswordGeneratorScreen extends GetView<PasswordGeneratorController> {
  const PasswordGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: AppBar(
          backgroundColor: AppColors.blue400,
          title: Text(
            TranslationConstants.passwordGenerator.tr,
            style: ThemeText.bodySemibold.colorWhite,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.space_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordValue(),
                Padding(
                  padding: EdgeInsets.all(AppDimens.space_16),
                  child: Text(
                    TranslationConstants.options.tr,
                    style: ThemeText.bodyMedium.grey600Color,
                  ),
                ),
                _buildOptionals(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionals() {
    return Container(
      // padding: EdgeInsets.all(AppDimens.space_16),
      color: AppColors.white,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: AppDimens.space_16,
                left: AppDimens.space_16,
                right: AppDimens.space_16,
              ),
              child: Text(
                '${TranslationConstants.passwordLength.tr}: ${controller.pwdLength.value}',
                style: ThemeText.bodyRegular.grey600Color,
              ),
            ),
            Slider(
              value: controller.pwdLength.value.toDouble(),
              max: 100,
              min: 8,
              divisions: 5,
              activeColor: AppColors.blue400,
              inactiveColor: AppColors.blue200,
              onChanged: (double value) =>
                  controller.onChangedPwdLength(value.round()),
            ),
            SwitchListTile(
              activeColor: AppColors.blue400,
              value: controller.useUppercase.value,
              onChanged: (value) => controller.onChangedUseUppercase(),
              title: Text(
                TranslationConstants.uppercaseLetters.tr,
                style: ThemeText.bodyRegular.grey600Color,
              ),
            ),
            SwitchListTile(
              activeColor: AppColors.blue400,
              value: controller.useLowercase.value,
              onChanged: (value) => controller.onChangedUseLowercase(),
              title: Text(
                TranslationConstants.lowercaseLetters.tr,
                style: ThemeText.bodyRegular.grey600Color,
              ),
            ),
            SwitchListTile(
              activeColor: AppColors.blue400,
              value: controller.useNumbers.value,
              onChanged: (value) => controller.onChangedUseNumbers(),
              title: Text(
                TranslationConstants.numbers.tr,
                style: ThemeText.bodyRegular.grey600Color,
              ),
            ),
            SwitchListTile(
              activeColor: AppColors.blue400,
              value: controller.useSpecial.value,
              onChanged: (value) => controller.onChangedUseSpecial(),
              title: Text(
                TranslationConstants.specialCharacters.tr,
                style: ThemeText.bodyRegular.grey600Color,
              ),
            ),
            ListTile(
              title: Text(
                TranslationConstants.minimumNumbers.tr,
                style: ThemeText.bodyRegular.grey600Color,
              ),
              trailing: Obx(
                () => _buildChangeQuantity(
                  onPressedIncrease: () => controller.increaseMinimumNumbers(),
                  onPressedDecrease: () => controller.decreaseMinimumNumbers(),
                  value: controller.minimumNumbers.value,
                ),
              ),
            ),
            ListTile(
              title: Text(
                TranslationConstants.minimumSpecial.tr,
                style: ThemeText.bodyRegular.grey600Color,
              ),
              trailing: Obx(
                () => _buildChangeQuantity(
                  onPressedIncrease: () => controller.increaseMinimumSpecial(),
                  onPressedDecrease: () => controller.decreaseMinimumSpecial(),
                  value: controller.minimumSpecial.value,
                ),
              ),
            ),
            SwitchListTile(
              activeColor: AppColors.blue400,
              value: controller.avoidAmbiguous.value,
              onChanged: (value) => controller.onChangedAvoidAmbiguous(),
              title: Text(
                TranslationConstants.avoidAmbiguousCharacters.tr,
                style: ThemeText.bodyRegular.grey600Color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeQuantity({
    required void Function() onPressedIncrease,
    required void Function() onPressedDecrease,
    required int value,
  }) {
    return SizedBox(
      width: Get.width / 3,
      child: Row(
        children: [
          Expanded(
            child: AppTouchable(
              backgroundColor: AppColors.blue200,
              onPressed: onPressedIncrease,
              child: Text(
                "+",
                style: ThemeText.bodyMedium.s24.blue400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: ThemeText.bodySemibold.blue400,
            ),
          ),
          Expanded(
            child: AppTouchable(
              backgroundColor: AppColors.blue200.withOpacity(0.5),
              onPressed: onPressedDecrease,
              child: Text(
                "-",
                style: ThemeText.bodyMedium.s24.blue400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordValue() {
    return Container(
      padding: EdgeInsets.all(AppDimens.space_16),
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => Text(
                controller.generatedPassword.value,
                style: ThemeText.bodyMedium.s20,
              ),
            ),
          ),
          SizedBox(
            width: AppDimens.space_16,
          ),
          AppTouchable(
            onPressed: () async {
              await Clipboard.setData(
                  ClipboardData(text: controller.generatedPassword.value));
              // copied successfully
              showTopSnackBar(Get.context!,
                  message: TranslationConstants.copiedSuccessfully.tr,
                  type: SnackBarType.done);
            },
            child: AppImageWidget(
              asset: Assets.images.svg.icGenerator,
            ),
          ),
          SizedBox(
            width: AppDimens.space_16,
          ),
          AppTouchable(
            onPressed: () => controller.generatePassword(),
            child: AppImageWidget(
              asset: Assets.images.svg.icGenerator,
            ),
          ),
        ],
      ),
    );
  }
}
