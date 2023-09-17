import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:password_keeper/presentation/widgets/app_button.dart';

Future showAppDialog(BuildContext context, String titleText, String messageText,
    {Widget? messageWidget,
    String? iconPath,
    bool isIconSvg = false,
    bool customBody = false,
    Widget? widgetBody,
    required String confirmButtonText,
    Color confirmButtonColor = AppColors.blue200,
    VoidCallback? confirmButtonCallback,
    //   ButtonState? confirmButtonState,
    String? cancelButtonText,
    Color cancelButtonColor = AppColors.white,
    VoidCallback? cancelButtonCallback,
    bool dismissAble = false,
    WidgetBuilder? builder,
    bool? delayConfirm,
    TextAlign? messageTextAlign}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissAble,
    builder: builder ??
        (BuildContext context) => AppDialog(
              delayConfirm: delayConfirm,
              title: titleText,
              message: messageText,
              messageWidget: messageWidget,
              iconPath: iconPath,
              isIconSvg: isIconSvg,
              customBody: customBody,
              widgetBody: widgetBody,
              confirmButtonText: confirmButtonText,
              confirmButtonColor: confirmButtonColor,
              confirmButtonCallback: confirmButtonCallback,
              //      confirmButtonState: confirmButtonState,
              cancelButtonText: cancelButtonText,
              cancelButtonCallback: cancelButtonCallback,
              //  firstBtnState: firstBtnState,
              messageTextAlign: TextAlign.start,
            ),
  );
}

class AppDialog extends StatefulWidget {
  final String? title;
  final String message;
  final Widget? messageWidget;
  final String? iconPath;
  final bool isIconSvg;
  final bool customBody;
  final bool dismissAble;
  final Widget? widgetBody;
  final String confirmButtonText;
  final Color confirmButtonColor;
  final VoidCallback? confirmButtonCallback;
  // final ButtonState? confirmButtonState;
  final String? cancelButtonText;
  final Color? cancelButtonColor;
  final VoidCallback? cancelButtonCallback;
  final bool? delayConfirm;
//  final ButtonState? firstBtnState;
  final TextAlign messageTextAlign;

  const AppDialog(
      {Key? key,
      this.title,
      required this.message,
      this.messageWidget,
      this.iconPath,
      this.isIconSvg = false,
      this.customBody = false,
      this.dismissAble = false,
      this.widgetBody,
      required this.confirmButtonText,
      required this.confirmButtonColor,
      this.confirmButtonCallback,
      this.cancelButtonText,
      this.cancelButtonColor,
      this.cancelButtonCallback,
      required this.messageTextAlign,
      //  this.confirmButtonState,
      this.delayConfirm = false})
      : super(key: key);

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  bool enableConfirm = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.dismissAble,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(
        //     AppDimens.radius_5,
        //   ),
        // ),
        // elevation: 0.0,
        backgroundColor: AppColors.transparent,
        child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppUtils.isNullEmpty(widget.iconPath)
                //     ? const SizedBox.shrink()
                //     : Center(
                //         child: AppImage.asset(
                //           path: widget.iconPath!,
                //           height: AppDimens.height_35,
                //           fit: BoxFit.fill,
                //         ),
                //       ),
                isNullEmpty(widget.title)
                    ? const SizedBox.shrink()
                    : Text(
                        widget.title!,
                        textAlign: TextAlign.start,
                        style: ThemeText.bodySemibold.s16
                            .copyWith(color: AppColors.blue500),
                      ),
                SizedBox(height: AppDimens.space_8),
                Text(
                  widget.message,
                  textAlign: widget.messageTextAlign,
                  style: ThemeText.bodyRegular,
                ),
                SizedBox(height: AppDimens.space_16),
                Visibility(
                  visible: enableConfirm,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (widget.cancelButtonText != null)
                        Expanded(
                          child: AppButton(
                            titleColor: AppColors.blue400,
                            titleFontSize: AppDimens.space_14,
                            //   margin: EdgeInsets.all(0),
                            //   borderRadius: BorderRadius.circular(0),
                            //    textStyle: ThemeText.button
                            //        .copyWith(color: AppColors.grey),
                            title: widget.cancelButtonText ??
                                TranslationConstants.cancel.tr,
                            backgroundColor: AppColors.transparent,
                            onPressed:
                                widget.cancelButtonCallback ?? () => Get.back(),
                          ),
                        ),
                      Expanded(
                        child: AppButton(
                          //   margin: EdgeInsets.all(0),
                          title: widget.confirmButtonText,
                          titleFontSize: AppDimens.space_14,
                          onPressed: widget.confirmButtonCallback,
                          // buttonState:
                          //     widget.confirmButtonState ?? ButtonState.active,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!isNullEmpty(widget.delayConfirm)) {
      setState(() {
        enableConfirm = false;
      });
      Future.delayed(const Duration(seconds: 5)).then((value) => setState(() {
            enableConfirm = true;
          }));
    }
  }
}
