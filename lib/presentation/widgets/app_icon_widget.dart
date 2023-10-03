import 'package:flutter/material.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class AppIconWidget extends StatelessWidget {
  final PasswordItem item;

  const AppIconWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.appIcon != null) {
      return AppImageWidget(
        bytes: item.appIcon!,
        padding: EdgeInsets.all(AppDimens.space_2),
        backgroundColor: AppColors.white,
        size: AppDimens.space_36,
        margin: EdgeInsets.all(AppDimens.space_4),
        borderRadius: BorderRadius.circular(AppDimens.radius_4),
      );
    }

    final firstLetter = (item.signInLocation ?? '')[0];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(AppDimens.radius_4),
      ),
      padding: EdgeInsets.all(AppDimens.space_2),
      margin: EdgeInsets.all(AppDimens.space_4),
      width: AppDimens.space_36,
      height: AppDimens.space_36,
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: ThemeText.bodyStrong.s24.blue400,
      ),
    );
  }
}
