import 'package:flutter/material.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/theme_color.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class AppLoginSocialWidget extends StatelessWidget {
  const AppLoginSocialWidget({Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final SvgGenImage icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
         AppDimens.space_12 ,
        ),
        decoration:   BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey200!,
              offset: Offset(
                0,
                AppDimens.space_4,
              ),
              blurRadius:  AppDimens.space_8,
            ),
          ],
        ),
        child: AppImageWidget(
          asset: icon,
          height:  AppDimens.space_24 ,
        ),
      ),
    );
  }
}
