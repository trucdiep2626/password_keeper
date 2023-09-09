import 'package:flutter/material.dart';
import 'package:password_keeper/presentation/theme/export.dart';

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
    return Row(
      children: [
        secondText == null
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: secondOnTap,
                child: Expanded(
                  child: Text(
                    secondText ?? '',
                    style: ThemeText.bodyMedium,
                  ),
                ),
              ),
        GestureDetector(
          onTap: activeFirst ? firstOnTap : null,
          child: Expanded(
            child: Text(
              firstText ?? '',
              style: ThemeText.bodyMedium.copyWith(
                  color: activeFirst ? AppColors.black : AppColors.grey600),
            ),
          ),
        ),
      ],
    );
  }
}
