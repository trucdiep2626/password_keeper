import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_keeper/common/constants/app_dimens.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/gen/assets.gen.dart';
import 'package:password_keeper/presentation/theme/export.dart';

import 'export.dart';

class AppTextField extends StatefulWidget {
  final bool readOnly;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function()? onPressed;

  const AppTextField({
    Key? key,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.onPressed,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isShowClose = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTouchable(
          onPressed: widget.readOnly ? () {} : null,
          child: Material(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(AppDimens.radius_12),
            child: Stack(
              children: [
                TextFormField(
                  readOnly: widget.readOnly,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  style: ThemeText.bodyRegular,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  onChanged: (value) {
                    if (!isNullEmpty(widget.onChanged)) {
                      widget.onChanged!(value);
                    }
                    setState(() {
                      if (!isNullEmpty(value)) {
                        _isShowClose = true;
                      } else {
                        _isShowClose = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColors.grey),
                    suffixIcon: _isShowClose
                        ? AppTouchable(
                            padding: EdgeInsets.all(AppDimens.space_16),
                            onPressed: () {
                              if (!isNullEmpty(widget.onChanged)) {
                                widget.onChanged!('');
                              }
                              setState(() {
                                _isShowClose = false;
                                widget.controller!.text = '';
                              });
                            },
                            child: AppImageWidget(
                              asset: Assets.images.svg.icCircleClose,
                              color: AppColors.grey,
                              width: AppDimens.space_16,
                              height: AppDimens.space_16,
                            ),
                          )
                        : const SizedBox.shrink(),
                    isDense: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppDimens.space_16,
                      horizontal: AppDimens.space_16,
                    ),
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
                widget.readOnly
                    ? Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: AppColors.transparent,
                            splashColor: AppColors.transparent,
                            customBorder: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimens.radius_12)),
                            onTap: widget.onPressed,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Container(
          height: AppDimens.height_24,
          padding: EdgeInsets.symmetric(
            // vertical: AppDimens.space_8,
            horizontal: AppDimens.space_16,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.errorText!,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: AppColors.red),
          ),
        )
      ],
    );
  }
}
