import 'package:flutter/material.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class ConfirmWidget extends StatelessWidget {
  const ConfirmWidget({
    Key? key,
    required this.firstOnTap,
    required this.firstText,
    this.secondOnTap,
    this.secondText,
    this.activeFirst = false,
  }) : super(key: key);

  final String? secondText;
  final String firstText;
  final void Function()? secondOnTap;
  final void Function() firstOnTap;
  final bool activeFirst;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          secondText == null
              ? const SizedBox.shrink()
              : Expanded(
                  child: AppTouchable(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.space_16),
                    onPressed: secondOnTap,
                    child: Text(
                      secondText ?? '',
                      style: ThemeText.bodySemibold.blue600Color,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          Expanded(
            child: AppTouchable(
              padding: EdgeInsets.symmetric(vertical: AppDimens.space_16),
              onPressed: activeFirst ? firstOnTap : null,
              child: Text(
                firstText,
                style: ThemeText.bodySemibold.copyWith(
                    color: activeFirst ? AppColors.blue600 : AppColors.grey400),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
