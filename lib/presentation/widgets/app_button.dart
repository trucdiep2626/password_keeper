import 'package:flutter/material.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/export.dart';

import 'app_image_widget.dart';

class OutlinedAppButton {}

class AppButton extends StatelessWidget {
  final String title;
  final LoadedType? loaded;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? width;
  final Function()? onPressed;
  final bool enable;

  const AppButton({
    Key? key,
    this.enable = true,
    required this.title,
    this.loaded = LoadedType.finish,
    this.backgroundColor = AppColors.blue400,
    this.titleColor = AppColors.white,
    this.width,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: width ?? double.infinity,
          height: AppDimens.height_52,
          child: TextButton(
            onPressed: enable
                ? () {
                    hideKeyboard();
                    if (!isNullEmpty(onPressed)) {
                      onPressed!();
                    }
                  }
                : null,
            style: ButtonStyle(
              textStyle: MaterialStateProperty.resolveWith(
                (states) => ThemeText.bodySemibold,
              ),
              // padding: MaterialStateProperty.resolveWith(
              //   (states) => widget.padding,
              // ),
              enableFeedback: true,
              foregroundColor: MaterialStateColor.resolveWith(
                (states) =>
                    isNullEmpty(onPressed) ? titleColor! : AppColors.white,
              ),
              overlayColor: MaterialStateColor.resolveWith(
                (states) => AppColors.white.withOpacity(0.1),
              ),
              splashFactory: null,
              elevation: MaterialStateProperty.resolveWith(
                (states) => 0.0,
              ),
              backgroundColor: MaterialStateColor.resolveWith(
                (states) {
                  if (isNullEmpty(onPressed) || !enable) {
                    return AppColors.grey;
                  } else {
                    if (loaded == LoadedType.start) {
                      return backgroundColor!.withOpacity(0.7);
                    } else {
                      return backgroundColor!;
                    }
                  }
                },
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radius_12),
                ),
              ),
            ),
            child: loaded == LoadedType.start
                ? const SizedBox.shrink()
                : Text(
                    title,
                    style:
                        ThemeText.bodySemibold.s16.copyWith(color: titleColor),
                  ),
          ),
        ),
        loaded == LoadedType.start
            ? SizedBox(
                height: AppDimens.height_60,
                child: AppImageWidget(
                  asset: Assets.images.svg.loadingButton,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
