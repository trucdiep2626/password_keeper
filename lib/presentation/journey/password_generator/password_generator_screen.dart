import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/app_routes.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/journey/password_generator/password_generator_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_appbar.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class PasswordGeneratorScreen extends GetView<PasswordGeneratorController> {
  const PasswordGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBarWidget(
        title: TranslationConstants.passwordGenerator.tr,
        showBackButton: controller.fromAddPassword.value,
        actions: [
          Obx(
            () => controller.fromAddPassword.value
                ? AppTouchable(
                    padding: EdgeInsets.all(AppDimens.space_8),
                    onPressed: () =>
                        Get.back(result: controller.generatedPassword.value),
                    child: Center(
                        child: Icon(
                      Icons.check,
                      size: AppDimens.space_30,
                      color: AppColors.white,
                    )
                        // AppImageWidget(
                        //   margin: EdgeInsets.all(AppDimens.space_8),
                        //   color: AppColors.white,
                        //   size: AppDimens.space_24,
                        //   asset: Assets.images.svg.icTick,
                        // ),
                        ),
                  )
                : AppTouchable(
                    onPressed: () => Get.toNamed(AppRoutes.history),
                    child: Center(
                      child: AppImageWidget(
                        margin: EdgeInsets.all(AppDimens.space_8),
                        color: AppColors.white,
                        size: AppDimens.space_24 + 8,
                        asset: Assets.images.svg.icHistory,
                      ),
                    ),
                  ),
          )
        ],
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
              //options
              Container(
                color: AppColors.white,
                child: Obx(() =>
                        // Column(
                        //   children: [
                        // _buildPasswordType(),
                        // controller.selectedType.value == PasswordType.password
                        //     ?
                        _buildOptionalsForPassword()
                    //     : _buildOptionalsForPassphrase()
                    //   ],
                    // ),
                    ),
              ),

              SizedBox(
                height: AppDimens.space_24,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: AppDimens.space_16,
            left: AppDimens.space_16,
            right: AppDimens.space_16,
          ),
          child: Text(
            TranslationConstants.passwordType.tr,
            style: ThemeText.bodyMedium.grey700Color,
          ),
        ),
        RadioListTile(
          activeColor: AppColors.blue400,
          title: Text(
            PasswordType.password.name.capitalize ?? '',
            style: ThemeText.bodyRegular.grey600Color,
          ),
          value: PasswordType.password,
          groupValue: controller.selectedType.value,
          onChanged: (value) =>
              controller.onChangedPasswordType(PasswordType.password),
        ),
        RadioListTile(
          activeColor: AppColors.blue400,
          title: Text(
            PasswordType.passphrase.name.capitalize ?? '',
            style: ThemeText.bodyRegular.grey600Color,
          ),
          value: PasswordType.passphrase,
          groupValue: controller.selectedType.value,
          onChanged: (value) =>
              controller.onChangedPasswordType(PasswordType.passphrase),
        ),
      ],
    );
  }

  Widget _buildOptionalsForPassphrase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //num of words
        ListTile(
          title: Text(
            TranslationConstants.numWords.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
          trailing: Obx(
            () => _buildChangeQuantity(
              onPressedIncrease: () async =>
                  await controller.increaseNumWords(),
              onPressedDecrease: () async =>
                  await controller.decreaseNumWords(),
              value: controller.numWords.value,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: AppDimens.space_16),
          child: Text(
            TranslationConstants.wordSeparator.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),
        //word separator
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.space_16),
          child: AppTextField(
            contentPadding: EdgeInsets.zero,
            isUnderline: true,
            borderColor: AppColors.grey400,
            //  labelText: TranslationConstants.wordSeparator.tr,
            controller: controller.wordSeparatorColtroller,
            //      onTap: () => controller.onTapMasterPwdHintTextField(),
            //    textInputAction: TextInputAction.done,
            // onEditingComplete: () =>
            //     controller.onEditingCompleteMasterPwdHint(),
            //   focusNode: controller.masterPwdHintFocusNode,
            maxLines: 7,
          ),
        ),

        //capitalize
        SwitchListTile(
          activeColor: AppColors.blue400,
          value: controller.capitalize.value,
          onChanged: (value) async => await controller.onChangedCapitalize(),
          title: Text(
            TranslationConstants.capitalize.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),

        //include number
        SwitchListTile(
          activeColor: AppColors.blue400,
          value: controller.includeNumber.value,
          onChanged: (value) async => await controller.onChangedIncludeNumber(),
          title: Text(
            TranslationConstants.includeNumber.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionalsForPassword() {
    final minLengthRequired =
        controller.minSpecial.value + controller.minNumbers.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //password length
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
          min: (minLengthRequired > 8 ? minLengthRequired : 8).toDouble(),
          //   divisions: 1,
          activeColor: AppColors.blue400,
          inactiveColor: AppColors.blue200,
          onChanged: (double value) async =>
              await controller.onChangedPwdLength(value.round()),
        ),

        //uppercase
        SwitchListTile(
          activeColor: AppColors.blue400,
          value: controller.useUppercase.value,
          onChanged: (value) async => await controller.onChangedUseUppercase(),
          title: Text(
            TranslationConstants.uppercaseLetters.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),

        //lowercase
        SwitchListTile(
          activeColor: AppColors.blue400,
          value: controller.useLowercase.value,
          onChanged: (value) async => await controller.onChangedUseLowercase(),
          title: Text(
            TranslationConstants.lowercaseLetters.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),

        // numbers
        SwitchListTile(
          activeColor: AppColors.blue400,
          value: controller.useNumbers.value,
          onChanged: (value) async => await controller.onChangedUseNumbers(),
          title: Text(
            TranslationConstants.numbers.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),

        //special
        SwitchListTile(
          activeColor: AppColors.blue400,
          value: controller.useSpecial.value,
          onChanged: (value) async => await controller.onChangedUseSpecial(),
          title: Text(
            TranslationConstants.specialCharacters.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),

        // min numbers
        ListTile(
          title: Text(
            TranslationConstants.minimumNumbers.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
          trailing: Obx(
            () => _buildChangeQuantity(
              onPressedIncrease: () async =>
                  await controller.increaseMinimumNumbers(),
              onPressedDecrease: () async =>
                  await controller.decreaseMinimumNumbers(),
              value: controller.minNumbers.value,
            ),
          ),
        ),

        //min special
        ListTile(
          title: Text(
            TranslationConstants.minimumSpecial.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
          trailing: Obx(
            () => _buildChangeQuantity(
              onPressedIncrease: () async =>
                  await controller.increaseMinimumSpecial(),
              onPressedDecrease: () async =>
                  await controller.decreaseMinimumSpecial(),
              value: controller.minSpecial.value,
            ),
          ),
        ),

        //avoid Ambiguous
        SwitchListTile(
          activeColor: AppColors.blue400,
          value: controller.avoidAmbiguous.value,
          onChanged: (value) async =>
              await controller.onChangedAvoidAmbiguous(),
          title: Text(
            TranslationConstants.avoidAmbiguousCharacters.tr,
            style: ThemeText.bodyRegular.grey600Color,
          ),
        ),
      ],
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
              size: AppDimens.space_24,
              asset: Assets.images.svg.icCopy,
            ),
          ),
          SizedBox(
            width: AppDimens.space_16,
          ),
          AppTouchable(
            onPressed: () => controller.generatePassword(),
            child: AppImageWidget(
              size: AppDimens.space_24,
              asset: Assets.images.svg.icGenerator,
            ),
          ),
        ],
      ),
    );
  }
}
