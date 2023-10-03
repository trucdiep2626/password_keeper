import 'package:flutter/material.dart';
import 'package:password_keeper/common/utils/app_screen_utils/flutter_screenutils.dart';
import 'package:password_keeper/gen/fonts.gen.dart';

import 'theme_color.dart';

class ThemeText {
  /// Text style
  static final TextStyle bodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    fontFamily: FontFamily.mr,
    color: AppColors.black,
  );

  static final TextStyle bodyMedium = bodyRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodySemibold = bodyRegular.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle bodyStrong = bodyRegular.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle bodyUnderline = bodyRegular.copyWith(
    decoration: TextDecoration.underline,
  );

  static final TextStyle bodyStrikethrough = bodyRegular.copyWith(
    decoration: TextDecoration.lineThrough,
  );

  static final TextStyle bodyItalic = bodyRegular.copyWith(
    fontStyle: FontStyle.italic,
  );

  static final TextStyle description = bodyRegular.copyWith(
    fontSize: 12.sp,
  );

  static final TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    fontFamily: FontFamily.mr,
    color: AppColors.blue500,
  );

  static final TextStyle heading1 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 32.sp,
    fontFamily: FontFamily.mr,
    color: AppColors.blue500,
  );

  static final TextStyle heading2 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    fontFamily: FontFamily.mr,
    color: AppColors.blue500,
  );

  static final TextStyle heading3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    fontFamily: FontFamily.mr,
    color: AppColors.blue500,
  );

  static final TextStyle heading4 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    fontFamily: FontFamily.mr,
    color: AppColors.blue500,
  );

  static final TextStyle errorText = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    fontFamily: FontFamily.mr,
    color: AppColors.errorColor,
  );
}

extension CommonFontWeight on TextStyle {
  /// FontWeight.w100
  TextStyle w100([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w100,
        fontSize: fontSize,
      );

  /// FontWeight.w200
  TextStyle w200([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w200,
        fontSize: fontSize,
      );

  /// FontWeight.w300
  TextStyle w300([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w300,
        fontSize: fontSize,
      );

  /// FontWeight.w400
  TextStyle w400([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
      );

  /// FontWeight.w500
  TextStyle w500([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
      );

  /// FontWeight.w600
  TextStyle w600([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
      );

  /// FontWeight.w700
  TextStyle w700([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
      );

  /// FontWeight.w800
  TextStyle w800([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
      );

  /// FontWeight.w900
  TextStyle w900([double? fontSize]) => copyWith(
        fontWeight: FontWeight.w900,
        fontSize: fontSize,
      );
}

extension CommonFontSize on TextStyle {
  /// custom fontSize
  TextStyle fSize(double fontSize) => copyWith(
        fontSize: fontSize,
      );

  /// fontSize: 10
  TextStyle get s10 => copyWith(
        fontSize: 10.sp,
      );

  /// fontSize: 12
  TextStyle get s12 => copyWith(
        fontSize: 12.sp,
      );

  /// fontSize: 14
  TextStyle get s14 => copyWith(
        fontSize: 14.sp,
      );

  /// fontSize: 15
  TextStyle get s15 => copyWith(
        fontSize: 15.sp,
      );

  /// fontSize: 16
  TextStyle get s16 => copyWith(
        fontSize: 16.sp,
      );

  /// fontSize: 17
  TextStyle get s17 => copyWith(
        fontSize: 17.sp,
      );

  /// fontSize: 18
  TextStyle get s18 => copyWith(
        fontSize: 18.sp,
      );

  /// fontSize: 20
  TextStyle get s20 => copyWith(
        fontSize: 20.sp,
      );

  /// fontSize: 24
  TextStyle get s24 => copyWith(
        fontSize: 24.sp,
      );

  /// fontSize: 32
  TextStyle get s32 => copyWith(
        fontSize: 32.sp,
      );

  /// fontSize: 36
  TextStyle get s36 => copyWith(
        fontSize: 36.sp,
      );

  /// fontSize: 40
  TextStyle get s40 => copyWith(
        fontSize: 40.sp,
      );

  /// fontSize: 48
  TextStyle get s48 => copyWith(
        fontSize: 48.sp,
      );
}

extension CommonFontColor on TextStyle {
  /// custom color
  TextStyle setColor(Color? color) => copyWith(color: color);

  /// color: AppColors.white,
  TextStyle get colorWhite => copyWith(color: AppColors.white);

  /// color: AppColors.black,
  TextStyle get colorBlack => copyWith(color: AppColors.black);

  /// color: AppColors.blue100;
  TextStyle get blue100Color => copyWith(color: AppColors.blue100);

  /// color: AppColors.blue200;
  TextStyle get blue200Color => copyWith(color: AppColors.blue200);

  /// color: AppColors.blue300;
  TextStyle get blue300Color => copyWith(color: AppColors.blue300);

  /// color: AppColors.blue400;
  TextStyle get blue400Color => copyWith(color: AppColors.blue400);

  /// color: AppColors.blue500;
  TextStyle get blue500Color => copyWith(color: AppColors.blue500);

  /// color: AppColors.blue600;
  TextStyle get blue600Color => copyWith(color: AppColors.blue600);
  //
  // /// color: AppColors.blue700;
  // TextStyle get blue700Color => copyWith(color: AppColors.blue700);
  //
  // /// color: AppColors.blue800;
  // TextStyle get blue800Color => copyWith(color: AppColors.blue800);
  //
  // /// color: AppColors.blue900;
  // TextStyle get blue900Color => copyWith(color: AppColors.blue900);

  /// color: AppColors.grey100;
  TextStyle get grey100Color => copyWith(color: AppColors.grey100);

  /// color: AppColors.grey200;
  TextStyle get grey200Color => copyWith(color: AppColors.grey200);

  /// color: AppColors.grey300;
  TextStyle get grey300Color => copyWith(color: AppColors.grey300);

  /// color: AppColors.orange900;
  TextStyle get grey400Color => copyWith(color: AppColors.grey400);

  /// color: AppColors.grey;
  TextStyle get grey500Color => copyWith(color: AppColors.grey);

  /// color: AppColors.grey600;
  TextStyle get grey600Color => copyWith(color: AppColors.grey600);

  /// color: AppColors.grey700;
  TextStyle get grey700Color => copyWith(color: AppColors.grey700);

  /// color: AppColors.grey800;
  TextStyle get grey800Color => copyWith(color: AppColors.grey800);

  /// color: AppColors.transparent;
  TextStyle get transparentColor => copyWith(color: AppColors.transparent);

  /// color: AppColors.errorColor;
  TextStyle get errorColor => copyWith(color: AppColors.errorColor);

  // /// color: AppColors.errorColor2;
  // TextStyle get errorColor2 => copyWith(color: AppColors.errorColor2);

  /// color: AppColors.primary,
  TextStyle get primary => copyWith(color: AppColors.primary);

  /// color: AppColors.background,
  TextStyle get background => copyWith(color: AppColors.background);

  /// color: AppColors.backgroundColor;
  TextStyle get backgroundColor => copyWith(color: AppColors.backgroundColor);

  /// color: AppColors.bianca;
  TextStyle get bianca => copyWith(color: AppColors.bianca);

  /// color: AppColors.charade;
  TextStyle get charade => copyWith(color: AppColors.charade);

  /// color: AppColors.blue100,
  TextStyle get blue100 => copyWith(color: AppColors.blue100);

  /// color: AppColors.blue200,
  TextStyle get blue200 => copyWith(color: AppColors.blue200);

  /// color: AppColors.blue300,
  TextStyle get blue300 => copyWith(color: AppColors.blue300);

  /// color: AppColors.blue400,
  TextStyle get blue400 => copyWith(color: AppColors.blue400);

  /// color: AppColors.blue500,
  TextStyle get blue500 => copyWith(color: AppColors.blue500);

  /// color: AppColors.red,
  TextStyle get red => copyWith(color: AppColors.red);

  /// color: AppColors.redAccent,
  TextStyle get redAccent => copyWith(color: AppColors.redAccent);

  /// color: AppColors.red50,
  TextStyle get red50 => copyWith(color: AppColors.red50);

  /// color: AppColors.red100,
  TextStyle get red100 => copyWith(color: AppColors.red100);

  /// color: AppColors.black45,
  TextStyle get black45 => copyWith(color: AppColors.black45);

  /// color: AppColors.black54,
  TextStyle get black54 => copyWith(color: AppColors.black54);
}
