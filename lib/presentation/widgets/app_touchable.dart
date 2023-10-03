import 'package:flutter/material.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/presentation/theme/export.dart';

class AppTouchable extends StatelessWidget {
  final Function()? onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? rippleColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final OutlinedBorder? outlinedBorder;
  final BorderRadius? borderRadius;
  final AlignmentGeometry? alignment;

  const AppTouchable({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.rippleColor,
    this.padding,
    this.margin,
    this.outlinedBorder,
    this.borderRadius,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.zero,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              backgroundColor ?? AppColors.transparent),
          overlayColor: MaterialStateProperty.all(
              rippleColor ?? const Color.fromRGBO(204, 223, 242, 0.4)),
          shape: MaterialStateProperty.all(
            outlinedBorder ??
                RoundedRectangleBorder(
                  borderRadius: borderRadius ??
                      BorderRadius.circular(AppDimens.radius_12),
                ),
          ),
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
