import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_button.dart';
import 'package:password_keeper/presentation/widgets/app_text_field_widget.dart';

class TimingAlertDialog extends StatefulWidget {
  final int timingAlert;
  final Function(int) confirmButtonCallback;

  const TimingAlertDialog({
    Key? key,
    this.timingAlert = 60,
    required this.confirmButtonCallback,
  }) : super(key: key);

  @override
  State<TimingAlertDialog> createState() => _TimingAlertDialogState();
}

class _TimingAlertDialogState extends State<TimingAlertDialog> {
  final TextEditingController _timingAlertController = TextEditingController();
  String errorText = '';
  bool enableConfirmButton = false;

  @override
  void initState() {
    super.initState();
    _timingAlertController.addListener(() {
      setState(() {
        enableConfirmButton = _timingAlertController.text.isNotEmpty;
      });
    });
    _timingAlertController.text = widget.timingAlert.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: Get.find<SettingsController>().handleUserInteraction,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: AppColors.transparent,
          child: Container(
            height: Get.height / 2,
            margin: EdgeInsets.all(AppDimens.space_16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppDimens.radius_12,
              ),
              color: AppColors.white,
            ),
            width: Get.width - 2 * AppDimens.space_16,
            child: Padding(
              padding: EdgeInsets.all(AppDimens.space_16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    TranslationConstants.scheduleAlertTimingTitle.tr,
                    textAlign: TextAlign.start,
                    style: ThemeText.bodySemibold.s16
                        .copyWith(color: AppColors.blue500),
                  ),
                  SizedBox(height: AppDimens.space_8),
                  Text(
                    TranslationConstants.scheduleAlertTimingDescription.tr,
                    textAlign: TextAlign.start,
                    style: ThemeText.bodyRegular,
                  ),
                  AppTextField(
                    controller: _timingAlertController,
                    keyboardType: TextInputType.numberWithOptions(),
                    errorText: errorText,
                    textInputAction: TextInputAction.done,
                    suffixIcon: Text(
                      TranslationConstants.days.tr,
                      style: ThemeText.bodyRegular,
                    ),
                  ),
                  SizedBox(height: AppDimens.space_16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: AppButton(
                          titleColor: AppColors.blue400,
                          titleFontSize: AppDimens.space_14,
                          title: TranslationConstants.cancel.tr,
                          backgroundColor: AppColors.transparent,
                          onPressed: () => Get.back(),
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          title: TranslationConstants.confirm.tr,
                          titleFontSize: AppDimens.space_14,
                          onPressed: () => widget.confirmButtonCallback(
                              int.tryParse(_timingAlertController.text) ?? 60),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
