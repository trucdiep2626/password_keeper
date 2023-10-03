import 'package:flutter/material.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const AppShimmer(
      {Key? key,
      this.width,
      this.height,
      this.backgroundColor,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey300!,
      highlightColor: AppColors.grey200!,
      child: Container(
        width: width ?? 20,
        height: height ?? 20,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppDimens.radius_4),
        ),
      ),
    );
  }
}
