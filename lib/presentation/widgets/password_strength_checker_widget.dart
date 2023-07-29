import 'package:flutter/material.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/password_helper.dart';
import 'package:password_keeper/presentation/theme/export.dart';

class PasswordStrengthChecker extends StatelessWidget {
  const PasswordStrengthChecker({
    Key? key,
    required this.passwordStrength,
  }) : super(key: key);

  final PasswordStrengthLevel passwordStrength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimens.space_8),
      child: LinearProgressIndicator(
        value: passwordStrength.lineLength,
        backgroundColor: AppColors.grey300,
        color: passwordStrength.color,
        minHeight: 15,
      ),
    );
  }
}
