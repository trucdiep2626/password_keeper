import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/journey/settings/settings_controller.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_button.dart';

class TimeoutPicker extends StatefulWidget {
  final int timeIndex;
  final int typeIndex;
  final Function(String, int) confirmButtonCallback;

  const TimeoutPicker({
    Key? key,
    this.timeIndex = 0,
    this.typeIndex = 1,
    required this.confirmButtonCallback,
  }) : super(key: key);

  @override
  State<TimeoutPicker> createState() => _TimeoutPickerState();
}

class _TimeoutPickerState extends State<TimeoutPicker> {
  List<int> numbers = List<int>.generate(59, (i) => i + 1);
  List<String> times = [
    TranslationConstants.hours.tr,
    TranslationConstants.minutes.tr,
    TranslationConstants.seconds.tr,
  ];
  int selectedNumber = 10;
  String selectedTime = TranslationConstants.seconds.tr;

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
                    TranslationConstants.timeout.tr,
                    textAlign: TextAlign.start,
                    style: ThemeText.bodySemibold.s16
                        .copyWith(color: AppColors.blue500),
                  ),
                  SizedBox(height: AppDimens.space_8),
                  Expanded(
                    child: SizedBox(
                      width: Get.width - 2 * AppDimens.space_16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 32.0,
                              scrollController: FixedExtentScrollController(
                                  initialItem: widget.timeIndex),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedNumber = numbers[index];
                                });
                              },
                              children: numbers
                                  .map((value) => Text(value.toString()))
                                  .toList(),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 32.0,
                              scrollController: FixedExtentScrollController(
                                  initialItem: widget.typeIndex),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedTime = times[index];
                                });
                              },
                              children:
                                  times.map((value) => Text(value)).toList(),
                            ),
                          )
                        ],
                      ),
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
                              selectedTime, selectedNumber),
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
